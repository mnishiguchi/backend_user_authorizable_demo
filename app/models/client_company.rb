# ClientCompany represents a property company. It can be a management who manages
# other ClientCompany or be managed by a management ClientCompany.
# Therefore the relations between ClientCompanies will be a family-tree structure.
class ClientCompany < ApplicationRecord
  # Provides associations to client_user and account_executive
  include Authorizable

  belongs_to :management_client_company, class_name: "ClientCompany",
                                         optional: true

  has_many :managed_client_companies, class_name: "ClientCompany",
                                      foreign_key: :management_client_company_id

  scope :unclaimed,          -> { where(management_client_company_id: nil) }
  scope :property_clients,   -> { where(managing: false) }
  scope :management_clients, -> { where(managing: true)  }

  has_many :property_containers

  def accessible_property_containers
    PropertyContainer.where(client_company_id: accessible_client_company_ids)
    # If it's simpler, this is what this query is actually doing - if the denormalized approach ever causes problems (race conditions etc.) we could fall back to this approach, but it is at least 25x slower. 200ms vs 2ms, huge difference in the views etc. especially considering this method will have to be called for each backend_user_authorizable
    query = property_containers
    managed_client_companies.each do |management_client_company|
      query = query.or(management_client_company.accessible_property_containers)
    end
    query
  end

  def is_management_client?
    management_client
  end

  def access_level(backend_user)
    backend_user_authorizables.where(backend_user: backend_user).first&.access_level ||
    management_client_company&.access_level(backend_user)
  end

  # Denormalized caching for access to property containers

  def set_accessible_client_company_ids(new_ids)
    # It's a management client if any property client ids are accessible beyond it's own
    update_column(:management_client, (new_ids - [id]).any?)
    update_column(:accessible_client_company_ids, new_ids)
  end

  # After create, initialize the accessible_client_company_ids
  # Has to happen after create because we need our id
  after_create -> () {
    initial_accessible_client_company_ids = [
      id,
      *managed_client_companies.flat_map(&:accessible_client_company_ids)
    ]
    set_accessible_client_company_ids(initial_accessible_client_company_ids)
  }
  around_save    :around_save_modify_accessible_client_company_ids
  around_destroy :around_destroy_modify_accessible_client_company_ids

  def modify_accessible_client_company_ids(ids_to_add = [], ids_to_remove = [])
    new_ids     = ids_to_add    - accessible_client_company_ids
    removed_ids = ids_to_remove & accessible_client_company_ids
    if new_ids.any? || removed_ids.any?
      set_accessible_client_company_ids(accessible_client_company_ids + new_ids - removed_ids)
      management_client_company&.modify_accessible_client_company_ids(new_ids, removed_ids)
    end
  end

  # If forced, it saves it immediately - otherwise it is assumed the model is in the process of being saved, and it just sets the attribute.
  # In either case, it force pushes updates to a parent if something has changed.
  def around_save_modify_accessible_client_company_ids
    if management_client_company_id_changed?
      # remove ids from old one
      ClientCompany.find(management_client_company_id_was)&.modify_accessible_client_company_ids([], accessible_client_company_ids) if management_client_company_id_was
      yield
      # add ids to new one
      management_client_company&.modify_accessible_client_company_ids(accessible_client_company_ids, [])
    else
      yield
    end
  end

  def around_destroy_modify_accessible_client_company_ids
    management_client = management_client_company
    ids_to_remove = accessible_client_company_ids
    yield
    management_client&.modify_accessible_client_company_ids([], ids_to_remove)
  end
end

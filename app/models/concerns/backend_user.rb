module BackendUser
  extend ActiveSupport::Concern

  included do
    has_one :identity, as: :backend_user

    # We enforce backend user authorization by registering their authorization
    # informatin to AuthorizedAccess table and allow them to access things
    # only through their own registered AuthorizedAccess.
    has_many :authorized_access, as: :backend_user
    has_many :client_companies, through: :authorized_access, source: :authorizable,
                                                             source_type: "ClientCompany"

    def accessible_property_containers
      ids   = client_companies.flat_map(&:accessible_client_company_ids)
      where = { client_company_id: ids }
      PropertyContainer.where(where)
    end

    def can_access?(authorizable)
      access_level(authorizable)
    end

    # access_level can be :read, :edit, etc
    def access_level(authorizable)
      case authorizable
      when PropertyContainer
        access_level(authorizable.client_company)
      when ClientCompany
        authorizable.access_level(self)
      end
    end

    def can_edit?(authorizable)
      access_level(authorizable) == :edit
    end
  end

end

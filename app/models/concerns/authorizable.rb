module Authorizable
  extend ActiveSupport::Concern

  included do
    has_many :authorized_access, as: :authorizable

    accepts_nested_attributes_for :authorized_access, reject_if: :all_blank,
                                                      allow_destroy: true

    has_many :client_users,       through: :authorized_access,
                                  source: :backend_user,
                                  source_type: "ClientUser"

    has_many :account_executives, through: :authorized_access,
                                  source: :backend_user,
                                  source_type: "AccountExecutive"
  end
end

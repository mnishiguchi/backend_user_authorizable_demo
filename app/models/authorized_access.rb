class AuthorizedAccess < ApplicationRecord
  belongs_to :backend_user, polymorphic: true
  belongs_to :authorizable,    polymorphic: true

  validate :valid_access_level?

  def access_level
    super&.to_sym
  end

  private

  VALID_ACCESS_LEVELS = [:edit, :view]

  def valid_access_level?
    unless VALID_ACCESS_LEVELS.include?(access_level)
      errors.add(:access_level, "Invalid access level")
    end
  end
end

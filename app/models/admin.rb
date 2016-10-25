class Admin < ApplicationRecord
  include BackendUser

  # Override what we get from BackendUser
  def can_access?(authorizable);  true  end
  def access_level(authorizable); :edit end

  def authorized_access; []  end
end

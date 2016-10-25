class CreateAuthorizedAccesses < ActiveRecord::Migration[5.0]
  def change
    create_table :authorized_accesses do |t|
      t.string     :access_level

      # http://stackoverflow.com/questions/5443740/how-to-handle-too-long-index-names-in-a-rails-migration-with-mysql
      t.references :backend_user, polymorphic: true, index: { name: :index_this_on_backend_user_type_and_id }
      t.references :authorizable, polymorphic: true, index: { name: :index_this_on_authorizable_type_and_id }

      t.timestamps
    end
  end
end

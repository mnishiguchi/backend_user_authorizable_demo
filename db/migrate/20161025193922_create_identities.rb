class CreateIdentities < ActiveRecord::Migration[5.0]
  def change
    create_table :identities do |t|
      t.string :email, null: false, default: ""

      t.references :backend_user, polymorphic: true, index: true
      t.references :user,                            index: true

      t.timestamps
    end
  end
end

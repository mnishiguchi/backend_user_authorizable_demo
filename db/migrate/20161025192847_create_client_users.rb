class CreateClientUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :client_users do |t|
      t.string :name

      t.timestamps
    end
  end
end

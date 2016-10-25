class CreateClientCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :client_companies do |t|
      t.string  :name

      # This flag determine whether it is a management or a managed.
      t.boolean :managing, index: true

      # Reference to a Management ClientCompany if any.
      t.references :management_client_company, index: true

      # The ids of all children and itself.
      t.integer :accessible_client_company_ids , array: true

      t.timestamps
    end
  end
end

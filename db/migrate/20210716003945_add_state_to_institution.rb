class AddStateToInstitution < ActiveRecord::Migration[6.1]
  def change
    add_column :institutions, :state, :string
  end
end

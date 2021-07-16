class AddCityToInstitution < ActiveRecord::Migration[6.1]
  def change
    add_column :institutions, :city, :string
  end
end

class AddNameToRiskLevels < ActiveRecord::Migration[5.2]
  def change
    add_column :risk_levels, :name, :string
    
  end
end

class RemoveColumnFromRiskLevel < ActiveRecord::Migration[5.2]
  def change
    remove_column :risk_levels, :range
  end
end

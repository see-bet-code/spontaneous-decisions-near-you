class AddAssociationsToPlans < ActiveRecord::Migration[5.2]
  def change
    add_column :plans, :user_id, :integer
    add_column :plans, :risk_level_id, :integer
  end
end

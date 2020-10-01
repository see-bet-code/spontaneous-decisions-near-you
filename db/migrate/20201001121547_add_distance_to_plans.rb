class AddDistanceToPlans < ActiveRecord::Migration[5.2]
  def change
    add_column :plans, :distance, :float
  end
end

class AddSelectedToPlans < ActiveRecord::Migration[5.2]
  def change
    add_column :plans, :selected?, :boolean
  end
end

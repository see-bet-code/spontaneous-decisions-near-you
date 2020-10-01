class AddDescriptionToPlans < ActiveRecord::Migration[5.2]
  def change
    add_column :plans, :desc, :text
  end
end

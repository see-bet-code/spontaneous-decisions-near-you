class AddUrlToPlans < ActiveRecord::Migration[5.2]
  def change
    add_column :plans, :url, :string
  end
end

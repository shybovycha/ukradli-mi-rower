class CreateFoundAlerts < ActiveRecord::Migration
  def change
    create_table :found_alerts do |t|
      t.float :lat
      t.float :lon

      t.timestamps
    end
  end
end

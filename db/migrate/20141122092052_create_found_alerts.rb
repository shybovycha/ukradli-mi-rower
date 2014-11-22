class CreateFoundAlerts < ActiveRecord::Migration
  def change
    create_table :found_alerts do |t|
      t.string :title
      t.text :description
      t.float :lat
      t.float :lon
      t.integer :user_id
      t.integer :lost_alert_id

      t.timestamps
    end
  end
end

class CreateLostAlerts < ActiveRecord::Migration
  def change
    create_table :lost_alerts do |t|
      t.float :lat
      t.float :lon

      t.timestamps
    end
  end
end

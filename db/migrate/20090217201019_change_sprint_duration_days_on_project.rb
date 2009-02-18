class ChangeSprintDurationDaysOnProject < ActiveRecord::Migration
  def self.up
    change_column :projects, :sprint_duration_days, :integer, :default=>14
  end

  def self.down
    change_column :projects, :sprint_duration_days, :integer, :default=>10
  end
end

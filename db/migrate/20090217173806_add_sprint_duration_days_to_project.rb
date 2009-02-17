class AddSprintDurationDaysToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :sprint_duration_days, :integer, :default=>10
  end

  def self.down
    remove_column :projects, :sprint_duration_days
  end
end

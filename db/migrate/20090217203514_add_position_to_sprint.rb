class AddPositionToSprint < ActiveRecord::Migration
  def self.up
    add_column :sprints, :position, :integer
  end

  def self.down
    remove_column :sprints, :position
  end
end

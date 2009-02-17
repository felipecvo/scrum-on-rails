class AddPriorityToStories < ActiveRecord::Migration
  def self.up
    add_column :stories, :position, :integer
  end

  def self.down
    remove_column :stories, :position
  end
end

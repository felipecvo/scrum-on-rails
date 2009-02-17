class CreateTableSprintsStories < ActiveRecord::Migration
  def self.up
    create_table :sprints_stories do |t|
      t.integer :sprint_id
      t.integer :story_id
      t.timestamps
    end

     add_column :projects, :status, :boolean, :default=>false
     add_column :stories, :status, :boolean, :default=>false
  end

  def self.down
     drop_table :sprints_stories
     remove_column :projects, :status
     remove_column :stories, :status
  end
end

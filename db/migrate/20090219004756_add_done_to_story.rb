class AddDoneToStory < ActiveRecord::Migration
  def self.up
    rename_column :stories, :status, :done
  end

  def self.down
    rename_column :stories, :done, :status
  end
end

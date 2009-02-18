class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.integer :user_id
      t.integer :story_id
      t.string :description
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end

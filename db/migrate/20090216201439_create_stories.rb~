class CreateStories < ActiveRecord::Migration
  def self.up
    create_table :stories do |t|
      t.string :title
      t.string :as_a
      t.text :i_want_to
      t.text :so_i_can
      t.integer :estimate
      t.references :project
      t.timestamps
    end
  end

  def self.down
    drop_table :stories
  end
end

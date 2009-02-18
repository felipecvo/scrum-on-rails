class CreateWikis < ActiveRecord::Migration
  def self.up
    create_table :wikis do |t|
      t.integer :project_id
      t.string :title
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :wikis
  end
end

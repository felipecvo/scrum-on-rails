class CreateSprints < ActiveRecord::Migration
  def self.up
    create_table :sprints do |t|
      t.text :goal
      t.date :start_date
      t.date :end_date
      t.references :project

      t.timestamps
    end
  end

  def self.down
    drop_table :sprints
  end
end

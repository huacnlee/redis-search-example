class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :full_name
      t.string :description
      t.string :homepage
      t.string :language
      t.integer :watchers
      t.integer :forks
      t.string :url

      t.timestamps
    end
  end
end

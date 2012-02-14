class CreateLibraries < ActiveRecord::Migration
  def change
    create_table :libraries do |t|
      t.string   "url",         :default => "http://localhost:1337", :null => false
      t.string   "name"
      t.boolean  "online",      :default => false
      t.datetime "imported_at"

      t.timestamps
    end
  end
end

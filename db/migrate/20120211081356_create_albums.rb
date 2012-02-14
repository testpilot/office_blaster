class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string  :name, :null => false
      t.integer :artist_id, :null => false

      t.timestamps
    end
    add_index :albums, :name
    add_index :albums, :artist_id
  end
end

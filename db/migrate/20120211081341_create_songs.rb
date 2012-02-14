class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.integer :artist_id, :null => false
      t.integer :album_id
      t.string  :title
      t.string  :path
      t.boolean :queued, :default => false
      t.boolean :now_playing, :default => false
      t.integer :playcount, :default => 0, :null => false
      t.datetime :last_played_at
      t.timestamps
    end

    add_index :songs, :title
    add_index :songs, :artist_id
    add_index :songs, :album_id
  end
end

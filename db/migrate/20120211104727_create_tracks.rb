class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.integer  "library_id",    :null => false
      t.integer  "song_id"
      t.integer  "bit_rate",      :default => 0
      t.string   "kind",          :limit => 16
      t.string   "persistent_id"
      t.integer  "guid"

      t.timestamps
    end
  end
end

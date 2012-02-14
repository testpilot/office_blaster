class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :song_id, :null => false
      t.integer :user_id, :null => false
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end

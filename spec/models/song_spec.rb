require 'spec_helper'

describe Song do
  let(:user) { Fabricate(:user) }
  let(:song) { Fabricate(:song) }

  it 'should enque a song' do
    song.queued.should be_false
    song.enqueue!(user)
    song.queued.should be_true
  end

  it "should list queued songs in queue" do
    song.enqueue!(user)
    Song.play_next_in_queue.should be_a Song
  end

  it "should have votes" do
    song.votes.count.should == 0
    song.enqueue! user
    song.votes.count.should == 1
  end

  it 'should be in queue' do
    Song.queue.size.should == 0
    song.enqueue! user
    Song.queue.size.should == 1
  end

  it "should be playing" do
    song.now_playing.should == false
    song.play!
    song.now_playing.should == true
  end

  it "should mark song as playing" do
    song.enqueue! user
    song.now_playing.should == false
    Song.play_next_in_queue.should == song
    song.reload
    song.playcount.should == 1
    song.now_playing.should == true
  end

end

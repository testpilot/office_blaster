module SongKick
  class Cli < Thor
    desc :start, "Start playing music"
    def start
      pid = fork { SongKick::Player::Afplay.loop }
      Process.detach(pid)
    end

    desc :stop, "Stop playing music"
    def stop
      SongKick::Player::Afplay.stop
    end

    desc :browse, "Consume served libraries"
    def browse
      SongKick::Browser.new
    end

  end
end

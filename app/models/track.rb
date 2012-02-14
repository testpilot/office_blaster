class Track < ActiveRecord::Base
  belongs_to :library
  belongs_to :song

  def url
    uri = URI.parse(library.url)
    uri.path = "/tracks/#{guid}/file"
    uri.to_s
  end

end

require 'oauth2'
require 'rest-client'
require 'json'


module YouTube
  class Client        
    ENDPOINT = "https://gdata.youtube.com/feeds/api/"

    attr_reader :client
    
    def initialize(token = nil)
      @token = token      
      @client = RestClient::Resource.new(ENDPOINT)
    end
    
    def video_by(id)
      YouTube::Video.by_id(self, id)
    end
    
    def playlist_by(id)
      YouTube::Playlist.by_id(self, id)
    end
  end
end
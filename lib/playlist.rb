module YouTube
  class Playlist
    attr_reader :id, :xml
    
    def self.by_id(token, id)
      begin
        response = token.get("https://gdata.youtube.com/feeds/api/playlists/#{id}?v=2")
      rescue OAuth2::Error => e
        if(e.response.parsed["errors"]["error"]["code"] == "InvalidRequestUriException")
          raise ActionController::RoutingError.new('Not Found')
        else
          raise
        end
      end
      self.new(response.parsed["feed"])
    end
    
    def initialize(xml)    
      @xml = xml
      @xml['entry'] = [@xml['entry']] if @xml['entry'].is_a? Hash
    end
    
    def id
      @xml["playlistId"]
    end
    
    def title
      @xml["title"]
    end
    
    def duration
      @xml["duration"]["seconds"].to_i
    end

    def description
      @xml["description"] || @xml["subtitle"]
    end
    
    def thumbnails
      @xml["group"]["thumbnail"]
    end
    
    def count
      @xml["countHint"]
    end

    def videos
      Enumerator.new do |y|
        @xml["entry"].each { |video| y << YouTube::Video.new(video) }
      end
    end
  end
end
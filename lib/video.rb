module YouTube
  class Video
    attr_reader :id, :xml
    
    def self.by_id(token, id)
      begin
        response = token.get("https://gdata.youtube.com/feeds/api/videos/#{id}?v=2")
      rescue OAuth2::Error => e
        case e.response.parsed["errors"]["error"]["code"]
        when "InvalidRequestUriException", "ResourceNotFoundException"
          raise YouTube::Errors::NotFound.new
        else
          raise
        end
      end
      self.new(response.parsed["entry"])
    end
    
    def initialize(xml)    
      @xml = xml
    end
    
    def id
      @xml["group"]["videoid"]
    end
    
    def title
      @xml["group"]["title"]
    end
    
    def duration
      @xml["group"]["duration"]["seconds"].to_i
    end

    def description
      @xml["group"]["description"]
    end
    
    def thumbnails      
      @xml["group"]["thumbnail"]
    end

    def uploaded
      Time.parse(@xml["group"]["uploaded"])
    end
  end
end
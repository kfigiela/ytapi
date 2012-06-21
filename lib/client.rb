require 'oauth2'

module YouTube
  class Client    
    def initialize(token = nil)
      if token.nil?
        oauth_client = ::OAuth2::Client.new(ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'],
                                                 :site => "https://accounts.google.com",
                                                 :authorize_url => '/o/oauth2/auth',
                                                 :token_url => '/o/oauth2/token')

        @token = ::OAuth2::AccessToken.new(oauth_client, "", mode: :query, param_name: "") # this is a hack
      else
        @token = token
      end
    end
    
    def video_by(id)
      YouTube::Video.by_id(@token, id)
    end
    
    def playlist_by(id)
      YouTube::Playlist.by_id(@token, id)
    end
    
    def playlists(user = nil)
      user = 'default' if user.nil?
      begin
        response = @token.get("https://gdata.youtube.com/feeds/api/users/#{user}/playlists?v=2")
      rescue OAuth2::Error => e
        case e.response.parsed["errors"]["error"]["code"]
        when "InvalidRequestUriException", "ResourceNotFoundException"
          raise YouTube::Errors::NotFoundError.new
        else
          raise
        end
      end
        
      xml = response.parsed["feed"]
      xml['entry'] = [xml['entry']] if xml['entry'].is_a? Hash
      
      Enumerator.new do |y|
        xml["entry"].each { |e| y << YouTube::Playlist.new(e) }
      end
    end    
  end
end
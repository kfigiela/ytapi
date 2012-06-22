require "bundler/setup"
require 'recursive-open-struct'

module YouTube
  class Playlist < ::RecursiveOpenStruct
    LIMIT = 25
    
    include Enumerable
    
    def self.fetch(client, id, start = 1) 
      response = client.client["playlists/#{id}?v=2&alt=jsonc&start-index=#{start}&max-results=#{LIMIT}"].get
      JSON.parse(response)["data"]
    end

    def self.by_id(client, id)
      self.new(client, self.fetch(client, id))
    end
    
    def initialize(client, data)    
      super data
      @client = client
      @videos = Array.new
      add_videos_from_hash data
      uploaded = Time.parse(uploaded) if @uploaded
      updated  = Time.parse(updated)  if @updated
    end
    
    def each &block
      (0...totalItems).each do |index|
        fetch_more if index >= @videos.size
        video = @videos[index]
        block.call(video)
      end
    end
    
    def [] index
      if index > totalItems
        raise IndexError, "Got #{totalItems}, requested for #{index}" 
      elsif index > @videos.size
        while index > @videos.size
          fetch_more
        end
      end
      @videos[index]
    end

    private    
      def add_videos_from_hash data
        @videos.push *data["items"].map {|i| YouTube::Video.new(@client, i["video"])}      
      end
    
      def fetch_more
        if @videos.size < totalItems
          fetched = Playlist.fetch(@client, self.id, @videos.size+1)
          add_videos_from_hash fetched
        end
      end     
  end
end

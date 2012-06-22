require "bundler/setup"
require 'recursive-open-struct'

module YouTube
  class Video < ::RecursiveOpenStruct

    def self.by_id(client, id)
      response = client.client["videos/#{id}?v=2&alt=jsonc"].get
      self.new(client, JSON.parse(response)["data"])
    end
    
    def initialize(client, data)    
      super data
      @client = client
      @uploaded = Time.parse(uploaded) if @uploaded
      @updated  = Time.parse(updated)  if @updated
    end
  end
end
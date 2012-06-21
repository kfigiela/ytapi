module YouTube
  class Errors
    class YouTubeError < StandardError; end
    class NotFound < YouTubeError; end
    class Forbidden < YouTubeError; end
  end
end
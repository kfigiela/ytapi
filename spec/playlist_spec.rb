require 'ytapi'

describe YouTube::Playlist do
  before(:all) do 
    @client = YouTube::Client.new
    @playlist = @client.playlist_by("EF90E1CA16C1AF03")    
  end
    
  it "returns valid video count for known playlist" do
    @playlist.totalItems.should eq(110)
  end
  it "number of videos in collection is the same as totalItems" do
    @playlist.to_a.size.should eq(@playlist.totalItems)
  end
  it "iterates videos" do
    @playlist.each {|video| (video.is_a? YouTube::Video).should be_true}
  end
  it "32th video is SALSEA.NET TALLER BACHATA SENSUAL CON BASI Y DEISY EN CATS" do
    @playlist[31].title.should eq("SALSEA.NET TALLER BACHATA SENSUAL CON BASI Y DEISY EN CATS")
  end

end
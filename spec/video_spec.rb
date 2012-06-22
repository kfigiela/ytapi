require 'ytapi'

describe YouTube::Video, "#by_id" do
  it "returns valid title for video" do
    client = YouTube::Client.new
    video = client.video_by("PWDhYh8q2TY")
    video.id.should eq("PWDhYh8q2TY")
  end
end
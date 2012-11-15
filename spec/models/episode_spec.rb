require "spec_helper"

describe Episode do
  before { @episode = Episode.new(date: "2012-11-11", guestid: 1, tvshowid: 1) }

  subject { @episode }

  it { should respond_to(:date)}
  it { should respond_to(:guestid)}
  it { should respond_to(:tvshowid)}

  it { should be_valid }

  describe "when date is not present" do
    before { @episode.date = " " }
    it { should_not be_valid }
  end

  describe "when guest on a show on the date is already taken" do
    before do
      episode_with_same_details = @episode.dup
      episode_with_same_details.save
    end

    it { should_not be_valid }
  end
end
require "spec_helper"

describe TvShow do
  before { @tv_show = TvShow.new(name: "Leno", identifier: "Jay Leno", url: "http://google.com") }

  subject { @tv_show }

  it { should respond_to(:name)}
  it { should respond_to(:identifier)}
  it { should respond_to(:url)}

  it { should be_valid }

  describe "when name is not present" do
    before { @tv_show.name = " " }
    it { should_not be_valid }
  end

  describe "when name is already taken" do
    before do
      tv_show_with_same_name = @tv_show.dup
      tv_show_with_same_name.name = @tv_show.name.upcase
      tv_show_with_same_name.save
    end

    it { should_not be_valid }
  end

  describe "name with mixed case" do
    let(:mixed_case_name) { "JimMinY CrIckET" }

    it "should be saved as all lower-case" do
      @tv_show.name = mixed_case_name
      @tv_show.save
      @tv_show.reload.name.should == mixed_case_name.downcase
    end
  end
end
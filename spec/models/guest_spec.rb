require "spec_helper"

describe Guest do
  before { @guest = Guest.new(name: "Matt Geneau", url: "http://mattgeneau.com") }

  subject { @guest }

  it { should respond_to(:name)}
  it { should respond_to(:url)}

  it { should be_valid }

  describe "when name is not present" do
    before { @guest.name = " " }
    it { should_not be_valid }
  end

  describe "when name is already taken" do
    before do
      guest_with_same_name = @guest.dup
      guest_with_same_name.name = @guest.name.upcase
      guest_with_same_name.save
    end

    it { should_not be_valid }
  end

  describe "name with mixed case" do
    let(:mixed_case_name) { "JimMinY CrIckET" }

    it "should be saved as all lower-case" do
      @guest.name = mixed_case_name
      @guest.save
      @guest.reload.name.should == mixed_case_name.downcase
    end
  end
end
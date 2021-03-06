require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Time Iterations" do
  
  before(:each) do
    @now = Time.now
  end
  
  it "should iterate over time objects with #each" do
    times = []
    result = @now.each(:hour) { |time| times << time }
    times.should have(24).items
    times.should == (1..24).map { |i| @now + i.hours }
    result.should == @now
  end
  
  it "should iterate over time objects with #beginning_of_each" do
    times = []
    result = @now.beginning_of_each_hour { |time| times << time }
    times.should have(24).items
    times.should == (1..24).map { |i| @now.beginning_of_hour + i.hours }
    result.should == @now
  end
  
  it "should iterate over time objects with #map_each" do
    result = @now.map_each_hour { |time| time }
    result.should have(24).items
    result.should == (1..24).map { |i| @now + i.hours }
  end
  
  it "should iterate over time objects with #map_beginning_of_each" do
    result = @now.map_beginning_of_each(:hour) { |time| time }
    result.should have(24).items
    result.should == (1..24).map { |i| @now.beginning_of_hour + i.hours }
  end
  
  it "should iterate over time objects with #each and #until via method chaining" do
    match = (1..6).map { |i| @now + i.hours }
    
    times = []
    result = @now.each(:hour).until(@now + 6.hours) { |time| times << time }
    times.should == match
    result.should == @now
    
    times = []
    result = @now.until(@now + 6.hours).each_hour { |time| times << time }
    times.should == match
    result.should == @now
  end
  
  it "should iterate over time objects with #map_each and #until via method chaining" do
    match = (1..6).map { |i| @now + i.hours }
    @now.map_each_hour.until(@now + 6.hours) { |time| time }.should == match
    @now.until(@now + 6.hours).map_each(:hour) { |time| time }.should == match
  end
  
  it "should iterate over time objects backwards with #until set in the past" do
    match = (1..6).map { |i| @now - i.hours }
    @now.map_each_hour.until(@now - 6.hours) { |time| time }.should == match
    @now.until(@now - 6.hours).map_each(:hour) { |time| time }.should == match
  end
  
  it "should iterate over time objects with #map_each and #from via method chaining" do
    match = (1..6).map { |i| @now + i.hours }
    (@now + 6.hours).map_each_hour.from(@now) { |time| time }.should == match
    (@now + 6.hours).from(@now).map_each(:hour) { |time| time }.should == match
  end
  
  it "should iterate over time objects with #map_each and #of_the via method chaining" do
    match = (0..23).map { |i| ((@now - (@now.hour).hours) + i.hours).beginning_of_hour }
    @now.map_each_hour.of_the(:day) { |time| time }.should == match
    @now.map_each_hour.of_the_day { |time| time }.should == match
    match = @now.beginning_of_month.map_beginning_of_each_hour(:include_start => true, :include_end => false).until(@now.next_month.beginning_of_month) { |time| time }
    @now.map_each_hour.of_the(:month) { |time| time }.should == match
  end
  
  it "should iterate and respect the include_start and include_end options" do
    match = (1..6).map { |i| @now + i.hours }
    @now.map_each_hour.until(@now + 6.hours) { |time| time }.should == match
    match = (1..6).map { |i| @now + i.hours }
    @now.map_each_hour(:include_end => true).until(@now + 6.hours) { |time| time }.should == match
    @now.map_each_hour(:include_start => false).until(@now + 6.hours) { |time| time }.should == match
    match = (0..6).map { |i| @now + i.hours }
    @now.map_each_hour(:include_start => true).until(@now + 6.hours) { |time| time }.should == match
    match = (0..5).map { |i| @now + i.hours }
    @now.map_each_hour(:include_start => true, :include_end => false).until(@now + 6.hours) { |time| time }.should == match
    match = (0..6).map { |i| @now + i.hours }
    @now.map_each_hour(:include_start => true, :include_end => true).until(@now + 6.hours) { |time| time }.should == match
  end
  
  it "should iterate and respect the beginning_of option" do
    match = (1..6).map { |i| @now.beginning_of_hour + i.hours }
    @now.map_beginning_of_each_hour.until(@now.beginning_of_hour + 6.hours) { |time| time }.should == match
    @now.map_each_hour(:beginning_of => true).until(@now.beginning_of_hour + 6.hours) { |time| time }.should == match
  end
  
end

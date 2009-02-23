require File.join(File.dirname(__FILE__),"..","lib","mhash")
require File.join(File.dirname(__FILE__),"spec_helper")

describe Mhash do
  before(:each) do
    @mhash = Mhash.new
  end
  
  it "should inherit from hash" do
    @mhash.is_a?(Hash).should be_true
  end
  
  it "should be able to set hash values through method= calls" do
    @mhash.test = "abc"
    @mhash["test"].should == "abc"
  end
  
  it "should be able to retrieve set values through method calls" do
    @mhash["test"] = "abc"
    @mhash.test.should == "abc"
  end
  
  it "should test for already set values when passed a ? method" do
    @mhash.test?.should be_false
    @mhash.test = "abc"
    @mhash.test?.should be_true
  end
  
  it "should make all [] and []= into strings for consistency" do
    @mhash["abc"] = 123
    @mhash.key?('abc').should be_true
    @mhash["abc"].should == 123
  end
  
  it "should have a to_s that is identical to its inspect" do
    @mhash.abc = 123
    @mhash.to_s.should == @mhash.inspect
  end
  
  it "should return nil instead of raising an error for attribute-esque method calls" do
    @mhash.abc.should be_nil
  end
  
  it "should return a Mash when passed a bang method to a non-existenct key" do
    @mhash.abc!.is_a?(Mhash).should be_true
  end
  
  it "should return the existing value when passed a bang method for an existing key" do
    @mhash.name = "Bob"
    @mhash.name!.should == "Bob"
  end
  
  it "#initializing_reader should return a Mhash when passed a non-existent key" do
    @mhash.initializing_reader(:abc).is_a?(Mhash).should be_true
  end
  
  it "should allow for multi-level assignment through bang methods" do
    @mhash.author!.name = "Michael Bleigh"
    @mhash.author.should == Mhash.new(:name => "Michael Bleigh")
    @mhash.author!.website!.url = "http://www.mbleigh.com/"
    @mhash.author.website.should == Mhash.new(:url => "http://www.mbleigh.com/")
  end
  
  it "#deep_update should recursively mhash mhashes and hashes together" do
    @mhash.first_name = "Michael"
    @mhash.last_name = "Bleigh"
    @mhash.details = {:email => "michael@asf.com"}.to_mhash
    @mhash.deep_update({:details => {:email => "michael@intridea.com"}})
    @mhash.details.email.should == "michael@intridea.com"
  end
  
  it "should convert hash assignments into mhashes" do
    @mhash.details = {:email => 'randy@asf.com', :address => {:state => 'TX'} }
    @mhash.details.email.should == 'randy@asf.com'
    @mhash.details.address.state.should == 'TX'
  end
  
  context "#initialize" do
    it "should convert an existing hash to a Mhash" do
      converted = Mhash.new({:abc => 123, :name => "Bob"})
      converted.abc.should == 123
      converted.name.should == "Bob"
    end
  
    it "should convert hashes recursively into mhashes" do
      converted = Mhash.new({:a => {:b => 1, :c => {:d => 23}}})
      converted.a.is_a?(Mhash).should be_true
      converted.a.b.should == 1
      converted.a.c.d.should == 23
    end
  
    it "should convert hashes in arrays into mhashes" do
      converted = Mhash.new({:a => [{:b => 12}, 23]})
      converted.a.first.b.should == 12
      converted.a.last.should == 23
    end
    
    it "should convert an existing Mhash into a Mhash" do
      initial = Mhash.new(:name => 'randy', :address => {:state => 'TX'})
      copy = Mhash.new(initial)
      initial.name.should == copy.name      
      initial.object_id.should_not == copy.object_id
      copy.address.state.should == 'TX'
      copy.address.state = 'MI'
      initial.address.state.should == 'TX'
      copy.address.object_id.should_not == initial.address.object_id
    end
    
    it "should accept a default block" do
      initial = Mhash.new { |h,i| h[i] = []}
      initial.default_proc.should_not be_nil
      initial.default.should be_nil
      initial.test.should == []
      initial.test?.should be_true
    end
  end
end

describe Hash do
  it "should be convertible to a Mhash" do
    mhash = {:some => "hash"}.to_mhash
    mhash.is_a?(Mhash).should be_true
    mhash.some.should == "hash"
  end
  
  it "#stringify_keys! should turn all keys into strings" do
    hash = {:a => "hey", 123 => "bob"}
    hash.stringify_keys!
    hash.should == {"a" => "hey", "123" => "bob"}
  end
  
  it "#stringify_keys should return a hash with stringified keys" do
    hash = {:a => "hey", 123 => "bob"}
    stringified_hash = hash.stringify_keys
    hash.should == {:a => "hey", 123 => "bob"}
    stringified_hash.should == {"a" => "hey", "123" => "bob"}
  end
  
end
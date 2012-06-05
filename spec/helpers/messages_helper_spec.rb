require 'spec_helper'

describe MessagesHelper do

  context "#suspicious_message" do
    
    it "returns default email message text" do
      msg = "Testing message helper method with email test@gmail.com"
      altrd_meg = suspicious_message?(msg)

      altrd_meg.should == "Testing message helper method with email  [hidden email address] "
    end
    
    it "returns email message text with ([at])" do
      msg = "Testing message helper method with email test[at]gmail.com"
      altrd_meg = suspicious_message?(msg)
      altrd_meg.should == "Testing message helper method with email  [hidden email address] "
    end
    
    it "returns email message text with multiple ([at])" do
      msg = "Testing message helper method with email test[at]gmail.com or another email  test2[at]gmail.com "
      altrd_meg = suspicious_message?(msg)
      altrd_meg.should == "Testing message helper method with email  [hidden email address]  or another email   [hidden email address]  "
    end
    
    it "returns email message text with test([at])gmail(dot)com" do
      msg = "Testing message helper method with email test[at]gmail(dot)com "
      altrd_meg = suspicious_message?(msg)
      altrd_meg.should == "Testing message helper method with email  [hidden email address]  "
    end
    
    it "returns email message text with test[at]gmail[dot]com" do
      msg = "Testing message helper method with email test[at]gmail[dot]com "
      altrd_meg = suspicious_message?(msg)
      altrd_meg.should == "Testing message helper method with email  [hidden email address]  "
    end
    
    it "returns email message text with test[at]gmail.com" do
      msg = "Testing message helper method with email test[at]gmail.com "
      altrd_meg = suspicious_message?(msg)
      altrd_meg.should == "Testing message helper method with email  [hidden email address]  "
    end
    
    it "returns email message text with test@gmail[dot]com" do
      msg = "Testing message helper method with email test@gmail[dot]com"
      altrd_meg = suspicious_message?(msg)
      altrd_meg.should == "Testing message helper method with email  [hidden email address] "
    end
    
    it "returns default email message text with email test(at)test(dot)com" do
      msg = "Testing message helper method with email test(at)test(dot)com"
      altrd_meg = suspicious_message?(msg)
      altrd_meg.should == "Testing message helper method with email  [hidden email address] "
    end
    
    it "returns default email message text with email test(at)test.com" do
      msg = "Testing message helper method with email test(at)test.com"
      altrd_meg = suspicious_message?(msg)
      altrd_meg.should == "Testing message helper method with email  [hidden email address] "
    end

    it "returns default email message text with email test@test(dot)com" do
      msg = "Testing message helper method with email test@test(dot).com"
      altrd_meg = suspicious_message?(msg)
      altrd_meg.should == "Testing message helper method with email  [hidden email address] "
    end
    
     it "returns default url text with url http://test.com" do
      msg = "Testing message helper method with url http://test.com"
      altrd_meg = suspicious_message?(msg)
      altrd_meg.should == "Testing message helper method with url  [hidden website url] "
    end
    
    it "returns default url text with url https://test.com" do
      msg = "Testing message helper method with url https://test.com"
      altrd_meg = suspicious_message?(msg)
      altrd_meg.should == "Testing message helper method with url  [hidden website url] "
    end
    
    it "returns default phone number message text" do
      msg = "Testing message helper method with phone number 333 333 3333"
      altrd_meg = suspicious_message?(msg)

      altrd_meg.should == "Testing message helper method with phone number  [hidden phone number] "
    end
    
    it "returns default phone number message text (22 2222 2222)" do
      msg = "Testing message helper method with phone number 22 2222 2222"
      altrd_meg = suspicious_message?(msg)

      altrd_meg.should == "Testing message helper method with phone number  [hidden phone number] "
    end
    
    it "returns phone number and email text" do
      msg = "Testing message helper method with phone number 22 2222 2222 and email addess test@gmail.com"
      altrd_meg = suspicious_message?(msg)

      altrd_meg.should == "Testing message helper method with phone number  [hidden phone number]  and email addess  [hidden email address] "
    end
    
    it "returns phone number and email text and website" do
      msg = "Testing message helper method with phone number 22 2222 2222 and email addess test@gmail.com and web site with url https://test.com"
      altrd_meg = suspicious_message?(msg)

      altrd_meg.should == "Testing message helper method with phone number  [hidden phone number]  and email addess  [hidden email address]  and web site with url  [hidden website url] "
    end
    
  end
end
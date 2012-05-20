describe CoolButton do
  before do
    @cool_button = CoolButton.alloc.initWithFrame([[0.0, 0.0], [10.0, 50.0]])
  end

  it "has hue" do
    @cool_button.hue.should.equal 1.0
  end
  
  it "has saturation" do
    @cool_button.saturation.should.equal 1.0
  end
  
  it "has brightness" do
    @cool_button.brightness.should.equal 1.0
  end
  
  it "responds to rectFor1PxStroke:" do
    @cool_button.respond_to?('rectFor1PxStroke').should == true
  end
  
  it "rectFor1PxStroke returns CGRect" do
    @cool_button.performSelector("rectFor1PxStroke:", withObject: CGRectMake(10.0, 10.0, 100.0, 500)).should.satisfy { |obj| obj.is_a?(CGRect) }    
  end
  
  it "state Normal" do
    @cool_button.state.should == UIControlStateNormal
  end
  
  it "title Cool Button" do
    @cool_button.currentTitle.should.be.equal nil
    title = "Cool Button"
    @cool_button.setTitle(title, forState:UIControlStateNormal)
    @cool_button.currentTitle.should.be.equal title
  end
  
  
  it "hue can be changed" do
    @cool_button.performSelector("hue=:", withObject:0.5, afterDelay:0.5)
    wait 0.6 do
      @cool_button.hue.should == 0.5
    end
  end
end

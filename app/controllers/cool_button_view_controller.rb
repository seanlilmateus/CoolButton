class CoolButtonViewController < UIViewController
  attr_accessor :button
  
  def viewDidLoad
    super
    @button.addTarget(self, action:'clicked:', forControlEvents:UIControlEventTouchUpInside)
  end
  
  def didReceiveMemoryWarning
    puts "Memory Warning"
    super
  end
  
  def shouldAutorotateToInterfaceOrientation(orientation)
    true #orientation != UIInterfaceOrientationPortraitUpsideDown
  end
    
  def hue_value_changed(sender)
   @button.hue = sender.value
  end
  
  def saturation_value_changed(sender)
    @button.saturation = sender.value
  end
  
  def brightness_value_changed(sender)
    @button.brightness = sender.value
  end
  
  def clicked(sender)
    NSLog("Hello from %@", sender.class)
  end
end
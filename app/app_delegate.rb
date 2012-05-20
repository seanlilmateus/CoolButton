class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    
    # Override point for customization after application launch.
    @view_controller = CoolButtonViewController.alloc.initWithNibName("CoolButtonViewController", bundle:nil)
    @window.rootViewController = @view_controller
    @window.makeKeyAndVisible
    true
  end
end

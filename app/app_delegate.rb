class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    
    # Override point for customization after application launch.
    @view_controller = CoolButtonViewController.alloc.initWithNibName("CoolButtonViewController", bundle:nil)
    @window.rootViewController = @view_controller
    @window.makeKeyAndVisible
    twitter
    true
  end
  
  def twitter
    url = NSURL.URLWithString("http://search.twitter.com/search.json?q=iOS%205&rpp=5&with_twitter_user_id=true&result_type=recent")
    request = TWRequest.alloc.initWithURL(url, parameters:nil, requestMethod:TWRequestMethodGET)

    request.performRequestWithHandler lambda{|response_data, url_response, error|
      if url_response.statusCode == 200
        error = Pointer.new(:object)
        dict = NSJSONSerialization.JSONObjectWithData(response_data, options:0, error:error)
        NSLog("Twitter %@", dict)
      else
        puts "Twitter error, HTTP response: #{url_response.statusCode}"
      end
    }
  end
end

VendriSDKios
============

#iOS client SDK for Vendri V1

Drag and Drop VendriViewController.h and VendriViewController.m files into the Xcode project and  select 'copy items if needed' checkbox.

##How to use this project

In the view controller intended for Vendri to run (Sample.h), import VendriViewController.h and adopt the VendriViewControllerDelegate protocol.
Example:
```
#import <UIKit/UIKit.h>
#import "VendriViewController.h"
@interface ViewController : UIViewController<VendriViewControllerDelegate>
@end
```

In the .m file (Sample.m), the method we intend to present the app please create an instance for VendriViewController and set the delegate to self. Use the 'vIntegrationURL' property for setting the URL to your custom Vendri Integration page and present the VendriViewController instance using presentViewController:animated:completion: method, and use the delegate methods to receive callbacks.
Sample:
```
- (IBAction)LaunchVendri:(id)sender {
    VendriViewController *vc = [[VendriViewController alloc]init];
    vc.delegate = self;
    vc.vIntegrationURL = @"http://SomePageWithVendriIntegrated.html";
    [self presentViewController:vc animated:FALSE completion:nil];
}
```
```
#pragma mark- VendriViewController delegate methods
-(void) vStarted {
    NSLog(@"App Recieved started");
}
```
```
-(void) vFinishedWithStatus:(int)status {
    NSLog(@"App Recieved finsihed");
}
```
```
-(void) vOtherEventWithDescription:(NSString *)desc {
    NSLog(@"App Recieved finsihed");
}
```

#How we made this and how you can replicate it

Here we provide one example of how you could integrate Vendri without an SDK in iOS.

For playing a creative (Video/Audio/Ad/Static) we use native UIWebView and protocol and Delegate design pattern to get the callbacks when Vendri started, ended, or any other event has occurred. The only part you need to bring is the link to your custom Vendri Integration page.

##What to do?

Add a new class, which inherits from UIViewController (VendriViewController).
In .h file Declare a Protocol and declare the methods, which can be used for callbacks.
Sample:
```
@protocol VendriViewControllerDelegate <NSObject>
-(void) vStarted;
-(void) vFinishedWithStatus:(int)status;
-(void) vOtherEventWithDescription:(NSString *)desc;
@end
```

Now in VendriViewController interface add 2 properties; delegate of type id and which conforms to the above-declared Protocol, and vIntegrationURL of type NSString.
Sample:
```
@interface VendriViewController : UIViewController
@property (assign, nonatomic) id<VendriViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *vIntegrationURL;
@end
```

Now in .m file in the VendriViewController in the class Extention which adopts to UIWebView Delegate protocol declare a UIWebview property.
Sample:
```
@interface VendriViewController () <UIWebViewDelegate >
@property (nonatomic, readwrite) UIWebView *webView;
@end
```

Now In the VendriViewController implementation in –viewDidLoad  method initialize the webview and add the webView as subview to the viewcontroller view. Set the webview delegate to self, set the webView allowsInLineMediaPlayback property to Yes and mediaPlaybackRequiresUserAction to No so that user does not interact when the media is playing. Call loadRequest method on WebView and pass self.vIntegrationURL as an argument.
Sample:
```
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
```
```
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.webView];
```
```
    self.webView.delegate = self;
    self.webView.allowsInlineMediaPlayback = YES;
    self.webView.mediaPlaybackRequiresUserAction = NO;
```
```
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.vIntegrationURL]]];
}
```

Now implement the WebView delegate method (webView:shouldStartLoadWithRequest:navigationType:) In this method check if url scheme is Vendri or not and check for url host to provide the callbacks using the protocol methods for vStarted, vFinished and other hosts.
Sample:
```
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = request.URL;
    if( [[url scheme] isEqualToString:@"vendri"] ) {
        if( [[url host] isEqualToString:@"vStarted"])
        {
            NSLog( @"vStarted");
            if( self.delegate != nil )
                [self.delegate vStarted];
        } else if([[url host] isEqualToString:@"vFinished"] ){
            NSLog( @"vFinished");
            if( self.delegate != nil )
                [self.delegate vFinishedWithStatus:0];
            // lets dismiss the controller
            [self performSelector:@selector(dissMissViewController) withObject:self afterDelay:0.5];
        }
        else {
            NSLog( @"%@", [url host] );
            if( self.delegate != nil )
                [self.delegate vOtherEventWithDescription:[url host]];
        }
        return FALSE;
    }
    return TRUE;
}
```

##Custom Vendri Integration Page

In order to provide a fast and easy way to integrate on all platforms at the same time, we have created a way to pull a webpage into the webview which would have your custom Vendri integration.
Example Page:
```
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="user-scalable=no, initial-scale=.6, maximum-scale=3, minimum-scale=.6, width=device-width, height=device-height, target-densitydpi=device-dpi" />
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
        <script src="http://YourVendriCore.js" type="text/javascript"></script>
    </head>
    <body>
        <script type="text/javascript">
            var width = screen.height, height = screen.width, screenRatio, realWidth, realHeight;
            function dim() {
                if (width > height) {
                    realWidth = width;
                    realHeight = height;
                    screenRatio = (height / width);
                }
                else {
                    realWidth = height;
                    realHeight = width;
                    screenRatio = (width / height);
                }
                if (isNaN(screenRatio)) {
                    if (window.innerHeight > window.innerWidth) {
                        realWidth = window.innerHeight;
                        realHeight = window.innerWidth;
                        screenRatio = (window.innerWidth / window.innerHeight);
                    }
                    else {
                        realWidth = window.innerWidth;
                        realHeight = window.innerHeight;
                        screenRatio = (window.innerHeight / window.innerWidth);
                    }
                }
            }
            window.addEventListener('resize', function () {dim();});
            dim();
            Vendri().setup({adTags: ['http://someTag'], autoplay: true});
        </script>
    </body>
</html>
```
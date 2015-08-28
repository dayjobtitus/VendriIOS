//
//  VendriViewController.m
//  Vendri
//
//  Created by Krishna Kunam on 12/3/14.
//  (c) Copyright 2014, Vendri, Inc. All rights reserved.
//

#import "VendriViewController.h"

@interface VendriViewController () <UIWebViewDelegate >

@property (nonatomic, readwrite) UIWebView *webView;

@end

@implementation VendriViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.webView];
    
    self.webView.delegate = self;
    self.webView.allowsInlineMediaPlayback = YES;
    self.webView.mediaPlaybackRequiresUserAction = NO;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.vIntegrationURL]]];

    //for dissmising the ViewControler on clicking button just use below piece of code.
    //[self performSelector:@selector(dissMissViewController) withObject:self afterDelay:5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma UIWebViewDelegate methods
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



//dissMissviewController is the method which has the code for dismissing the viewController.

//and can follow the same for showing the viewController.

- (void)dissMissViewController
{
    //if you are pushing your viewControler, then use below single line code
    if( self.navigationController != nil )
        [self.navigationController popViewControllerAnimated:YES];
    else
        //if you are presnting ViewController modally. then use below code
        [self dismissViewControllerAnimated:FALSE completion:nil];
}

@end

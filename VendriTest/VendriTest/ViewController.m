//
//  ViewController.m
//  VendriTest
//
//  Created by Krishna Kunam on 12/3/14.
//  (c) Copyright 2014, Vendri, Inc. All rights reserved.
//

#import "ViewController.h"
#import "iToast.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)LaunchVendri:(id)sender {
    VendriViewController *vc = [[VendriViewController alloc]init];
    vc.delegate = self;
    vc.vIntegrationURL = @"http://SomePageWithVendriIntegrated.html";
    [self presentViewController:vc animated:FALSE completion:nil];
}

-(void) vStarted {
    NSLog(@"App Recieved started");
    [[iToast makeText:NSLocalizedString(@"App Recieved started", @"")] show];
}

-(void) vFinishedWithStatus:(int)status {
    NSLog(@"App Recieved finsihed");
    [[iToast makeText:NSLocalizedString(@"App Recieved finsihed", @"")] show];
}

-(void) vOtherEventWithDescription:(NSString *)desc {
    NSLog(@"App Recieved finsihed");
    [[iToast makeText:NSLocalizedString(@"App Recieved finsihed", @"")] show];
}

@end

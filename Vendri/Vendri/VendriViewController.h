//
//  VendriViewController.h
//  Vendri
//
//  Created by Krishna Kunam on 12/3/14.
//  (c) Copyright 2014, Vendri, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VendriViewControllerDelegate <NSObject>

-(void) vStarted;
-(void) vFinishedWithStatus:(int)status;
-(void) vOtherEventWithDescription:(NSString *)desc;

@end


@interface VendriViewController : UIViewController 

@property (assign, nonatomic) id<VendriViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *vIntegrationURL;
@end

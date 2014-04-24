//
//  LoginViewController.h
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 23/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginError;

- (IBAction)loginPressed:(id)sender;
- (IBAction)loginReturnPressed:(id)sender;

@end

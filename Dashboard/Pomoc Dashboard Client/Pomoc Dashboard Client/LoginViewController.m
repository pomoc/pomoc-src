//
//  LoginViewController.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 23/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "LoginViewController.h"
#import "DashBoardSingleton.h"
#import "PomocSupport.h"

@interface LoginViewController () <PMSupportDelegate, PMConversationDelegate>

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)loginPressed:(id)sender {
    
    [self showActivityProgress];
    
    DashBoardSingleton *singleton = [DashBoardSingleton singleton];
    [singleton loginAgentWithUserId:@"steveng.1988@gmail.com" password:@"hehe" completion:^(BOOL success) {
        NSLog(@"result returned!");
        [self performSegueWithIdentifier:@"login" sender:self];
    }];
    
}

- (void) showActivityProgress {
    
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake(self.view.center.x, self.view.center.y - 80);
    [activityView startAnimating];
    [self.view addSubview:activityView];
    
    [_loadingLabel setText:@"Logging in..."];
    
}
@end

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

@interface LoginViewController () <UITextFieldDelegate, PMSupportDelegate, PMConversationDelegate> {
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    IBOutlet UIButton *loginButton;
    IBOutlet UIActivityIndicatorView *spinner;
}

@property UITextField *currentTextField;

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
    username.layer.borderColor = [[UIColor whiteColor] CGColor];
    username.layer.borderWidth = 2.0f;
//    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
//    username.leftView = paddingView;
//    username.leftViewMode = UITextFieldViewModeAlways;
    username.delegate = self;
    
    password.layer.borderColor = [[UIColor whiteColor] CGColor];
    password.layer.borderWidth = 2.0f;
    password.delegate = self;
//    password.leftView = paddingView;
//    password.leftViewMode = UITextFieldViewModeAlways;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (IBAction)loginPressed:(id)sender {
    
    [self showActivityProgress];
    
    DashBoardSingleton *singleton = [DashBoardSingleton singleton];
    [singleton loginAgentWithUserId:@"steveng.1988@gmail.com"
                           password:@"hehe"
                         completion:^(BOOL success) {
        NSLog(@"result returned!");
        // TODO: Uncomment this in DEMO!
        //[self performSegueWithIdentifier:@"login"
        //                          sender:self];
    }];
    
    [self performSegueWithIdentifier:@"login"
                              sender:self];
}

- (void)showActivityProgress {
    
    spinner.hidden = NO;
    [spinner startAnimating];

    [loginButton setTitle:@"Logging in..." forState:UIControlStateNormal];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentTextField = textField;
    [self animateScreenUp:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.currentTextField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self animateScreenUp:NO];
    [self.currentTextField resignFirstResponder];
    return YES;
}

- (void)animateScreenUp:(BOOL)up {
    const int movementDistance = 200.f; // tweak as needed
    const float movementDuration = 0.2f; // tweak as needed
    
    int final = up ? movementDistance : 384;
    [UIView animateWithDuration:movementDuration
                     animations:^{
        self.view.center = CGPointMake(final,
                                       self.view.center.y );
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self animateScreenUp:NO];
}

- (void)newConversationCreated:(PMConversation *)conversation {
    
}

- (void)updateHandlers:(NSArray *)handlers
        conversationId:(NSString *)conversationId {
    
}

- (void)updateHandlers:(NSArray *)handlers
        conversationId:(NSString *)conversationId
              referrer:(PMUser *)referrer
               referee:(PMUser *)referee {
    
}

- (void)updateOnlineUsers:(NSArray *)users {
    
}

- (void)updateOnlineUsers:(NSArray *)users
           conversationId:(NSString *)conversationId {
    
}


-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}


@end

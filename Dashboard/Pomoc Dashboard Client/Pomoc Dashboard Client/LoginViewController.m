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

@interface LoginViewController () <UITextFieldDelegate, PMConversationDelegate> {
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
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    username.layer.borderColor = [[UIColor whiteColor] CGColor];
    username.layer.borderWidth = 2.0f;
    username.delegate = self;
    
    password.layer.borderColor = [[UIColor whiteColor] CGColor];
    password.layer.borderWidth = 2.0f;
    password.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (IBAction)loginReturnPressed:(id)sender {
    [self loginPressed:self];
}

- (IBAction)loginPressed:(id)sender {
    
    DashBoardSingleton *singleton = [DashBoardSingleton singleton];
    
    if ([singleton isConnected]) {
        
        _loginError.text = @"";
        
        [self showActivityProgress];

        NSString *usernameKeyed = username.text;
        NSString *passwordKeyed = password.text;
        
        if ([username.text length] == 0 || [password.text length] ==0) {
            _loginError.text = @"Sorry, please ensure both fields are filled in";
            [self stopActivityProgress];
        } else {
            [singleton loginAgentWithUserId:usernameKeyed
                                   password:passwordKeyed
                                 completion:^(BOOL success) {
                                     
                                     if (success) {
                                         [self performSegueWithIdentifier:@"login" sender:self];
                                         NSLog(@"result success");
                                     } else {
                                         _loginError.text = @"Sorry wrong login credential";
                                         NSLog(@"result failed");
                                         [self stopActivityProgress];
                                     }
                                     
                                 }];
        }
        
        [username resignFirstResponder];
        [password resignFirstResponder];
        
        
        
    } else {
        _loginError.text = @"Sorry, but you have no internet connection currently";
    }
}

- (void)stopActivityProgress {
    spinner.hidden = YES;
    [spinner stopAnimating];
    
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
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

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

@end

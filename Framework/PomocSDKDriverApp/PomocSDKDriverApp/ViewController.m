//
//  ViewController.m
//  PomocSDKDriverApp
//
//  Created by soedar on 28/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "ViewController.h"
#import <PomocSDK/PomocSDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [Pomoc showChatViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender
{
    NSLog(@"Button is Pressed");
}

@end

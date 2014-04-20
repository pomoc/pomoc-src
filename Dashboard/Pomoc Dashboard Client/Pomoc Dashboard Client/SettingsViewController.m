//
//  SettingsViewController.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 19/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "SettingsViewController.h"
#import "DashBoardSingleton.h"
#import "SoundEngine.h"

@interface SettingsViewController (){
    SoundEngine *engine;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.titleTextAttributes = [Utility navigationTitleDesign];
    self.title = @"Settings";
    
    //setting user id
    DashBoardSingleton *singleton = [DashBoardSingleton singleton];
    [_usernameLabel setText:singleton.selfUserId];
    
    //getting sound settings
    engine = [SoundEngine singleton];
    
    _chatSoundSwitch.on = [engine conversationSound];
    _messageSoundSwitch.on = [engine messageSound];
    
}

- (IBAction)chatSoundPressed:(id)sender {

    UISwitch *switchButton = sender;
    [engine toggleConversationSound:switchButton.on];
}

- (IBAction)messageSoundPressed:(id)sender {
    
    UISwitch *switchButton = sender;
    [engine toggleMessageSound:switchButton.on];
}
@end

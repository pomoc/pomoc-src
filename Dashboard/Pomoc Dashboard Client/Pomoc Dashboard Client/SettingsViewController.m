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
    
    if ([engine conversationSound]) {
        [_chatSoundBtn setTitle:@"On" forState:UIControlStateNormal];
    } else {
        [_chatSoundBtn setTitle:@"Off" forState:UIControlStateNormal];
    }
    
    if ([engine messsageSound]) {
        [_messageSoundBtn setTitle:@"On" forState:UIControlStateNormal];
    } else {
        [_messageSoundBtn setTitle:@"Off" forState:UIControlStateNormal];
    }
}

- (IBAction)chatSoundPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *buttonTitle = button.currentTitle;
    
    if ([buttonTitle isEqualToString:@"On"]) {
        //off chat sound now
        [_chatSoundBtn setTitle:@"Off" forState:UIControlStateNormal];
        [engine setConversationSoundOff];
        
    } else {
        //on chat sound
        [_chatSoundBtn setTitle:@"On" forState:UIControlStateNormal];
        [engine setConversationSoundOn];
    }
}

- (IBAction)messageSoundPressed:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    NSString *buttonTitle = button.currentTitle;
    
    if ([buttonTitle isEqualToString:@"On"]) {
        //off chat sound now
        [_messageSoundBtn setTitle:@"Off" forState:UIControlStateNormal];
        [engine setMessageSoundOff];
        
    } else {
        //on chat sound
        [_messageSoundBtn setTitle:@"On" forState:UIControlStateNormal];
        [engine setMessageSoundOn];
    }
    
}
@end

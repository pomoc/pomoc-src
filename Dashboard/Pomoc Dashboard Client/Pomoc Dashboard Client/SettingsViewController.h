//
//  SettingsViewController.h
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 19/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *apiKeyLabel;
@property (weak, nonatomic) IBOutlet UISwitch *chatSoundSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *messageSoundSwitch;

- (IBAction)chatSoundPressed:(id)sender;
- (IBAction)messageSoundPressed:(id)sender;

@end

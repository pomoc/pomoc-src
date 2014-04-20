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

- (IBAction)chatSoundPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *chatSoundBtn;


- (IBAction)messageSoundPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *messageSoundBtn;

@end

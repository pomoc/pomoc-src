//
//  HomeViewController.h
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 18/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (weak, nonatomic) IBOutlet UIView *toolTipView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *userOnlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *agentOnlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalConversationLabel;
@property (weak, nonatomic) IBOutlet UILabel *unattendedConversationLabel;

@end

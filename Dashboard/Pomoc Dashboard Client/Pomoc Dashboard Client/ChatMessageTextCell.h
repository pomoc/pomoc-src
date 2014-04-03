//
//  ChatMessageTextCell.h
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 25/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatMessageTextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageFrom;
@property (weak, nonatomic) IBOutlet UILabel *messageText;

@end

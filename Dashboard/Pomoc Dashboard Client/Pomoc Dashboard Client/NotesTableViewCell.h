//
//  NotesTableViewCell.h
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 23/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesInfo;

@end

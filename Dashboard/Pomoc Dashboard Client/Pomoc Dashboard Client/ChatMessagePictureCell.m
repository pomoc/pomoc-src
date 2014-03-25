//
//  ChatMessagePictureCell.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 25/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "ChatMessagePictureCell.h"

@implementation ChatMessagePictureCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editPicturePressed:(id)sender {
}
@end

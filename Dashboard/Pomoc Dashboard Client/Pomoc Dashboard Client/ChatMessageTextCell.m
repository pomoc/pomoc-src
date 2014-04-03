//
//  ChatMessageTextCell.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 25/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "ChatMessageTextCell.h"

@implementation ChatMessageTextCell

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

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //update the UILabel's height based on text size
    _messageText.numberOfLines = 0;
    
    CGSize maximumLabelSize = CGSizeMake(_messageText.frame.size.width, 9999);
    CGSize expectedSize = [_messageText sizeThatFits:maximumLabelSize];

    CGRect newFrame = _messageText.frame;
    newFrame.size.height = expectedSize.height;
    _messageText.frame = newFrame;
    
}

@end

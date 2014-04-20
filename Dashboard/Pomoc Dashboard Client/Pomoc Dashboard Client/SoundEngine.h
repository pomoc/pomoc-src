//
//  SoundEngine.h
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 19/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundEngine : NSObject <AVAudioPlayerDelegate>

+ (id)singleton;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

- (void)playNewConversation;
- (void)playNewMessage;

//check user preference for sound
- (BOOL)conversationSound;
- (BOOL)messageSound;

//set sound prefer
- (void)toggleConversationSound:(BOOL)value;
- (void)toggleMessageSound:(BOOL)value;

@end

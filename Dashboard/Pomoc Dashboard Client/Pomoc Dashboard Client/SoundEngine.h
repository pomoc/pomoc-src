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

- (void) playNewConversation;
- (void) playNewMessage;

//check user preference for sound
- (BOOL) conversationSound;
- (BOOL) messsageSound;

//set sound prefer
- (void) setConversationSoundOn;
- (void) setConversationSoundOff;

- (void) setMessageSoundOn;
- (void) setMessageSoundOff;
@end

//
//  SoundEngine.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 19/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "SoundEngine.h"

@implementation SoundEngine

+ (id)singleton {
    
    static SoundEngine *sharedMyModel = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedMyModel = [[self alloc] init];
    });
    
    return sharedMyModel;
}

- (id) init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BOOL) conversationSound
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"conversationSound"];
}

- (BOOL) messsageSound
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"messageSound"];
}


- (void) setConversationSoundOn
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"conversationSound"];
}
- (void) setConversationSoundOff
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"conversationSound"];
}

- (void) setMessageSoundOn
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"messageSound"];
}
- (void) setMessageSoundOff
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"messageSound"];
}


- (void) playSoundOfFile: (NSString *)fileName :(NSString *)type
{
    NSString *path = [ [NSBundle mainBundle] pathForResource:fileName
                                                      ofType:type];
    
    NSLog(@"path == %@",path);
    
    NSURL *url = [NSURL fileURLWithPath:path isDirectory:NO];
    
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc]
                    initWithContentsOfURL:url
                    error:&error];
    
    [_audioPlayer play];
}

- (void) playNewConversation
{
    if ([self conversationSound]) {
        [self playSoundOfFile:@"chat" :@"mp3"];
    }
}

- (void) playNewMessage
{
    if ([self messsageSound]) {
        [self playSoundOfFile:@"message" :@"mp3"];
    }
}

@end

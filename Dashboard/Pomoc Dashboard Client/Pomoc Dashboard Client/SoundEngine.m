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

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BOOL)conversationSound
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"conversationSound"];
}

- (BOOL)messageSound
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"messageSound"];
}


- (void)toggleConversationSound:(BOOL)value {
    [[NSUserDefaults standardUserDefaults] setBool:value
                                            forKey:@"conversationSound"];
}

- (void)toggleMessageSound:(BOOL)value {
    [[NSUserDefaults standardUserDefaults] setBool:value
                                            forKey:@"messageSound"];
}

- (void)playSoundOfFile: (NSString *)fileName :(NSString *)type {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName
                                                     ofType:type];
    
    NSLog(@"path == %@",path);
    
    NSURL *url = [NSURL fileURLWithPath:path isDirectory:NO];
    
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc]
                    initWithContentsOfURL:url
                    error:&error];
    
    [_audioPlayer play];
}

- (void)playNewConversation {
    if ([self conversationSound]) {
        [self playSoundOfFile:@"chat"
                             :@"mp3"];
    }
}

- (void)playNewMessage {
    if ([self messageSound]) {
        [self playSoundOfFile:@"message"
                             :@"mp3"];
    }
}

@end

//
//  FakePomocSupport.m
//  Pomoc Dashboard Client
//
//  Going to pretend that this is the class that CM is creating that would talk to the app
//
//
//

#import "FakePomocSupport.h"

@implementation FakePomocSupport

- (id) initWithLastUpdatedDate: (NSDate *)lastUpdatedDate andAppId: (NSString *) appId;
{
    self = [super init];
    _chatList = [[NSMutableArray alloc] init];
    
    return self;
}

//This method is the app channels notify of a new channel
- (void) simulateNewChat
{
    PomocChat *newPomocChat = [[PomocChat alloc] initWithChannel:@"channel1"];
    
    NSInteger randomNumber = [self randomNumberGeneratorMax: 15000];
    newPomocChat.visitorName = [NSString stringWithFormat:@"Stupid User %ld",randomNumber];
    
    newPomocChat.startedDate = [NSDate date];
    newPomocChat.noOfAgent = [self randomNumberGeneratorMax: 99];
    
    [_chatList addObject:newPomocChat];
    
    //calling chat view controller to inform of new chat
    [_delegate newChat: newPomocChat];
    
}

//This method is when the channel subscribed notify of a new message
- (void) simulateChatMessage
{
    //Creating the pomoc chat message
    PomocChatMessage *newPomocChatMessage = [[PomocChatMessage alloc] init];
    newPomocChatMessage.messageText = @"Hi, I need help";
    newPomocChatMessage.senderName = @"Stupid user";
    newPomocChatMessage.sentDate = [NSDate date];
    
    //Finding the pomoc chat with such channel
    NSString *channelId = @"channel1";
    
    [_delegate newChatMessage: newPomocChatMessage channel:channelId];

}

//This method is when the channel subscribed notify of a new picture message
- (void) simulatePictureMessage
{
    //Creating the pomoc chat message
    PomocChatMessage *newPomocChatMessage = [[PomocChatMessage alloc] init];
    newPomocChatMessage.messageImage = [UIImage imageNamed:@"sampleImage.png"];
    newPomocChatMessage.senderName = @"Stupid user";
    newPomocChatMessage.sentDate = [NSDate date];
    
    //Finding the pomoc chat with such channel
    NSString *channelId = @"channel1";
    
    [_delegate newPictureMessage:newPomocChatMessage channel:channelId];
    
}


- (NSInteger)randomNumberGeneratorMax: (NSInteger) max
{
    return arc4random() % max;
}

@end

//
//  PomocCore.m
//  PomocCore
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMCore.h"
#import "PMCore_Private.h"

#import "SocketIO.h"
#import "SocketIOPacket.h"

#import "PMMessage.h"
#import "PMMessageConstants.h"
#import "PMMessage+Constructors.h"
#import "PMInternalMessage.h"
#import "PMApplicationMessage.h"
#import "PMChatMessage.h"
#import "PMImageMessage.h"
#import "PMStatusMessage.h"
#import "PomocImage.h"

#import "PMNote.h"

#import "PMConversation.h"
#import "PMConversation+PMCore.h"

#import "PMUserManager.h"

#import "PMCoreConstants.h"

#define MESSAGE_USER_ID   @"userId"
#define MESSAGE_APP_ID    @"appId"

@interface PMCore () <SocketIODelegate>

@property (nonatomic, strong) NSString *appId;

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) SocketIO *socket;
@property (nonatomic, weak) id<PMCoreDelegate> delegate;

@property (nonatomic, strong) NSMutableDictionary *conversations;

@end

@implementation PMCore

+ (PMCore *)sharedInstance
{
    static PMCore *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (void)initWithAppID:(NSString *)appId {
    PMCore *core = [PMCore sharedInstance];
    if (!core.appId) {
        core.appId = appId;
        core.socket = [[SocketIO alloc] initWithDelegate:core];
        core.conversations = [NSMutableDictionary dictionary];
    }
}

+ (void)setUserId:(NSString *)userId
{
    [PMCore sharedInstance].userId = userId;
}

+ (void)startConversationWithCompletion:(void (^)(PMConversation *conversation))completion
{
    PMCore *core = [PMCore sharedInstance];
    PMMessage *initMessage = [PMMessage internalMessageWithCode:PMInternalMessageCodeNewConversation];

    [core sendMessage:initMessage withAcknowledge:^(NSDictionary *jsonResponse) {
        if ([jsonResponse[SUCCESS_KEY] isEqual:@(YES)] && completion) {
            NSString *conversationId = jsonResponse[MESSAGE_CONVERSATION_ID];
            NSString *creatorUserId = jsonResponse[MESSAGE_CREATOR_USERID];
            NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:[jsonResponse[MESSAGE_CREATE_DATE] doubleValue] / 1000];
            PMConversation *conversation = [[PMConversation alloc] initWithConversationId:conversationId
                                            creatorUserId:creatorUserId createDate:createDate];
            
            @synchronized(core.conversations) {
                core.conversations[conversationId] = conversation;
            }
            completion(conversation);
        }
    }];
}

+ (void)sendTextMessage:(NSString *)message conversationId:(NSString *)conversationId
{
    PMCore *core = [PMCore sharedInstance];
    PMMessage *chatMessage = [PMMessage chatMessageWithMessage:message conversationId:conversationId];
    [core sendMessage:chatMessage withAcknowledge:nil];
}

+ (void)sendImageMessage:(UIImage *)image conversationId:(NSString *)conversationId
{
    [[PomocImage sharedInstance] uploadImage:image withCompletion:^(NSString *imageId) {
        PMImageMessage *imageMessage = [PMMessage imageMessageWithId:imageId conversationId:conversationId];
        PMCore *core = [PMCore sharedInstance];
        [core sendMessage:imageMessage withAcknowledge:nil];
    }];
}

+ (void)sendStatus:(PMStatusMessageCode)code conversationId:(NSString *)conversationId
{
    PMCore *core = [PMCore sharedInstance];
    PMStatusMessage *statusMessage = [PMMessage statusMessageWithCode:code conversationId:conversationId];
    [core sendMessage:statusMessage withAcknowledge:nil];
}

+ (void)sendNote:(NSString *)note conversationId:(NSString *)conversationId
{
    NSDictionary *appData = @{MESSAGE_NOTE: note};
    
    PMCore *core = [PMCore sharedInstance];
    PMMessage *noteMessage = [PMMessage applicationMessageWithCode:PMApplicationMessageCodeAddNote conversationId:conversationId appData:appData];
    [core sendMessage:noteMessage withAcknowledge:nil];
}

+ (void)joinConversation:(NSString *)conversationId
           creatorUserId:(NSString *)creatorUserId
              createDate:(NSDate *)createDate
              completion:(void (^)(NSArray *messages, NSArray *notes))completion
{
    PMCore *core = [PMCore sharedInstance];
    PMMessage *observeMessage = [PMMessage internalMessageWithCode:PMInternalMessageCodeJoinConversation
                                                    conversationId:conversationId
                                                     creatorUserId:creatorUserId
                                                        createDate:createDate];
    
    [core sendMessage:observeMessage withAcknowledge:^(NSDictionary *jsonResponse) {
        if ([jsonResponse[SUCCESS_KEY] isEqual:@(YES)] && completion) {
            NSMutableArray *messages = [NSMutableArray array];
            NSMutableArray *notes = [NSMutableArray array];
            
            for (NSDictionary *jsonMessage in jsonResponse[MESSAGES_KEY]) {
                PMChatMessage *message = [PMMessage chatMessageFromJsonData:jsonMessage];
                // Message will be non nil if it is of chat message type
                if (message) {
                    [messages addObject:message];
                }
            }
            
            for (NSDictionary *noteData in jsonResponse[NOTES_KEY]) {
                PMNote *note = [[PMNote alloc] initWithJsonData:noteData];
                [notes addObject:note];
            }
            
            completion([NSArray arrayWithArray:messages], [NSArray arrayWithArray:notes]);
        }
    }];
}

+ (void)getAllConversations:(void(^)(NSArray *conversations))completion
{
    PMCore *core = [PMCore sharedInstance];
    PMMessage *allConversationMessage = [PMMessage internalMessageWithCode:PMInternalMessageCodeGetAppConversationList];
    
    [core sendMessage:allConversationMessage withAcknowledge:^(NSDictionary *jsonResponse) {
        if ([jsonResponse[SUCCESS_KEY] isEqual:@(YES)] && completion) {
            
            NSArray *conversationObjects = jsonResponse[CONVERSATION_IDS_KEY];
            NSMutableArray *conversations = [NSMutableArray array];
            for (NSDictionary *conversation in conversationObjects) {
                NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:[conversation[MESSAGE_CREATE_DATE] doubleValue] / 1000];
                [conversations addObject:[[PMConversation alloc] initWithConversationId:conversation[MESSAGE_CONVERSATION_ID]
                                                                          creatorUserId:conversation[MESSAGE_CREATOR_USERID]
                                                                             createDate:createDate]];
            }
            
            [PMCore joinAllConversations:[conversations copy] completion:completion];
        }
    }];
}

+ (void)joinAllConversations:(NSArray *)conversations completion:(void(^)(NSArray *conversations))completion
{
    [PMCore joinConversationsInQueue:[conversations mutableCopy] done:[NSMutableArray array] completion:completion];
}

+ (void)joinConversationsInQueue:(NSMutableArray *)queue
                            done:(NSMutableArray *)done
                      completion:(void(^)(NSArray *conversations))completion
{
    if ([queue count] == 0) {
        completion([done copy]);
        return;
    }
    
    PMConversation *conversation = queue[0];
    
    [conversation joinConversationWithCompletion:^(BOOL success) {
        [queue removeObjectAtIndex:0];
        if (success) {
            [done addObject:conversation];
            @synchronized([PMCore sharedInstance].conversations) {
                [PMCore sharedInstance].conversations[conversation.conversationId] = conversation;
            }
        }
        [PMCore joinConversationsInQueue:queue done:done completion:completion];
    }];
}

+ (void)setDelegate:(id<PMCoreDelegate>)delegate
{
    [PMCore sharedInstance].delegate = delegate;
}

+ (void)observeNewConversations
{
    [[PMCore sharedInstance] observeNewConversations];
}

+ (void)connect
{
    [[PMCore sharedInstance] connect];
}

+ (void)disconnect
{
    [[PMCore sharedInstance] disconnect];
}

+ (void)handleConversation:(NSString *)conversationId
{
    PMCore *core = [PMCore sharedInstance];
    PMMessage *handleMessage = [PMMessage applicationMessageWithCode:PMApplicationMessageCodeHandle conversationId:conversationId];
    [core sendMessage:handleMessage withAcknowledge:nil];
}

+ (void)unhandleConversation:(NSString *)conversationId
{
    PMCore *core = [PMCore sharedInstance];
    PMMessage *unhandleMessage = [PMMessage applicationMessageWithCode:PMApplicationMessageCodeUnhandle conversationId:conversationId];
    [core sendMessage:unhandleMessage withAcknowledge:nil];
}

+ (void)referHandlerConversation:(NSString *)conversationId refereeUserId:(NSString *)refereeUserId
{
    PMCore *core = [PMCore sharedInstance];
    PMMessage *referHandlerMessage = [PMMessage applicationMessageWithCode:PMApplicationMessageCodeReferHandler conversationId:conversationId refereeUserId:refereeUserId];
    [core sendMessage:referHandlerMessage withAcknowledge:nil];
}

+ (void)getHandlersForConversation:(NSString *)conversationId completion:(void(^)(NSArray *handlers))completion
{
    PMCore *core = [PMCore sharedInstance];
    PMMessage *getHandlersMessage = [PMMessage applicationMessageWithCode:PMApplicationMessageCodeGetHandlers conversationId:conversationId];
    [core sendMessage:getHandlersMessage withAcknowledge:^(NSDictionary *jsonResponse) {
        if ([jsonResponse[SUCCESS_KEY] isEqual:@(YES)] && completion) {
            NSArray *handlers = [PMUserManager getUserObjectsFromUserIds:jsonResponse[HANDLERS_KEY]];
            completion(handlers);
        }
    }];
}

+ (void)pingApp
{
    PMCore *core = [PMCore sharedInstance];
    PMMessage *onlineAppUsersMessage = [PMMessage internalMessageWithCode:PMInternalMessageCodePingApp];
    [core sendMessage:onlineAppUsersMessage withAcknowledge:nil];
}

+ (void)addConversation:(PMConversation *)conversation
{
    PMCore *core = [PMCore sharedInstance];
    @synchronized(core.conversations) {
        core.conversations[conversation.conversationId] = conversation;
    }
}

- (void)connect
{
    [self.socket connectToHost:POMOC_URL onPort:POMOC_PORT];
}

- (void)disconnect
{
    [self.socket disconnect];
    self.socket = [[SocketIO alloc] initWithDelegate:self];
    self.userId = nil;
}

- (void)observeNewConversations
{
    PMMessage *observeMessage = [PMMessage internalMessageWithCode:PMInternalMessageCodeObserveConversationList];
    [self sendMessage:observeMessage withAcknowledge:nil];
}

- (void)sendMessage:(PMMessage *)message withAcknowledge:(SocketIOCallback)function
{
    NSDictionary *jsonData = [self jsonDataForMessage:message];
    if ([message isKindOfClass:[PMInternalMessage class]]) {
        [self.socket sendEvent:INTERNAL_MESSAGE_EVENT withData:jsonData andAcknowledge:function];
    } else if ([message isKindOfClass:[PMChatMessage class]]) {
        [self.socket sendEvent:CHAT_MESSAGE_EVENT withData:jsonData andAcknowledge:function];
    } else if ([message isKindOfClass:[PMApplicationMessage class]]) {
        [self.socket sendEvent:APPLICATION_MESSAGE_EVENT withData:jsonData andAcknowledge:function];
    }
}

- (NSDictionary *)jsonDataForMessage:(PMMessage *)message
{
    NSMutableDictionary *jsonDict = [[message jsonObject] mutableCopy];
    jsonDict[MESSAGE_USER_ID] = self.userId;
    jsonDict[MESSAGE_APP_ID] = self.appId;
    
    return [NSDictionary dictionaryWithDictionary:jsonDict];
}

#pragma mark - SocketIO Delegate methods

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    NSDictionary *data = [packet dataAsJSON][ARGS_KEY][0];
    
    if ([packet.name isEqualToString:CHAT_MESSAGE_EVENT]) {
        PMChatMessage *chatMessage = [PMMessage chatMessageFromJsonData:data];
        
        PMConversation *conversation = self.conversations[chatMessage.conversationId];
        if (conversation) {
            [conversation addMessage:chatMessage];
        }
    }
    else if ([packet.name isEqualToString:NEW_NOTE_EVENT]) {
        NSString *conversationId = data[MESSAGE_CONVERSATION_ID];
        
        PMConversation *conversation = self.conversations[conversationId];
        if (conversation) {
            PMNote *note = [[PMNote alloc] initWithJsonData:data[MESSAGE_NOTE]];
            [conversation addNote:note];
        }
    }
    else if ([packet.name isEqualToString:NEW_CONVERSATION_EVENT]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(newConversationCreated:)]) {
            NSString *conversationId = data[MESSAGE_CONVERSATION_ID];
            NSString *creatorUserId = data[MESSAGE_CREATOR_USERID];
            NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:[data[MESSAGE_CREATE_DATE] doubleValue] / 1000];
            
            PMConversation *conversation = self.conversations[conversationId];
            
            if (!conversation) {
                conversation = [[PMConversation alloc] initWithConversationId:conversationId creatorUserId:creatorUserId createDate:createDate];
                @synchronized(self.conversations) {
                    self.conversations[conversationId] = conversation;
                }
            }
            
            [conversation joinConversationWithCompletion:^(BOOL success) {
                if (success) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(newConversationCreated:)]) {
                        [self.delegate newConversationCreated:conversation];
                    }
                }
            }];
        }
    }
    else if ([packet.name isEqualToString:ONLINE_STATUS_EVENT]) {
        NSArray *users = [PMUserManager getUserObjectsFromUserIds:data[USERS_KEY]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateOnlineUsers:conversationId:)]) {
            if ([data[TYPE_KEY] isEqualToString:TYPE_CONVERSATION]) {
                [self.delegate updateOnlineUsers:users conversationId:data[MESSAGE_CONVERSATION_ID]];
            }
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateOnlineUsers:)]) {
            if ([data[TYPE_KEY] isEqualToString:TYPE_APP]) {
                [self.delegate updateOnlineUsers:users];
            }
        }
    }
    else if ([packet.name isEqualToString:HANDLE_EVENT]) {
        NSArray *handlers = [PMUserManager getUserObjectsFromUserIds:data[USERS_KEY]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateHandlers:conversationId:referrer:referee:)]) {
            if ([data[TYPE_KEY] isEqualToString:TYPE_HANDLERS]) {
                [self.delegate updateHandlers:handlers conversationId:data[MESSAGE_CONVERSATION_ID]];
            }
            else if ([data[TYPE_KEY] isEqualToString:TYPE_REFERRAL]) {
                PMUser *referrer = [PMUserManager getUserObjectFromUserId:data[REFERRER_KEY]];
                PMUser *referee = [PMUserManager getUserObjectFromUserId:data[REFEREE_KEY]];
                
                [self.delegate updateHandlers:handlers
                               conversationId:data[MESSAGE_CONVERSATION_ID]
                                     referrer:referrer
                                      referee:referee];
            }
        }
    }
    
}

- (void)socketIODidConnect:(SocketIO *)socket
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hasConnected)]) {
        [self.delegate hasConnected];
    }
}

- (void)socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hasDisconnected)]) {
        [self.delegate hasDisconnected];
    }
}

@end

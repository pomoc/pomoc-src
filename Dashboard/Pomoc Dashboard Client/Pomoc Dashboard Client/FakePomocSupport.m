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
    
    return self;
}

- (void) testCallDelegate
{
    NSLog(@"fake pomoc support, test call delegate called!");
    [_delegate testProtocol];
}
@end

//
//  PomocTests.m
//  PomocTests
//
//  Created by soedar on 18/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PM_Core.h"
#import "PomocTest.h"

@interface PomocTests : XCTestCase

@end

@implementation PomocTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWtf {
    [PomocTest testString];
    return;
}

@end

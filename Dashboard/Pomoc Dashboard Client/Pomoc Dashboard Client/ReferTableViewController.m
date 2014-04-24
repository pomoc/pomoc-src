//
//  ReferTableViewController.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 14/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "ReferTableViewController.h"
#import "DashBoardSingleton.h"
#import "PomocSupport.h"

@interface ReferTableViewController () {
    NSMutableArray *option;
    DashBoardSingleton *singleton;
    BOOL empty;
}

@end

@implementation ReferTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    empty = NO;
    singleton = [DashBoardSingleton singleton];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (_referList.count == 0){
        empty = YES;
        return 10;
    } else {
        return _referList.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (empty) {
        cell.textLabel.text = @"No available agents to invite";
    } else {
        PMUser *user = _referList[indexPath.row];
        cell.textLabel.text = user.name;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected row == %lu",(long)indexPath.row);
    
    if (!empty) {
        PMUser *selectedUser = _referList[indexPath.row];
        NSLog(@"selected user name == %@",selectedUser.name);
        
        [singleton refer:_currentConvo referee:selectedUser];
    }
    
    [_delegate closeReferPopOver];
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

@end

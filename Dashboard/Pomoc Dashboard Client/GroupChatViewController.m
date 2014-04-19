//
//  GroupChatViewController.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 19/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "GroupChatViewController.h"
#import "DashBoardSingleton.h"
#import "PMSupport.h"
#import "PMUser.h"

@interface GroupChatViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    DashBoardSingleton *singleton;
    NSMutableArray *agentList;
}

@end

@implementation GroupChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //ensuring that no border for chat message table view
    _agentListChatView.separatorColor = [UIColor clearColor];
    _agentListNavBar.separatorColor = [UIColor clearColor];
    
    //border
    _agentListChatView.layer.borderWidth = 0.5;
    CALayer *leftBorder = [CALayer layer];
    [leftBorder setBackgroundColor:[[UIColor blackColor] CGColor]];
    [leftBorder setFrame:CGRectMake(0, 0, 0.5, _agentListChatView.frame.size.height)];
    [_agentListChatView.layer addSublayer:leftBorder];
    
    self.navigationController.navigationBar.titleTextAttributes = [Utility navigationTitleDesign];
    self.title = @"Group Chat";

    singleton = [DashBoardSingleton singleton];
    agentList = singleton.currentAgentList;
    singleton.groupChatDelegate = self;
}

- (void) deallocDelegate
{
    singleton.groupChatDelegate = nil;
}


#pragma mark - Navigation Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([tableView tag] == GROUP_CHAT_TABLEVIEW) {
        return 5;
    } else if ([tableView tag] ==AGENT_LIST_TABLEVIEW) {
        return [agentList count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if ([tableView tag] == GROUP_CHAT_TABLEVIEW) {
        
        static NSString *cellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        return cell;

    } else if ([tableView tag] ==AGENT_LIST_TABLEVIEW) {
        return [self createAgentListTable:tableView atRow:row];
    }
    
    return nil;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([tableView tag] ==AGENT_LIST_TABLEVIEW) {
        return @"Agents online";
    }
    return nil;
}

#pragma mark - CHAT SIDE NAV
- (UITableViewCell *) createAgentListTable: (UITableView *) tableView atRow: (NSInteger)row
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    PMUser *agent = [agentList objectAtIndex:row];
    cell.textLabel.text = agent.name;
    cell.textLabel.font = [UIFont fontWithName:@"Marker Felt" size:17];
    
    UIImage *thumbNail = [UIImage imageNamed:@"worker-512.png"];
    UIImage *scaled = [Utility scaleImage:thumbNail toSize:CGSizeMake(25, 25)];
    
    cell.imageView.image = scaled;
    return cell;
}


- (void) agentListUpdated: (NSMutableArray *)updatedAgentList
{
    agentList = updatedAgentList;
    [_agentListNavBar reloadData];
}



@end

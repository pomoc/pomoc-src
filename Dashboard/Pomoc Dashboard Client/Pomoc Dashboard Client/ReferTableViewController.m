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
}

@end

@implementation ReferTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"came inside action VC");
    singleton = [DashBoardSingleton singleton];
    
    option = [[NSMutableArray alloc] init];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = self.view.center;
    [self.view addSubview:spinner];
    [self.view bringSubviewToFront:spinner];
    [spinner startAnimating];
    
    __block NSArray *agentList;
    [singleton getPossibleRefer:_currentConvo completion:^(NSArray *users){
        
        agentList = users;
        for (PMUser *user in agentList) {
            [option addObject: user];
        }
        
        [self.tableView reloadData];
        
    }];
    
    //option = @[@"Tim", @"Ali", @"Baba"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [option count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    PMUser *user = [option objectAtIndex:indexPath.row];
    cell.textLabel.text = user.name;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected row == %lu",indexPath.row);
    
    PMUser *selectedUser = [option objectAtIndex:indexPath.row];
    NSLog(@"selected user name == %@",selectedUser.name);
    
    [singleton refer:_currentConvo referee:selectedUser];
}

@end

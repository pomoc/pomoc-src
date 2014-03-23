//
//  PastChatViewController.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 23/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PastChatViewController.h"

#define CHAT_LIST_TABLEVIEW 1
#define CHAT_MESSAGE_TABLEVIEW 2

#define CHAT_CELL_STARTED 1
#define CHAT_CELL_AGENT_NO 2

#define CHAT_MESSAGE_CELL_NAME 1
#define CHAT_MESSAGE_TEXT 2
#define CHAT_MESSAGE_DATE 3

@interface PastChatViewController ()

@end

@implementation PastChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _chatNavTable.separatorColor = [UIColor clearColor];
    _chatMessageTable.separatorColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    NSLog(@"came inside number of sections");
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return [dataArray count];
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView tag] == CHAT_LIST_TABLEVIEW ) {
        return [self createChatNavTableView:tableView];
        
    }else if([tableView tag] == CHAT_MESSAGE_TABLEVIEW) {
        return [self createChatMessageTableView:tableView];
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //selecting one of the chat side nav
//    if([tableView tag] == CHAT_LIST_TABLEVIEW ) {
//        
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        
//    }
    
    
}

- (UITableViewCell *) createChatNavTableView: (UITableView *) tableView
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //setting the started date of chat
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM 'at' HH:MM"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    UILabel *startedLabel = (UILabel *)[cell.contentView viewWithTag:CHAT_CELL_STARTED];
    [startedLabel setText:[NSString stringWithFormat:@"%@ %@",@"Started at",dateString]];
    
    //setting number of agents
    UILabel *agentLabel = (UILabel *)[cell.contentView viewWithTag:CHAT_CELL_AGENT_NO];
    [agentLabel setText:@"8"];
    
    return cell;

}

- (UITableViewCell *) createChatMessageTableView: (UITableView *) tableView
{
    static NSString *cellIdentifier = @"ChatMessageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //Setting visitor name
    UILabel *visitorLabel = (UILabel *)[cell.contentView viewWithTag:CHAT_MESSAGE_CELL_NAME];
    [visitorLabel setText:@"Visitor XXX"];
    
    //setting the started date of chat
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd 'at' HH:MM"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    UILabel *startedLabel = (UILabel *)[cell.contentView viewWithTag:CHAT_MESSAGE_DATE];
    [startedLabel setText:[NSString stringWithFormat:@"%@ %@",@"Started at",dateString]];
    
    //setting number of agents
    UILabel *agentLabel = (UILabel *)[cell.contentView viewWithTag:CHAT_MESSAGE_TEXT];
    [agentLabel setText:@"Hey yoooolooooo yoooolooooo yoooolooooo yoooolooooo yoooolooooo yoooolooooo"];
    
    return cell;

}


- (IBAction)emailSelected:(id)sender {
}
@end

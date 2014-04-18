//
//  SideNavigationController.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 18/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "SideNavigationController.h"

#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

//Importing all the different views that the navigation bar will be showing
#import "MainViewController.h"
#import "HomeViewController.h"
#import "ChatViewController.h"

#define HOME 0
#define CHAT 1
#define SETTING 0
#define VISITORS 2
#define AGENTS 3
#define LOGOUT 1
#define LOGO_WIDTH 20

@interface SideNavigationController () {

    NSArray *dataArray;
    NSArray *settingArray;
    NSArray *sectionHeading;
    NSUInteger selected;
}

@end

@implementation SideNavigationController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray = [[NSArray alloc] initWithObjects:@"HOME",@"MESSAGES", @"VISITORS", @"AGENTS", nil];
    settingArray = [[NSArray alloc] initWithObjects:@"SETTINGS",@"LOGOUT", nil];
    sectionHeading = [[NSArray alloc] initWithObjects:@"Favourites",@"Settings", nil];

    _tableView.scrollEnabled = NO;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition: UITableViewScrollPositionNone];
    
    selected = HOME;
}

- (IBAction)Chat:(id)sender
{
    self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"chatNavigationController"];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section ==0) {
        return [dataArray count];
        
    } else {
        return [settingArray count];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     static NSString *cellIdentifier = @"Cell";
     UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
     if (indexPath.section == 0){
         
         cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
         
         if (indexPath.row == HOME) {
             cell.imageView.image = [Utility scaleImage:[UIImage imageNamed:@"home-512.png"]
                                              toSize: CGSizeMake(LOGO_WIDTH, LOGO_WIDTH)];
             
         } else if(indexPath.row == CHAT) {
             cell.imageView.image = [Utility scaleImage:[UIImage imageNamed:@"speech_bubble-512.png"]
                                              toSize: CGSizeMake(LOGO_WIDTH, LOGO_WIDTH)];

         } else if(indexPath.row == VISITORS) {
             cell.imageView.image = [Utility scaleImage:[UIImage imageNamed:@"group-512.png"]
                                                 toSize: CGSizeMake(LOGO_WIDTH, LOGO_WIDTH)];
         } else if (indexPath.row == AGENTS) {
             cell.imageView.image = [Utility scaleImage:[UIImage imageNamed:@"worker-512.png"]
                                                 toSize: CGSizeMake(LOGO_WIDTH, LOGO_WIDTH)];
         }
         
         
     } else {
         
         cell.textLabel.text = [settingArray objectAtIndex:indexPath.row];
         
         if (indexPath.row == SETTING) {
             cell.imageView.image = [Utility scaleImage:[UIImage imageNamed:@"settings-512.png"]
                                              toSize: CGSizeMake(LOGO_WIDTH, LOGO_WIDTH)];
             
         } else if(indexPath.row == LOGOUT){
             cell.imageView.image = [Utility scaleImage:[UIImage imageNamed:@"logout-512.png"]
                                              toSize: CGSizeMake(LOGO_WIDTH, LOGO_WIDTH)];
         }
     }
     
     cell.textLabel.font = [UIFont fontWithName:@"Marker Felt" size:16];
    
     return cell;
 }

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section != 0) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, view.center.y,  tableView.frame.size.width, 1)];
        
        lineView.backgroundColor =  [UIColor colorWithWhite:0.5 alpha:0.5];
        
        [view addSubview:lineView];
        
        return view;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deallocDelegate];
    switch (indexPath.row) {
        case HOME:
            NSLog(@"selected home");
            selected = HOME;
            self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"homeNavigationController"];
            break;
        case CHAT:
            NSLog(@"Selected chat");
            selected = CHAT;
            self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"chatNavigationController"];
            break;
        default:
            break;
    }
}

- (void) deallocDelegate {
    
    HomeViewController *homeVc;
    ChatViewController *chatVc;
    
    UINavigationController *navController = (UINavigationController *) self.sidePanelController.centerPanel;
    
    switch(selected) {
        case HOME:
            homeVc = (HomeViewController *) [[navController viewControllers] objectAtIndex:0];
            [homeVc deallocDelegate];
            break;
        case CHAT:
            chatVc = (ChatViewController *) [[navController viewControllers] objectAtIndex:0];
            [chatVc deallocDelegate];
            break;
        default:
            break;
    }
}

@end

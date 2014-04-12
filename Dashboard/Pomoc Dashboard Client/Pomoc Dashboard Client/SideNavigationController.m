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
}

- (IBAction)Chat:(id)sender
{
    self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"chatNavigationController"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    switch (indexPath.row) {
        case HOME:
            NSLog(@"selected home");
            self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"homeNavigationController"];
            break;
        case CHAT:
            NSLog(@"Selected chat");
            self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"chatNavigationController"];
            break;
        default:
            break;
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

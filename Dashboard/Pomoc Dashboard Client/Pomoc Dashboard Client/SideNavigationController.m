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

NSInteger const HOME = 0;
NSInteger const CHAT = 1;

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
    dataArray = [[NSArray alloc] initWithObjects:@"Home",@"Chat", nil];
    settingArray = [[NSArray alloc] initWithObjects:@"Settings",@"Logout", nil];
    sectionHeading = [[NSArray alloc] initWithObjects:@"Favourites",@"Settings", nil];

}

- (IBAction)Chat:(id)sender
{
    NSLog(@"clicked chat");
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
     } else {
         cell.textLabel.text = [settingArray objectAtIndex:indexPath.row];
     }
     cell.contentView.backgroundColor = [UIColor darkGrayColor];
     cell.textLabel.textColor = [UIColor whiteColor];
     
     return cell;
 }

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    NSString *string =[sectionHeading objectAtIndex:section];
    
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    //[view setBackgroundColor:[UIColor whiteColor]]; //your background color...
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"selected at index %ld",indexPath.row);
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

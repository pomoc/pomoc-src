//
//  ReferTableViewController.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 14/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "ReferTableViewController.h"

@interface ReferTableViewController () {
    NSArray *option;
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
    option = @[@"Tim", @"Ali", @"Baba"];
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
    
    cell.textLabel.text = [option objectAtIndex:indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected row == %lu",indexPath.row);
    
}

@end

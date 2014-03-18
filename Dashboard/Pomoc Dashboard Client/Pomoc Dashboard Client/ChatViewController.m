//
//  ChatViewController.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 18/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "ChatViewController.h"

NSInteger const HOME = 0;
NSInteger const CHAT = 1;

@interface ChatViewController (){
    NSArray *dataArray;
}

@end

@implementation ChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Messages";
    dataArray = [[NSArray alloc] initWithObjects:@"Home",@"Chat", nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    NSLog(@"came inside number of sections");
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"came inside number of rows");
    // Return the number of rows in the section.
    return [dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"selected at index %ld",indexPath.row);
    switch (indexPath.row) {
        case HOME:
            NSLog(@"selected home");
            [self updateChatView];
            break;
        case CHAT:
            NSLog(@"Selected chat");
            [self updateChatView];
            break;
        default:
            break;
    }
}

- (void) updateChatView
{
    UIColor *randomColor = [self randomUIColor];
    [self.chatView setBackgroundColor:randomColor ];
    NSLog(@"updating chat view!");
}

- (UIColor *) randomUIColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    return color;
}

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

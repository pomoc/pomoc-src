//
//  ContactInfoViewController.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 23/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "ContactInfoViewController.h"
#import "DashBoardSingleton.h"
#import "PomocSupport.h"
#import "PMNote.h"
#import "NotesTableViewCell.h"

@interface ContactInfoViewController () <PomocNoteDelegate>
{
    DashBoardSingleton *singleton;
    NSArray *noteList;
}

@end

@implementation ContactInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    singleton = [DashBoardSingleton singleton];
    singleton.notesDelegate = self;
    
    //remove table view border
    _notesTableView.separatorColor = [UIColor clearColor];

    noteList = _currentConversation.notes;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [noteList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    NotesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //update the UILabel's height based on text size
    /*
    _messageText.numberOfLines = 0;
    
    CGSize maximumLabelSize = CGSizeMake(_messageText.frame.size.width, 9999);
    CGSize expectedSize = [_messageText sizeThatFits:maximumLabelSize];
    
    CGRect newFrame = _messageText.frame;
    newFrame.size.height = expectedSize.height;
    _messageText.frame = newFrame;
    */
    
    PMNote *note = [noteList objectAtIndex:indexPath.row];
    
    cell.notesInfo.text = note.note;
    
    //setting the started date of chat
    NSString *dateString = [Utility formatDateForTable:note.timestamp];
    cell.dateLabel.text = dateString;
    
    //cell.textLabel.text = note.note;
    
    return cell;
}

- (IBAction)addNotesPressed:(id)sender {
    NSLog(@"add notes pressed");
    
    NSLog(@"current conversation id == %@",_currentConversation.conversationId);
    NSLog(@"text == %@",_inputText.text);
    
    [_currentConversation sendNote:_inputText.text];
    _inputText.text = @"";
}

#pragma mark - PomocRefer Delegate
- (void) updateNoteList: (PMConversation *)convo;
{
    if ([convo.conversationId isEqualToString:_currentConversation.conversationId]) {
        noteList = convo.notes;
        [_notesTableView reloadData];
    }
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

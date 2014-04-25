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

@interface ContactInfoViewController () <PomocNoteDelegate> {
    DashBoardSingleton *singleton;
    NSArray *noteList;
}

@end

@implementation ContactInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    singleton = [DashBoardSingleton singleton];
    singleton.notesDelegate = self;
    
    //remove table view border
    _notesTableView.separatorColor = [UIColor clearColor];

    noteList = _currentConversation.notes;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return noteList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = NOTE_REUSE_CELL;
    NotesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    PMNote *note = [noteList objectAtIndex:indexPath.row];
    
    cell.notesInfo.text = note.note;
    
    //setting the started date of chat
    NSString *dateString = [Utility formatDateForTable:note.timestamp];
    cell.dateLabel.text = dateString;
    
    return cell;
}

- (IBAction)addNotesPressed:(id)sender {
    [_currentConversation sendNote:_inputText.text];
    _inputText.text = @"";
}

#pragma mark - PomocRefer Delegate
- (void)updateNoteList:(PMConversation *)convo; {
    if ([convo.conversationId isEqualToString:_currentConversation.conversationId]) {
        noteList = convo.notes;
        [_notesTableView reloadData];
    }
}

-(BOOL)shouldAutorotate {
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}
@end

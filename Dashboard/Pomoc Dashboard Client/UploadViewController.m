//
//  UploadViewController.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 30/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "UploadViewController.h"
#import "ChatViewController.h"

@interface UploadViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
}

@end

@implementation UploadViewController

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
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self showActionSheet];
    
}

- (void) showActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Upload image from?"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Camera", @"Photos Library", nil];
    
    [actionSheet showInView:self.view];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage* originalImage = nil;
    originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if(originalImage==nil) {
        originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [_delegate pictureSelected:originalImage];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
        [_delegate closePopOver];
        return;
    }

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    NSLog(@"button pressed == %@",[actionSheet buttonTitleAtIndex:buttonIndex]);
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Camera"]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Photos Library"]) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Photos Library"]) {
        return;
    }
    
    
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    //[self presentViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:^(){}];
}
@end

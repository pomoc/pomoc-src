//
//  UploadViewController.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 30/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "UploadViewController.h"
#import "ChatViewController.h"

@interface UploadViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self showActionSheet];
    
}

- (void) showActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:UPLOAD_ACTION_SHEET_TITLE
                                                             delegate:self
                                                    cancelButtonTitle:UPLOAD_CANCEL
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:UPLOAD_ACTION_SHEET_CAM, UPLOAD_ACTION_SHEET_PICT, nil];
    
    [actionSheet showInView:self.view];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES
                               completion:nil];
    
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!originalImage) {
        originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [_delegate pictureSelected:originalImage];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:UPLOAD_CANCEL]) {
        [_delegate closePopOver];
        return;
    }

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:UPLOAD_ACTION_SHEET_CAM]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformRotate(transform, M_PI/2.0);
        picker.cameraViewTransform = transform;
    
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:UPLOAD_ACTION_SHEET_PICT]) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self presentViewController:picker animated:YES completion:^(){}];
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

@end

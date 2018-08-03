//
//  AddNewAdvisoryPopUp.m
//  LiveStoc
//
//  Created by Harjit Singh on 1/17/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import "AddNewAdvisoryPopUp.h"

@interface AddNewAdvisoryPopUp ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *picker;
    UIImage *image;
    NSData *imageData;
}
@end

@implementation AddNewAdvisoryPopUp

- (void)viewDidLoad {
    [super viewDidLoad];
    picker=[[UIImagePickerController alloc]init];
    picker.delegate=self;
    picker.allowsEditing=YES;
    _thumbNailImgVw.image=[UIImage imageNamed:@"picture"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)onTapBackgroundOfPopUp:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTapPostQuestion:(UIButton *)sender {
   
    NSString *error=@"";
    
        if ([_titleTF hasText]) {
            if ([_queryTV hasText]) {
                [self addNewAdvisory];
            } else {
                error=AMLocalizedString(@"COMPLETE_ALL_FIELDS", nil);
            }
        } else {
            error=AMLocalizedString(@"COMPLETE_ALL_FIELDS", nil);
        }
    
    if (error.length>0) {
        
        [self.view makeToast:error duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-80)]];
    }
}
-(void)addNewAdvisory
{
    [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];
    
    [UKNetworkManager operationType:UPLOAD fromPath:@"advisory/add" withParameters:@{@"users_id":[UKNetworkManager getFromDefaultsWithKeyString:USER_ID],@"submit":@"Go",@"title":_titleTF.text,@"description":_queryTV.text}.mutableCopy withUploadData:imageData ? @{@"images":imageData}.mutableCopy:nil :^(id result) {
        
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            [[[[UIApplication sharedApplication] delegate] window] makeToast:[result valueForKey:@"data"] duration:3.0 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-80)]];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            
            [UKNetworkManager showAlertWithTitle:AMLocalizedString(@"error", nil) messageTitle:AMLocalizedString(@"try_again", nil) okTitle:nil cancelTitle:AMLocalizedString(@"ok", @"ok") otherTitles:nil];
        }
        [DejalBezelActivityView removeViewAnimated:YES];
        
    } :^(NSError *error, NSString *errorMessage) {
        [DejalBezelActivityView removeViewAnimated:YES];
        [UKNetworkManager showAlertWithTitle:errorMessage messageTitle:nil okTitle:nil cancelTitle:AMLocalizedString(@"ok", @"ok") otherTitles:nil];

    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    image                   = [info objectForKey:UIImagePickerControllerOriginalImage];
    image                   = [info valueForKey:UIImagePickerControllerEditedImage];
    
    _selectedImgVw.image=image;
    _thumbNailImgVw.hidden=YES;
    
    imageData=UIImageJPEGRepresentation(image, 0.7);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)onTapSelectImage:(UITapGestureRecognizer *)sender {
    
    UIAlertController *popForPicker=[UIAlertController alertControllerWithTitle:AMLocalizedString(@"select_picture", @"select_picture") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *gallery=[UIAlertAction actionWithTitle:AMLocalizedString(@"gallery", @"gallery") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    
    UIAlertAction *camera=[UIAlertAction actionWithTitle:AMLocalizedString(@"camera", @"camera") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:AMLocalizedString(@"cancel", @"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [popForPicker addAction:camera];
    [popForPicker addAction:gallery];
    [popForPicker addAction:cancel];
    
    [self presentViewController:popForPicker animated:YES completion:nil];
}
@end

//
//  AlmostDoneVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 12/9/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "AlmostDoneVC.h"
#import "TabBarControllerClass.h"
@interface AlmostDoneVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,KPDropMenuDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSInteger index;
    NSMutableDictionary *dropDownsDict;
    UIImagePickerController *picker;
    UIImage *image;
    NSMutableAttributedString *symbol;
}
@end

@implementation AlmostDoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    dropDownsDict=[[NSMutableDictionary alloc] init];
    picker=[[UIImagePickerController alloc]init];
    picker.delegate=self;
    picker.allowsEditing=YES;
    index=0;
    self.photosCollVw.delegate=self;
    self.photosCollVw.dataSource=self;
    _animalDetailsScrollVw.hidden=NO;
    _uploadPhotosVw.hidden=YES;
    _priceVw.hidden=YES;
    _animalFeaturesImgVw.image=[UIImage imageNamed:@"animal_active"];
    _uploadPhotosImgVw.image=[UIImage imageNamed:@"upload"];
    _priceImgVw.image=[UIImage imageNamed:@"price"];
    dropDownsDict=@{@"beeds":@[].mutableCopy,@"yearsAge":@[].mutableCopy,@"monthsAge":@[].mutableCopy,@"gender":@[@"male",@"female"].mutableCopy,@"lactation":@[].mutableCopy,@"isPregn":@[AMLocalizedString(@"yes", @"yes"),AMLocalizedString(@"no", @"no")].mutableCopy,@"pregnMnths":@[].mutableCopy}.mutableCopy;
    
    self.navigationItem.title=AMLocalizedString(@"almost_done", @"almost_done");

    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        symbol=[[[NSAttributedString alloc] initWithData:[_currencySymb dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil] mutableCopy];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
////            _currencyCodeLabel.text=symbol.strin;
//            [_currencyCodeLabel setText:_currencySymb];
    _currencyCodeLabel.text=[NSString base64String:_currencySymb];
//        });
//
//    });
    
    
    if ([[[[UKModel model] selectedCategory] valueForKey:@"beeds"] isKindOfClass:[NSArray class]]) {
    for (NSDictionary *dict in [[[UKModel model] selectedCategory] valueForKey:@"beeds"])
    {
        [[dropDownsDict valueForKey:@"beeds"] addObject:[dict valueForKey:@"breed_name"]];
    }
        [[dropDownsDict valueForKey:@"beeds"] addObject:AMLocalizedString(@"other", @"other")];

    } else {
        [[dropDownsDict valueForKey:@"beeds"] addObject:AMLocalizedString(@"other", @"other")];
    }
    for (int i=0; i<100; i++) {
        [[dropDownsDict valueForKey:@"yearsAge"] addObject:[NSString stringWithFormat:@"%d",i]];
    }
    for (int i=0; i<12; i++) {
        [[dropDownsDict valueForKey:@"monthsAge"] addObject:[NSString stringWithFormat:@"%d",i]];
    }
    for (int i=1; i<11; i++) {
        [[dropDownsDict valueForKey:@"lactation"] addObject:[NSString stringWithFormat:@"%d",i]];
    }
    for (int i=0; i<11; i++) {
        [[dropDownsDict valueForKey:@"pregnMnths"] addObject:[NSString stringWithFormat:@"%d",i]];
    }

    
    [_animalFeaturesBtn setTitle:AMLocalizedString(@"animal_features", @"animal_features") forState:UIControlStateNormal];
    [_upLoadPhotosBtn setTitle:AMLocalizedString(@"upload_photo", @"upload_photo") forState:UIControlStateNormal];
    [_priceBtn setTitle:AMLocalizedString(@"price", @"price") forState:UIControlStateNormal];
    _litresLbl.text=AMLocalizedString(@"liter", @"Litres");

    _addPhotosLabel.text=AMLocalizedString(@"add_photo", @"add_photo");
    _nameOfAnimalTF.placeholder=AMLocalizedString(@"name_id_tag", @"name_id_tag");
    _breedNameTF.placeholder=AMLocalizedString(@"breed_name", @"breed_name");
    _minYieldTF.placeholder=AMLocalizedString(@"min_yield", @"min_yield");
    _maxYieldTF.placeholder=AMLocalizedString(@"max_yield", @"max_yield");
    _mothersNameTF.placeholder=AMLocalizedString(@"mother_name", @"mother_name");
    _fathersNameTF.placeholder=AMLocalizedString(@"father_name", @"father_name");
    _heightTF.placeholder=AMLocalizedString(@"height_cm", @"height_cm");
    _weightTF.placeholder=AMLocalizedString(@"weight_kg", @"weight_kg");
    [_descriptionTextVw setPlaceHolder:AMLocalizedString(@"description", @"description")];
    [_nextLabelOfAnimalDetails setTitle:AMLocalizedString(@"next", @"next") forState:UIControlStateNormal];
    _enterPriceLabel.text=AMLocalizedString(@"enter_price", @"enter_price");
    _priceTF.placeholder=AMLocalizedString(@"enter_price", @"enter_price");
    
    [_nextBtnOfPriceVw setTitle:AMLocalizedString(@"next", @"next") forState:UIControlStateNormal];
    [_nextBtnOfUploadPhotosVC setTitle:AMLocalizedString(@"next", @"next") forState:UIControlStateNormal];
    [_previousBtnOfPrice setTitle:AMLocalizedString(@"previous", @"previous") forState:UIControlStateNormal];
    [_previousBtnOfUploadPhotosVw setTitle:AMLocalizedString(@"previous", @"previous") forState:UIControlStateNormal];

    _breedDropDwn.items=dropDownsDict[@"beeds"];
    _breedDropDwn.title=AMLocalizedString(@"select_breed", @"select_breed");
    _breedDropDwn.delegate=self;

    _yearsAgeDrpDwn.items=dropDownsDict[@"yearsAge"];
    _yearsAgeDrpDwn.title=AMLocalizedString(@"age_in_year", @"age_in_year");;
    _yearsAgeDrpDwn.delegate=self;

    _monthsAgeDrpDwn.items=dropDownsDict[@"monthsAge"];
    _monthsAgeDrpDwn.title=AMLocalizedString(@"age_in_month", @"age_in_month");;
    _monthsAgeDrpDwn.delegate=self;

    _genderDrpDwn.items=dropDownsDict[@"gender"];
    _genderDrpDwn.title=AMLocalizedString(@"gender", @"gender");;
    _genderDrpDwn.delegate=self;

    _lactationDropDwn.items=dropDownsDict[@"lactation"];
    _lactationDropDwn.title=AMLocalizedString(@"lactation", @"lactation");;
    _lactationDropDwn.delegate=self;

    _isPregnantDrpDwn.items=dropDownsDict[@"isPregn"];
    _isPregnantDrpDwn.title=AMLocalizedString(@"is_pregnant_ques", @"is_pregnant_ques");;
    _isPregnantDrpDwn.delegate=self;

    _pregnantMonthsDropDwn.items=dropDownsDict[@"pregnMnths"];
    _pregnantMonthsDropDwn.title=AMLocalizedString(@"pregnancy_month", @"pregnancy_month");;
    _pregnantMonthsDropDwn.delegate=self;

    _yeildVw.hidden=YES;
    _lactationDropDwn.hidden=YES;
    _isPregnantDrpDwn.hidden=YES;
    _pregnantMonthsDropDwn.hidden=YES;
    _topConstraintOfMotherNameTF.constant=-210;
    
    if ([[[[UKModel model] sellAnimalDetails] valueForKey:@"category_id"] integerValue]==9) {
        
        _genderDrpDwn.hidden=YES;
        _lactationDropDwn.hidden=YES;
        _isPregnantDrpDwn.hidden=YES;
        _pregnantMonthsDropDwn.hidden=YES;
        _yeildVw.hidden=YES;
        _topConstraintOfMotherNameTF.constant=-265;
        
    }
    _breedNameTF.hidden=YES;
    _topConstraintOfYearsDropDwn.constant=-45;
    
    NSLog(@"Drop Downs Dict List : %@",dropDownsDict);
    NSLog(@"Selected Dict Data : %@",[[UKModel model] selectedCategory]);
    
    [[[UKModel model] sellAnimalDetails] setValue:@"" forKey:@"gender"];
    [[[UKModel model] sellAnimalDetails] setValue:@"" forKey:@"title"];
    [[[UKModel model] sellAnimalDetails] setValue:@"" forKey:@"breed_id"];
    [[[UKModel model] sellAnimalDetails] setValue:@"" forKey:@"breed_name"];
    [[[UKModel model] sellAnimalDetails] setValue:@"" forKey:@"age"];
    [[[UKModel model] sellAnimalDetails] setValue:@"" forKey:@"age_month"];

}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[UKModel model] postImages] count];
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UKCollectionCell *item=[self.photosCollVw dequeueReusableCellWithReuseIdentifier:@"sellPhotos" forIndexPath:indexPath];
    item.selectedImgVwOFAlmostDoneVC.image=[UIImage imageWithData:[[[UKModel model] postImages] objectAtIndex:indexPath.row]];
    item.removeImgBtnOfAlmostDoneVC.tag=indexPath.row;
    return item;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.photosCollVw.frame.size.width/3, self.photosCollVw.frame.size.width/3);
}

-(void)didShow : (KPDropMenu *)dropMenu
{
    [self.view endEditing:YES];
}
-(void)didSelectItem : (KPDropMenu *) dropMenu atIndex : (int) atIndex
{
    if (dropMenu==_breedDropDwn)
    {
        if (_breedDropDwn.items.count-1==atIndex) {
            _breedNameTF.hidden=NO;
            _topConstraintOfYearsDropDwn.constant=10;
            
            [[[UKModel model] sellAnimalDetails] setValue:@"" forKey:@"breed_id"];


        } else {
            _breedNameTF.hidden=YES;
            _topConstraintOfYearsDropDwn.constant=-45;
            [[[UKModel model] sellAnimalDetails] setValue:[[[[[UKModel model] selectedCategory] valueForKey:@"beeds"] objectAtIndex:atIndex] valueForKey:@"breed_id"] forKey:@"breed_id"];

        }
    }
    else if (dropMenu==_yearsAgeDrpDwn)
    {
        [[[UKModel model] sellAnimalDetails] setValue:[NSString stringWithFormat:@"%@",[[dropDownsDict valueForKey:@"yearsAge"]objectAtIndex:atIndex]] forKey:@"age"];
        
    }
    else if (dropMenu==_monthsAgeDrpDwn)
    {
        [[[UKModel model] sellAnimalDetails] setValue:[NSString stringWithFormat:@"%@",[[dropDownsDict valueForKey:@"monthsAge"]objectAtIndex:atIndex]] forKey:@"age_month"];

    }
    else if (dropMenu==_genderDrpDwn)
    {
        if (atIndex==1) {
            if ([[[[UKModel model] sellAnimalDetails] valueForKey:@"category_id"] integerValue] ==1 || [[[[UKModel model] sellAnimalDetails] valueForKey:@"category_id"] integerValue] ==8 || [[[[UKModel model] sellAnimalDetails] valueForKey:@"category_id"] integerValue] ==11 || [[[[UKModel model] sellAnimalDetails] valueForKey:@"category_id"] integerValue] ==10) {
                
                _yeildVw.hidden=NO;
                _lactationDropDwn.hidden=NO;
                _isPregnantDrpDwn.hidden=NO;
                _topConstraintOfMotherNameTF.constant=-45;

            } else {
                
                _yeildVw.hidden=YES;
                _lactationDropDwn.hidden=YES;
                _isPregnantDrpDwn.hidden=NO;
                _genderDrpDwn.hidden=NO;
                _topConstraintOfMotherNameTF.constant=-45;
                _topConstraintOfPregnantDropDwn.constant=-100;

            }
            
            _lactationDropDwn.items=dropDownsDict[@"lactation"];
            _lactationDropDwn.title=AMLocalizedString(@"lactation", @"lactation");;
            _lactationDropDwn.delegate=self;
            
            _isPregnantDrpDwn.items=dropDownsDict[@"isPregn"];
            _isPregnantDrpDwn.title=AMLocalizedString(@"is_pregnant_ques", @"is_pregnant_ques");;
            _isPregnantDrpDwn.delegate=self;
            
            _pregnantMonthsDropDwn.items=dropDownsDict[@"pregnMnths"];
            _pregnantMonthsDropDwn.title=AMLocalizedString(@"pregnancy_month", @"pregnancy_month");;
            _pregnantMonthsDropDwn.delegate=self;
            [[[UKModel model] sellAnimalDetails] setValue:@"female" forKey:@"gender"];

        } else {
            _yeildVw.hidden=YES;
            _lactationDropDwn.hidden=YES;
            _isPregnantDrpDwn.hidden=YES;
            _pregnantMonthsDropDwn.hidden=YES;
            
            if ([[[[UKModel model] sellAnimalDetails] valueForKey:@"category_id"] integerValue] ==1 || [[[[UKModel model] sellAnimalDetails] valueForKey:@"category_id"] integerValue] ==8 || [[[[UKModel model] sellAnimalDetails] valueForKey:@"category_id"] integerValue] ==11 || [[[[UKModel model] sellAnimalDetails] valueForKey:@"category_id"] integerValue] ==10) {
                _topConstraintOfMotherNameTF.constant=-210;
            } else {
                _topConstraintOfMotherNameTF.constant=-100;
            }
            [[[UKModel model] sellAnimalDetails] setValue:@"male" forKey:@"gender"];

        }
    }
    else if (dropMenu==_lactationDropDwn)
    {
        [[[UKModel model] sellAnimalDetails] setValue:[NSString stringWithFormat:@"%@",[[dropDownsDict valueForKey:@"lactation"]objectAtIndex:atIndex]] forKey:@"lactation"];

    }
    else if (dropMenu==_isPregnantDrpDwn)
    {
        if (atIndex==0) {
            
            _pregnantMonthsDropDwn.hidden=NO;
            _topConstraintOfMotherNameTF.constant=10;
            [[[UKModel model] sellAnimalDetails] setValue:@"yes" forKey:@"isPregnant"];

        } else {
            _pregnantMonthsDropDwn.hidden=NO;
            _topConstraintOfMotherNameTF.constant=-45;
            [[[UKModel model] sellAnimalDetails] setValue:@"no" forKey:@"isPregnant"];

        }
    }
    else
    {
        [[[UKModel model] sellAnimalDetails] setValue:[NSString stringWithFormat:@"%@",[[dropDownsDict valueForKey:@"pregnMnths"]objectAtIndex:atIndex]] forKey:@"pregnant_month"];
        

    }
}

- (IBAction)onTapNextOfFeaturesSec:(UIButton *)sender {
    
    bool checked=NO;
    
    [[[UKModel model] sellAnimalDetails] setValue:_nameOfAnimalTF.text forKey:@"title"];
    [[[UKModel model] sellAnimalDetails] setValue:_minYieldTF.text forKey:@"yield"];
    [[[UKModel model] sellAnimalDetails] setValue:_maxYieldTF.text forKey:@"yield_max"];
    [[[UKModel model] sellAnimalDetails] setValue:_descriptionTextVw.text forKey:@"description"];
    [[[UKModel model] sellAnimalDetails] setValue:_mothersNameTF.text forKey:@"mother"];
    [[[UKModel model] sellAnimalDetails] setValue:_fathersNameTF.text forKey:@"father"];
    [[[UKModel model] sellAnimalDetails] setValue:_heightTF.text forKey:@"height"];
    [[[UKModel model] sellAnimalDetails] setValue:_weightTF.text forKey:@"weight"];
    [[[UKModel model] sellAnimalDetails] setValue:_breedNameTF.text forKey:@"breed_name"];

    if ([_nameOfAnimalTF hasText]) {
        
        if ([[[[UKModel model] sellAnimalDetails] valueForKey:@"breed_name"] length]>0 || [[[[UKModel model] sellAnimalDetails] valueForKey:@"breed_id"] length] >0) {
            
            if ([[[[UKModel model] sellAnimalDetails] valueForKey:@"age"] length]>0 || [[[[UKModel model] sellAnimalDetails] valueForKey:@"age_month"] length] >0) {
                
                if ([[[[UKModel model] sellAnimalDetails] valueForKey:@"gender"] length] > 0) {
                    
                    
                    checked=YES;
                    NSLog(@"%@",[[UKModel model] sellAnimalDetails]);
                    
                } else {
                    [self.view makeToast:[NSString stringWithFormat:@"%@ %@",AMLocalizedString(@"please_enter", nil),AMLocalizedString(@"gender", nil)] duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];

                }
                
            } else {
                [self.view makeToast:[NSString stringWithFormat:@"%@ %@",AMLocalizedString(@"please_enter", nil),AMLocalizedString(@"age_in_year", nil)] duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];

            }
            
        } else {
            [self.view makeToast:[NSString stringWithFormat:@"%@ %@",AMLocalizedString(@"please_enter", nil),AMLocalizedString(@"breed_name", nil)] duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];

        }
        
    } else {
        [self.view makeToast:[NSString stringWithFormat:@"%@ %@",AMLocalizedString(@"please_enter", nil),AMLocalizedString(@"name_id_tag", nil)] duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];

    }
    
    if (checked) {
        
        __block  CGRect basketTopFrame = _animalDetailsScrollVw.frame;
        basketTopFrame.origin.x = -500;
        [UIView animateWithDuration:0.3 animations:^{
            _animalDetailsScrollVw.frame = basketTopFrame;
        } completion:^(BOOL finished) {
            
            _animalDetailsScrollVw.hidden=YES;
            _uploadPhotosVw.hidden=NO;
            _priceVw.hidden=YES;
            _uploadPhotosImgVw.image=[UIImage imageNamed:@"upload_active"];
            
            basketTopFrame.origin.x = 500;
            _uploadPhotosVw.frame = basketTopFrame;
            [UIView animateWithDuration:0.3 animations:^{
                basketTopFrame.origin.x = 15;
                _uploadPhotosVw.frame = basketTopFrame;
            } completion:^(BOOL finished) {
            }];
        }];
        
    }
    
}

- (IBAction)onTapPreviousOfUploadPhotoSec:(UIButton *)sender {
    
    __block  CGRect basketTopFrame = _uploadPhotosVw.frame;
    basketTopFrame.origin.x = 500;
    
    [UIView animateWithDuration:0.3 animations:^{
        _uploadPhotosVw.frame = basketTopFrame;
    } completion:^(BOOL finished) {
        
        _animalDetailsScrollVw.hidden=NO;
        _uploadPhotosVw.hidden=YES;
        _priceVw.hidden=YES;
        _uploadPhotosImgVw.image=[UIImage imageNamed:@"upload"];
        
        basketTopFrame.origin.x = -500;
        _animalDetailsScrollVw.frame = basketTopFrame;
        [UIView animateWithDuration:0.3 animations:^{
            basketTopFrame.origin.x = 15;
            _animalDetailsScrollVw.frame = basketTopFrame;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (IBAction)onTapNextOfUploadPhotoSec:(UIButton *)sender {
    
    
    if ([[[UKModel model] postImages] count]>0) {
        
        __block  CGRect basketTopFrame = _uploadPhotosVw.frame;
        basketTopFrame.origin.x = -500;
        [UIView animateWithDuration:0.3 animations:^{
            _uploadPhotosVw.frame = basketTopFrame;
        } completion:^(BOOL finished) {
            
            _animalDetailsScrollVw.hidden=YES;
            _uploadPhotosVw.hidden=YES;
            _priceVw.hidden=NO;
            
            _uploadPhotosImgVw.image=[UIImage imageNamed:@"upload_active"];
            _priceImgVw.image=[UIImage imageNamed:@"price_active"];
            
            basketTopFrame.origin.x = 500;
            _priceVw.frame = basketTopFrame;
            [UIView animateWithDuration:0.3 animations:^{
                basketTopFrame.origin.x = 15;
                _priceVw.frame = basketTopFrame;
            } completion:^(BOOL finished) {
            }];
        }];
    } else {
        
        [self.view makeToast:AMLocalizedString(@"add_photo", @"add_photo") duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];

    }
}

- (IBAction)onTapNextOfPriceSec:(UIButton *)sender {
    
    if ([_priceTF hasText]) {
        [[[UKModel model] sellAnimalDetails] setValue:_priceTF.text forKey:@"price"];
        [self performSegueWithIdentifier:@"toCertification" sender:self];

    } else {
        [self.view makeToast:AMLocalizedString(@"enter_price", @"enter_price") duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];

    } 
}

- (IBAction)onTapPreviousOfPriceSec:(UIButton *)sender {
    
    __block  CGRect basketTopFrame = _priceVw.frame;
    basketTopFrame.origin.x = 500;
    
    [UIView animateWithDuration:0.3 animations:^{
        _priceVw.frame = basketTopFrame;
    } completion:^(BOOL finished) {
        
        _animalDetailsScrollVw.hidden=YES;
        _uploadPhotosVw.hidden=NO;
        _priceVw.hidden=YES;
        
        _uploadPhotosImgVw.image=[UIImage imageNamed:@"upload_active"];
        _priceImgVw.image=[UIImage imageNamed:@"price"];
        
        
        basketTopFrame.origin.x = -500;
        _uploadPhotosVw.frame = basketTopFrame;
        [UIView animateWithDuration:0.3 animations:^{
            basketTopFrame.origin.x = 15;
            _uploadPhotosVw.frame = basketTopFrame;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    image                   = [info objectForKey:UIImagePickerControllerOriginalImage];
    image                   = [info valueForKey:UIImagePickerControllerEditedImage];
    
    [[[UKModel model] postImages] addObject:UIImageJPEGRepresentation(image, 0.7)];
    [_photosCollVw reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)onTapBackButton:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onTapAddButton:(UIButton *)sender {
    
    
    if ([[[UKModel model] postImages] count]>9) {
        
        [self.view makeToast:AMLocalizedString(@"max_photo", @"max_photo") duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];

    } else {
        
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
}
- (IBAction)onTapRemoveSelectedImg:(UIButton *)sender {
    
    [[[UKModel model] postImages] removeObjectAtIndex:sender.tag];
    [_photosCollVw reloadData];

}
@end
















@interface FinalPostVC ()
{
}
@end

@implementation FinalPostVC

- (void)viewDidLoad {
    [super viewDidLoad];

    _interestedCertificationLabel.text=AMLocalizedString(@"certified_screen", @"certified_screen");
    self.navigationItem.title=AMLocalizedString(@"certification", @"CERTIFICATIONS");
    [_yesBtn setTitle:AMLocalizedString(@"yes", @"yes") forState:UIControlStateNormal];
    [_noBtn setTitle:AMLocalizedString(@"no", @"no") forState:UIControlStateNormal];
    [_mayBeBtn setTitle:AMLocalizedString(@"may_be", @"may_be") forState:UIControlStateNormal];
    [_postBtn setTitle:AMLocalizedString(@"post", @"post") forState:UIControlStateNormal];
    
    [_noBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_noBtn setBackgroundColor:[UIColor redColor]];
    
    [_yesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_yesBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_mayBeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_mayBeBtn setBackgroundColor:[UIColor lightGrayColor]];
    [[[UKModel model] sellAnimalDetails] setValue:@"" forKey:@"animal_certified"];

}

- (IBAction)onTapCertificationStatusBtn:(UKButton *)sender {
    
    if (sender.tag==11) {
        [_noBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_noBtn setBackgroundColor:[UIColor lightGrayColor]];
        
        [_yesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_yesBtn setBackgroundColor:[UIColor redColor]];
        [_mayBeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_mayBeBtn setBackgroundColor:[UIColor lightGrayColor]];
        [[[UKModel model] sellAnimalDetails] setValue:@"Yes" forKey:@"animal_certified"];

    }
    else if (sender.tag==12)
    {
        [_noBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_noBtn setBackgroundColor:[UIColor redColor]];
        
        [_yesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_yesBtn setBackgroundColor:[UIColor lightGrayColor]];
        [_mayBeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_mayBeBtn setBackgroundColor:[UIColor lightGrayColor]];
        [[[UKModel model] sellAnimalDetails] setValue:@"No" forKey:@"animal_certified"];

    }
    else
    {
        [_noBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_noBtn setBackgroundColor:[UIColor lightGrayColor]];
        
        [_yesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_yesBtn setBackgroundColor:[UIColor lightGrayColor]];
        [_mayBeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mayBeBtn setBackgroundColor:[UIColor redColor]];
        [[[UKModel model] sellAnimalDetails] setValue:@"May be" forKey:@"animal_certified"];

    }
}

- (IBAction)onTapPostBtn:(UIButton *)sender {
    
    [[[UKModel model] sellAnimalDetails] setValue:[UKNetworkManager getFromDefaultsWithKeyString:USER_ID] forKey:@"users_id"];
    [[[UKModel model] sellAnimalDetails] setValue:@"Go" forKey:@"submit"];
    
    NSLog(@"%@",[UKNetworkManager getFromDefaultsWithKeyString:USER_DETAILS]);
    
    
//    [[[UKModel model] sellAnimalDetails] setValue:arrayMain forKey:@"images"];

    [self postPost:[[UKModel model] sellAnimalDetails] withImages:[[UKModel model] postImages] path:@"selling/add?"];
    
}

-(void)postPost:(NSMutableDictionary *)paramDict withImages:(NSMutableArray *)images path:(NSString *)path
{
    
    [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];

    NSString *boundary = [self generateBoundaryString];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_URL,path]]];
    [request setHTTPMethod:@"POST"];

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];

    NSMutableData *httpBody=[NSMutableData data];

    for (NSString *key in [paramDict allKeys]) {


        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";",key] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: text/plain\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[paramDict valueForKey:key] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    }


    NSInteger name=0;
    for (NSData *data in images) {
        
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"images[%ld]\"; filename=\"image%ld.jpg\"\r\n",(long)name,(long)name] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",[self mimeTypeForData:data]] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:data];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        name=name+1;
        
    }


    [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];

    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    NSURLSessionDataTask *uploadTassk=[session uploadTaskWithRequest:request fromData:httpBody completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        dispatch_async(dispatch_get_main_queue(), ^{

        if (response != nil)
        {
            if ([[self acceptableStatusCodes] containsIndex:[(NSHTTPURLResponse *)response statusCode]])
            {
                if ([data length] > 0)
                {
                    NSError * jsonError  = nil;
                    id jsonObject  = nil;

                    jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];


                    if ([[jsonObject valueForKey:SUCCESS] integerValue]==1) {

                        [[[UKModel model] sellAnimalDetails] removeAllObjects];
                        [[[UKModel model] postImages] removeAllObjects];


                        [self performSegueWithIdentifier:@"presentFinalPop" sender:self];

                    } else {

                        [self.view makeToast:[NSString stringWithFormat:@"%@\n %@",AMLocalizedString(@"error", nil),AMLocalizedString(@"try_again", nil)] duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];

                    }

                    [DejalBezelActivityView removeViewAnimated:YES];

                }
                else
                {
                    [self.view makeToast:[NSString stringWithFormat:@"%@\n %@",AMLocalizedString(@"error", nil),AMLocalizedString(@"try_again", nil)] duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];
                    [DejalBezelActivityView removeViewAnimated:YES];

                }
            }
            else
            {

                if ([(NSHTTPURLResponse *)response statusCode] == 0) {
                    [self.view makeToast:[NSString stringWithFormat:@"%@\n %@",AMLocalizedString(@"error", nil),AMLocalizedString(@"try_again", nil)] duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];


                }
                else if ([(NSHTTPURLResponse *)response statusCode] == 404 || [(NSHTTPURLResponse *)response statusCode] >= 500)
                {
                    [self.view makeToast:[NSString stringWithFormat:@"%@\n %@",AMLocalizedString(@"error", nil),AMLocalizedString(@"try_again", nil)] duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];


                }
                else
                {
                    [self.view makeToast:[NSString stringWithFormat:@"%@\n %@",AMLocalizedString(@"error", nil),AMLocalizedString(@"try_again", nil)] duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];

                }

            }
            [DejalBezelActivityView removeViewAnimated:YES];

        }
        else
        {
            [self.view makeToast:[NSString stringWithFormat:@"%@\n %@",AMLocalizedString(@"error", nil),AMLocalizedString(@"try_again", nil)] duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];
            [DejalBezelActivityView removeViewAnimated:YES];

        }
        });
    }];


    [uploadTassk resume];
}
- (NSIndexSet *) acceptableStatusCodes
{
    return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 99)];
}
- (NSString *)generateBoundaryString
{
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}
-(NSString *)mimeTypeForData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
            break;
        case 0x89:
            return @"image/png";
            break;
        case 0x47:
            return @"image/gif";
            break;
        case 0x49:
        case 0x4D:
            return @"image/tiff";
            break;
        case 0x25:
            return @"application/pdf";
            break;
        case 0xD0:
            return @"application/vnd";
            break;
        case 0x46:
            return @"text/plain";
            break;
        default:
            return @"application/octet-stream";
    }
    return nil;
}

@end








@interface PopUpPostFinal ()

@end

@implementation PopUpPostFinal

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _congratesLabel.text=AMLocalizedString(@"congratulation", @"congratulation");
    _congratesDetailsLabel.text=AMLocalizedString(@"success_post", @"success_post");
    
}

- (IBAction)onTapOkButton:(UIButton *)sender {
    
    
}
@end


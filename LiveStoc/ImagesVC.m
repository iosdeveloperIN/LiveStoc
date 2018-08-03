//
//  ImagesVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 12/14/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "ImagesVC.h"

@interface ImagesVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    
}
@end

@implementation ImagesVC
@synthesize selectedIndex,imagesArr;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=_navTitle;
    _largeCollVw.delegate=self;
    _largeCollVw.dataSource=self;
    
    
    _smallCollVw.delegate=self;
    _smallCollVw.dataSource=self;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_largeCollVw scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];

}
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return imagesArr.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (collectionView.tag==221356) {
        UKCollectionCell *largeItem=[_largeCollVw dequeueReusableCellWithReuseIdentifier:@"largeItem" forIndexPath:indexPath];
        [largeItem.largeAnimalImgVwOfImagesVC sd_setImageWithURL:imagesArr[indexPath.row][@"fullimages"] placeholderImage:[UIImage imageNamed:@"p"] options:SDWebImageHighPriority];
        return largeItem;
    } else {
        UKCollectionCell *smallItem=[_smallCollVw dequeueReusableCellWithReuseIdentifier:@"smallItem" forIndexPath:indexPath];
        [smallItem.smallAnimalImgVwOfImagesVC sd_setImageWithURL:imagesArr[indexPath.row][@"images"] placeholderImage:[UIImage imageNamed:@"p"] options:SDWebImageHighPriority];

        return smallItem;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView.tag==221356) {
        return CGSizeMake(_largeCollVw.frame.size.width, _largeCollVw.frame.size.height);

    } else {
        if (selectedIndex==indexPath.row) {
            return CGSizeMake(_smallCollVw.frame.size.height+10, _smallCollVw.frame.size.height);
            
        } else {
            return CGSizeMake(_smallCollVw.frame.size.height-10, _smallCollVw.frame.size.height-20);
        }
        
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag!=221356) {
        
        selectedIndex=indexPath.row;
        [_smallCollVw reloadData];
        [_largeCollVw scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag==221356) {
        
        selectedIndex = _largeCollVw.contentOffset.x / _largeCollVw.frame.size.width;
        [_smallCollVw reloadData];
        
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag!=221356) {
        
        CGFloat totalCellWidth = (_smallCollVw.frame.size.height-10) * imagesArr.count;
        CGFloat totalSpacingWidth = 0*(imagesArr.count - 1);
        CGFloat leftInset = (_smallCollVw.frame.size.width - (totalCellWidth + totalSpacingWidth)) / 2;
        CGFloat rightInset = leftInset;
        UIEdgeInsets sectionInset = UIEdgeInsetsMake(0, leftInset, 0, rightInset);
        return sectionInset;
    } else {
        return UIEdgeInsetsZero;
    }
}

@end

@interface ContactUsVC ()<MFMailComposeViewControllerDelegate>
{
//    NSString *
    MFMailComposeViewController *mailTo;
}
@end

@implementation ContactUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=AMLocalizedString(@"contact_us", @"contact_us");
    
    _fillFormLabel.text=AMLocalizedString(@"fill_form_contact", @"fill_form_contact");
    _emailTF.text=@"query@livestoc.com";
    _mobileNumberTF.placeholder=AMLocalizedString(@"mobile_no", @"mobile_no");
    _fullNameTf.placeholder=AMLocalizedString(@"full_name", @"full_name");
    _descriptionTextVw.placeHolder=AMLocalizedString(@"message", @"message");
    [_sendMailBtn setTitle:AMLocalizedString(@"send_email", @"send_email") forState:UIControlStateNormal];
    _orLabel.text=AMLocalizedString(@"or", @"or");
    _tollFreeLbl.text=AMLocalizedString(@"tollfree", @"tollfree");
    [_callToNumberBtn setTitle:@"1800 121 6191" forState:UIControlStateNormal];
    
}
- (IBAction)onTapSendMail:(UIButton *)sender {

    NSString *errorMessage;
    
    if ([_fullNameTf hasText]) {
        if ([_emailTF hasText] && [self isValidEmail:_emailTF.text] ) {
            if ([_mobileNumberTF hasText]) {
                if ([_descriptionTextVw hasText]) {
                    mailTo=[[MFMailComposeViewController alloc] init];
                    mailTo.mailComposeDelegate=self;
                    [mailTo setSubject:[NSString stringWithFormat:@"%@(%@)",_fullNameTf.text,_mobileNumberTF.text]];
                    [mailTo setMessageBody:_descriptionTextVw.text isHTML:false];
                    [mailTo setToRecipients:@[_emailTF.text]];
                    [self presentViewController:mailTo animated:YES completion:nil];
                } else {
                    errorMessage=[NSString stringWithFormat:@"%@ %@",AMLocalizedString(@"please_enter", @""),AMLocalizedString(@"", @"")];
                }
            } else {
                errorMessage=[NSString stringWithFormat:@"%@ %@",AMLocalizedString(@"please_enter", @""),AMLocalizedString(@"MOBILE_NO", @"")];
            }
        } else{
            errorMessage=[NSString stringWithFormat:@"%@ %@",AMLocalizedString(@"please_enter", @""),AMLocalizedString(@"enter_email_error", @"")];
        }
    } else {
        errorMessage=[NSString stringWithFormat:@"%@ %@",AMLocalizedString(@"please_enter", @""),AMLocalizedString(@"FULL_NAME", @"")];
    }
    if (errorMessage.length>0) {
        
        [UKNetworkManager showAlertWithTitle:errorMessage messageTitle:nil okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];
    }
}
- (BOOL) isValidEmail: (NSString *) candidate {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}
- (IBAction)onTapCallToBtn:(UIButton *)sender {
    
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"telprompt://18001216191"];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
    
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case MFMailComposeResultFailed:
            [self dismissViewControllerAnimated:YES completion:nil];

            break;
        default:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
    }
}

@end

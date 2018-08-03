//
//  CertificationVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 1/29/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import "CertificationVC.h"

@interface CertificationVC ()<UITextViewDelegate,MFMailComposeViewControllerDelegate>
{
    NSString *attribStr,*mailStr;
    MFMailComposeViewController *mailTo;

}
@end

@implementation CertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];

    _titleLabel.text=AMLocalizedString(@"certification", @"certification");
    _infoLabel.text=AMLocalizedString(@"certification_text_one", @"certification_text_one");
    _sellerBenefitLbl.text=AMLocalizedString(@"certification_text_two", @"certification_text_two");
    _anwSellerBenefitLbl.text=AMLocalizedString(@"certification_text_three", @"certification_text_three");
    _processLbl.text=AMLocalizedString(@"certification_text_four", @"certification_text_four");
    _anwProcessLbl.text=AMLocalizedString(@"certification_text_five", @"certification_text_five");
    _buyerBenftLbl.text=AMLocalizedString(@"certification_text_six", @"certification_text_six");
    _anwBenftLbl.text=AMLocalizedString(@"certification_text_seven", @"certification_text_seven");
    _eightLabel.text=AMLocalizedString(@"certification_text_eight", @"certification_text_eight");
    _nineLabel.text=AMLocalizedString(@"certification_text_nine", @"certification_text_nine");
    
    
    attribStr=AMLocalizedString(@"certification_text_ten", @"certification_text_ten");
    
    mailStr=@"certifications@livestoc.com";
    
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc] initWithString:attribStr attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]}];
    
    NSDictionary *linkAttributes = @{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)};
    
    NSRange range=[[str mutableString] rangeOfString:mailStr];
    [str addAttribute:NSLinkAttributeName value:mailStr range:range];
    [str addAttributes:linkAttributes range:range];
    
    NSRange callRange=[[str mutableString] rangeOfString:@"18001216191"];
    [str addAttribute:NSLinkAttributeName value:@"18001216191" range:callRange];
    [str addAttributes:linkAttributes range:callRange];
    
    _mailTextView.attributedText=str;
    _mailTextView.delegate=self;
    
}


- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    
    if ([URL.absoluteString isEqualToString:mailStr]) {
        
        NSLog(@"%@",mailStr);
        mailTo=[[MFMailComposeViewController alloc] init];
        mailTo.mailComposeDelegate=self;
        //        [mailTo setSubject:[NSString stringWithFormat:@"%@(%@)",_fullNameTf.text,_mobileNumberTF.text]];
        //        [mailTo setMessageBody:_descriptionTextVw.text isHTML:false];
        [mailTo setToRecipients:@[mailStr]];
        [self presentViewController:mailTo animated:YES completion:nil];
        
    }
    if ([URL.absoluteString isEqualToString:@"18001216191"]) {
        
        NSLog(@"18001216191");
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *URL = [NSURL URLWithString:@"telprompt://18001216191"];
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Opened url");
            }
        }];
    }
    
    return YES;
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

- (IBAction)onTapClose:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

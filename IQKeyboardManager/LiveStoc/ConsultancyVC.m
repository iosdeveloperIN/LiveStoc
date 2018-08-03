//
//  ConsultancyVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 1/29/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import "ConsultancyVC.h"

@interface ConsultancyVC ()<UITextViewDelegate>
{
    NSString *attribStr,*mailStr;

}
@end

@implementation ConsultancyVC

- (void)viewDidLoad {
    [super viewDidLoad];

    _titleLabel.text=AMLocalizedString(@"consultancy_title", @"consultancy_title");
    _infoLabel.text=AMLocalizedString(@"consultancy_text", @"consultancy_text");
    _finalLabl.text=AMLocalizedString(@"consultancy_notice", @"consultancy_notice");
    _oneLabel.text=AMLocalizedString(@"consultancy_title_two", @"consultancy_title_two");
    _twoLabel.text=AMLocalizedString(@"consultancy_text_two", @"consultancy_text_two");
    [_buybtn setTitle:AMLocalizedString(@"buy", @"buy") forState:UIControlStateNormal];

    attribStr=AMLocalizedString(@"consultancy_notice_two", @"consultancy_notice_two");

    mailStr=@"futurefarm@livestoc.com";
    
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
        
    }
    if ([URL.absoluteString isEqualToString:@"18001216191"]) {
        
        NSLog(@"18001216191");
        
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)onTapCloseBarBtn:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)onTapBuyBtn:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end









@interface AllInfoVC ()<UITextViewDelegate,MFMailComposeViewControllerDelegate>
{
    NSString *attribStr,*mailStr;
    MFMailComposeViewController *mailTo;

}
@end

@implementation AllInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    
    switch ([[UKModel model] homeInfo]) {
            
        case ChampBulls:
            
            _titleLabel.text=AMLocalizedString(@"champion_title", @"champion_title");
            _oneLabel.text=AMLocalizedString(@"champion_text", @"champion_text");
            _twoLabel.text=@"";
            _threeLabel.text=@"";
            attribStr=AMLocalizedString(@"champion_notice", @"champion_notice");
            mailStr=@"bulls@livestoc.com";
            break;
            
        case Semen:

            _titleLabel.text=AMLocalizedString(@"semen_title", @"semen_title");
            _oneLabel.text=AMLocalizedString(@"semen_text", @"semen_text");
            _twoLabel.text=@"";
            _threeLabel.text=@"";
            attribStr=AMLocalizedString(@"semen_notice", @"semen_notice");
            mailStr=@"semen@livestoc.com";

            break;
            
        case Doctor:

            _titleLabel.text=AMLocalizedString(@"doctor_title", @"doctor_title");
            _oneLabel.text=AMLocalizedString(@"doctor_text", @"doctor_text");
            _twoLabel.text=@"";
            _threeLabel.text=@"";
            attribStr=AMLocalizedString(@"doctor_notice", @"doctor_notice");
            mailStr=@"hr@livestoc.com";

            break;
            
        case Advedrtise:
            
            _titleLabel.text=AMLocalizedString(@"advertise_title", @"advertise_title");
            _oneLabel.text=AMLocalizedString(@"advertise_text", @"advertise_text");
            _twoLabel.text=@"";
            _threeLabel.text=@"";
            attribStr=AMLocalizedString(@"advertise_notice", @"advertise_notice");
            mailStr=@"advertisements@livestoc.com";

            break;
            
        case ListProducts:

            
            _titleLabel.text=AMLocalizedString(@"smart_title", @"smart_title");
            _oneLabel.text=AMLocalizedString(@"smart_text", @"smart_text");
            _twoLabel.text=AMLocalizedString(@"smart_notice", @"smart_notice");
            _threeLabel.text=AMLocalizedString(@"smart_text_two", @"smart_text_two");
            attribStr=AMLocalizedString(@"smart_notice_two", @"smart_notice_two");
            mailStr=@"smartcart@livestoc.com";

            break;
            
        case WorkWithUs:
            
            _titleLabel.text=AMLocalizedString(@"work_title", @"work_title");
            _oneLabel.text=AMLocalizedString(@"work_text", @"work_text");
            _twoLabel.text=AMLocalizedString(@"", @"Work With Us");
            _threeLabel.text=AMLocalizedString(@"work_us_text", @"work_us_text");
            attribStr=AMLocalizedString(@"work_notice", @"work_notice");
            mailStr=@"hr@livestoc.com";

            break;
            
        case Brokers:

            _titleLabel.text=AMLocalizedString(@"broker_title", @"broker_title");
            _oneLabel.text=AMLocalizedString(@"broker_text", @"broker_text");
            _twoLabel.text=AMLocalizedString(@"list_broker_title", @"list_broker_title");
            _threeLabel.text=AMLocalizedString(@"list_broker_text", @"list_broker_text");
            attribStr=AMLocalizedString(@"list_broker_notice", @"list_broker_notice");
            mailStr=@"brokers@livestoc.com";

            break;
            
        case Auction:
            
            
            _titleLabel.text=AMLocalizedString(@"auction_title", @"auction_title");
            _oneLabel.text=AMLocalizedString(@"auction_text", @"auction_text");
            _twoLabel.text=@"";
            _threeLabel.text=@"";
            attribStr=AMLocalizedString(@"auction_notice", @"auction_notice");
            mailStr=@"auctions@livestoc.com";

            break;
            
        case Insurance:
            
            _titleLabel.text=AMLocalizedString(@"insurance_title", @"insurance_title");
            _oneLabel.text=AMLocalizedString(@"insurance_text", @"insurance_text");
            _twoLabel.text=@"";
            _threeLabel.text=@"";
            attribStr=AMLocalizedString(@"insurance_notice", @"insurance_notice");
            mailStr=@"query@livestoc.com";

            break;
            
        default:
            
            _titleLabel.text=AMLocalizedString(@"insurance_title", @"insurance_title");
            _oneLabel.text=AMLocalizedString(@"insurance_text", @"insurance_text");
            _twoLabel.text=@"";
            _threeLabel.text=@"";
            attribStr=AMLocalizedString(@"insurance_notice", @"insurance_notice");
            mailStr=@"query@livestoc.com";

            break;
    }
    
 
    
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

- (IBAction)onTapCloseBarBtn:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end


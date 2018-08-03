//
//  LanguageAndCountryVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 12/20/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "LanguageAndCountryVC.h"

@interface LanguageAndCountryVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *str;
    NSMutableArray *countryDropArr,*langCodesArr,*worldLangArr;
    NSMutableDictionary *langDict;
    
}
@end

@implementation LanguageAndCountryVC
@synthesize isFromOther;

-(void)viewDidAppear:(BOOL)animated{
 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    langCodesArr=[[NSMutableArray alloc] init];
    langDict=[[NSMutableDictionary alloc] init];
    worldLangArr=[[NSMutableArray alloc] init];
    [[UKModel model] setCurrency:[UKNetworkManager getFromDefaultsWithKeyString:@"CURRENCY_CODE"]];
    langDict=@{@"india":@[@"ENGLISH",@"हिंदी",@"ਪੰਜਾਬੀ",@"اردو",@"ગુજરાત",@"தமிழ்",@"मराठी",@"ಕನ್ನಡ",@"বাঙালি",@"മലയാളം",@"తెలుగు"].mutableCopy,@"world":@[@"français",@"Português",@"Español"].mutableCopy}.mutableCopy;
    
    
    langCodesArr=@[@"en",@"hi-IN",@"pa-IN",@"ur",@"gu-IN",@"ta-IN",@"mr-IN",@"kn-IN",@"bn-IN",@"ml-IN",@"te-IN"].mutableCopy;
    worldLangArr=@[@"fr",@"pt-PT",@"es"].mutableCopy;

    
    str=[UKNetworkManager getFromDefaultsWithKeyString:@"CURRENT_LANG"];

//    if ([str isEqualToString:@"pa-IN"]) {
//
//        LocalizationSetLanguage(@"pa-IN");
//
//    } else if ([str isEqualToString:@"hi-IN"]) {
//
//        LocalizationSetLanguage(@"hi-IN");
//
//    } else {
//        LocalizationSetLanguage(@"en");
//        str=@"en";
//    }
    
    [_chooseLangaugeBtn setTitle:AMLocalizedString(@"select_language", @"select_language") forState:UIControlStateNormal];
    [_okBtn setTitle:AMLocalizedString(@"ok", @"ok") forState:UIControlStateNormal];
    if (isFromOther) {
        _bgImgVw.hidden=YES;
    }
    
    [self getCurencies];
    
    _indTblVw.delegate=self;
    _indTblVw.dataSource=self;
    [_indTblVw reloadData];
    
    _worldTblVw.delegate=self;
    _worldTblVw.dataSource=self;
    [_worldTblVw reloadData];
    
    for (NSString *strLang in langCodesArr) {
        
        if ([str isEqualToString:strLang]) {
            
            [_indTblVw scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[langCodesArr indexOfObject:strLang] inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
            break;
            
        }
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==332211) {
        return [langDict[@"india"] count];

    } else {
        return [langDict[@"world"] count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *india=@"cell1";
    static NSString *world=@"cell2";

    if (tableView.tag==332211) {
        UKTableCell *indiaCell=[_indTblVw dequeueReusableCellWithIdentifier:india];
        if (!indiaCell) {
            
            indiaCell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:india];
        }
        
        indiaCell.selectionStyle=UITableViewCellSelectionStyleNone;
        indiaCell.indLbl.text=[NSString stringWithFormat:@"%@",langDict[@"india"][indexPath.row]];
        
        if ([str isEqualToString:langCodesArr[indexPath.row]]) {
            
            LocalizationSetLanguage(str);
            indiaCell.indBackVw.backgroundColor=[UIColor redColor];
            indiaCell.indLbl.textColor=[UIColor whiteColor];
        } else {
            
            indiaCell.indBackVw.backgroundColor=[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
            indiaCell.indLbl.textColor=[UIColor blackColor];
            
        }
        
        return indiaCell;
    } else {
        UKTableCell *worldCell=[_worldTblVw dequeueReusableCellWithIdentifier:world];
        if (!worldCell) {
            
            worldCell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:world];
        }
        
        worldCell.selectionStyle=UITableViewCellSelectionStyleNone;
        worldCell.worldLbl.text=[NSString stringWithFormat:@"%@",langDict[@"world"][indexPath.row]];
        
        if ([str isEqualToString:worldLangArr[indexPath.row]]) {
            
            LocalizationSetLanguage(str);
            worldCell.worldVw.backgroundColor=[UIColor redColor];
            worldCell.worldLbl.textColor=[UIColor whiteColor];
        } else {
            
            worldCell.worldVw.backgroundColor=[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
            worldCell.worldLbl.textColor=[UIColor blackColor];
            
        }
        
        
        return worldCell;
    }
 
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag==332211) {

        LocalizationSetLanguage(langCodesArr[indexPath.row]);
        [UKNetworkManager saveToDefaults:langCodesArr[indexPath.row] withKeyString:@"CURRENT_LANG"];
        
    } else {
        
        LocalizationSetLanguage(worldLangArr[indexPath.row]);
        [UKNetworkManager saveToDefaults:worldLangArr[indexPath.row] withKeyString:@"CURRENT_LANG"];
    }
    
    if (isFromOther) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LANGCHANGED" object:nil];
        
        return;
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"LOGGEDIN"])
    {
        [self performSegueWithIdentifier:@"fromLanguage" sender:self];
        
    } else {
        [self performSegueWithIdentifier:@"presentCountryPopUp" sender:self];
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.view.frame.size.height*0.07;
}

- (IBAction)onTapLanguageBtn:(UKButton *)sender {
    
    
        if (str.length>0) {
            LocalizationSetLanguage(str);
            [UKNetworkManager saveToDefaults:str withKeyString:@"CURRENT_LANG"];

        } else {
            LocalizationSetLanguage(@"en");
            [UKNetworkManager saveToDefaults:@"en" withKeyString:@"CURRENT_LANG"];

        }
    
    if (isFromOther) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LANGCHANGED" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"LOGGEDIN"])
    {
        [self performSegueWithIdentifier:@"fromLanguage" sender:self];

    } else {
        [self performSegueWithIdentifier:@"presentCountryPopUp" sender:self];

    }
    
}
-(void)getCurencies
{
    [UKNetworkManager operationType:POST fromPath:@"selling/currencies" withParameters:nil withUploadData:nil :^(id result) {
        
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            countryDropArr=[[NSMutableArray alloc] init];
            
            countryDropArr=[[result valueForKey:@"data"] valueForKey:@"country"];
            
            [UKNetworkManager saveToDefaults:countryDropArr withKeyString:@"COUNTRIES"];
            
            
        }
    } :^(NSError *error, NSString *errorMessage) {
    
    }];
}
@end















@interface CountryPopVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *countries;
    NSMutableArray *tableArray;
    
}
@end

@implementation CountryPopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    countries=[UKNetworkManager getFromDefaultsWithKeyString:@"COUNTRIES"];
    tableArray=[[NSMutableArray alloc] init];
    tableArray=countries.mutableCopy;
    [_selectCountryBtn setTitle:AMLocalizedString(@"search_country", @"") forState:UIControlStateNormal];
    [_searchTF setPlaceholder:AMLocalizedString(@"search", @"search")];
//    for (NSDictionary *dict in countries) {
//
//        [countryNames addObject:[NSString stringWithFormat:@"%@ - %@",[dict valueForKey:@"country"],[dict valueForKey:@"code"]]];
//
//    }
    _searchTableVw.delegate=self;
    _searchTableVw.dataSource=self;
    [_searchTableVw reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ident=@"countryCell";
    UKTableCell *cell=[_searchTableVw dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.countryNameLabelOfCountrySearchVC.text=[[tableArray objectAtIndex:indexPath.row] valueForKey:@"country"];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UKNetworkManager saveToDefaults:[[tableArray objectAtIndex:indexPath.row] valueForKey:@"mobile_code"] withKeyString:@"COUNTRY_CODE"];
    [UKNetworkManager saveToDefaults:[[tableArray objectAtIndex:indexPath.row] valueForKey:@"code"] withKeyString:@"CURRENCY_CODE"];
    [[UKModel model] setCurrency:[[tableArray objectAtIndex:indexPath.row] valueForKey:@"code"]];
    [_searchTF resignFirstResponder];
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:AMLocalizedString(@"country", nil) message:[NSString stringWithFormat:@"%@ %@",AMLocalizedString(@"country_set", nil),[[tableArray objectAtIndex:indexPath.row] valueForKey:@"country"]] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok=[UIAlertAction actionWithTitle:AMLocalizedString(@"conti_nue", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [self performSegueWithIdentifier:@"fromCountry" sender:self];
        
    }];
//
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)searchTextDidChange:(UKTextField *)sender {
    
    if (sender.text.length != 0) {
        tableArray=[[NSMutableArray alloc] init];
        for ( NSDictionary* item in countries )
        {
            if ([[[item objectForKey:@"country"] lowercaseString] rangeOfString:[sender.text lowercaseString]].location != NSNotFound)
            {
                [tableArray addObject:item];
            }
        }
    }
    else {
        tableArray=countries.mutableCopy;
    }
    
    [_searchTableVw reloadData];
}
@end

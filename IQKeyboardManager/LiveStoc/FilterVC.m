//
//  FilterVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 12/12/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "FilterVC.h"

@interface FilterVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *indexPathArr;
    UKNetworkManager *filterClass;
    UKModel *model;
}
@end

@implementation FilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navItem.title=AMLocalizedString(@"dialog_title_filter", @"dialog_title_filter");
    model=[UKModel model];
    indexPathArr=[[NSMutableArray alloc] init];
    NSLog(@"%@",_filterDetails);
    [_animalImgVw sd_setImageWithURL:_filterDetails[@"background"] placeholderImage:[UIImage imageNamed:@"p"] options:SDWebImageHighPriority];
    
    if (model.animalSelection==Selected) {
    
        NSInteger index=[[model.animalSelectionDict valueForKey:@"radius"] integerValue];
        
        switch (index) {
            case 2:
                [self setSliderBuble:0];

                break;
            case 10:
                [self setSliderBuble:1];

                break;
            case 50:
                [self setSliderBuble:2];

                break;
            case 200:
                [self setSliderBuble:3];

                break;
            case 500:
                [self setSliderBuble:4];

                break;
            case 1000:
                [self setSliderBuble:5];

                break;
            default:
                [self setSliderBuble:6];

                break;
        }
        
        _minTF.text=[model.animalSelectionDict valueForKey:@"min_price"];
        _maxTF.text=[model.animalSelectionDict valueForKey:@"max_price"];
        _minTieldTF.text=[model.animalSelectionDict valueForKey:@"yield"];
        _maxYieldTF.text=[model.animalSelectionDict valueForKey:@"yield_max"];
        
    } else {
        
        _minTF.text=@"10";
        _maxTF.text=@"10000000000";
    }
    
    
    
    if ([_filterDetails[@"beeds"] isKindOfClass:[NSArray class]]) {
        _detailsTblVw.delegate=self;
        _detailsTblVw.dataSource=self;
    }
    
    _nameOfAnimal.text=[_filterDetails valueForKey:@"category"];
    _listingSliderLbl.text=[NSString stringWithFormat:@"%@ %d kms",AMLocalizedString(@"listing_within", @"listing_within"),2];
    _setPriceRangeLabl.text=AMLocalizedString(@"set_price", @"set_price");
    _priceLabel.text=AMLocalizedString(@"price", @"price");
    _minAttriblabel.text=AMLocalizedString(@"min", @"min");
    _maxAttribLabel.text=AMLocalizedString(@"max", @"max");
    _selectBreedLabel.text=AMLocalizedString(@"select_breed", @"select_breed");
    _minTF.placeholder=AMLocalizedString(@"min", @"min");
    _maxTF.placeholder=AMLocalizedString(@"max", @"max");
    _minTieldTF.placeholder=AMLocalizedString(@"min_yield", @"min_yield");
    _maxYieldTF.placeholder=AMLocalizedString(@"max_yield", @"max_yield");
    _yieldLabel.text=AMLocalizedString(@"yield", @"yield");
    [_applyBtn setTitle:AMLocalizedString(@"apply", @"apply") forState:UIControlStateNormal];
    
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (!([[_filterDetails valueForKey:@"category_id"] integerValue] ==1 || [[_filterDetails valueForKey:@"category_id"] integerValue] ==8 || [[_filterDetails valueForKey:@"category_id"] integerValue] ==11 || [[_filterDetails valueForKey:@"category_id"] integerValue] ==10)) {
        
        _yieldVw.hidden=YES;
        _topConstraintOfYieldVw.constant=-_yieldVw.frame.size.height;
    }
    
    _heightOfTableVw.constant=[_filterDetails[@"beeds"] isKindOfClass:[NSArray class]]  ?[_filterDetails[@"beeds"] count]*44:0;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_filterDetails[@"beeds"] count];
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UKTableCell *cell=[_detailsTblVw dequeueReusableCellWithIdentifier:@"detailsCell"];
    if (!cell) {
        cell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailsCell"];
    }
    
    cell.typeLabelOfFilterVC.text=_filterDetails[@"beeds"][indexPath.row][@"breed_name"];
    if ([indexPathArr containsObject:indexPath]) {
        cell.checkedImgVwOfFilterVC.image=[UIImage imageNamed:@"checked"];
    } else {
        cell.checkedImgVwOfFilterVC.image=[UIImage imageNamed:@"blankcheck"];

    }
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPathArr containsObject:indexPath]) {
        
        [indexPathArr removeObject:indexPath];
    
    } else {
        [indexPathArr addObject:indexPath];

    }
    [_detailsTblVw reloadData];
}
- (IBAction)onTapClose:(UIBarButtonItem *)sender {

    UIAlertController *alert=[UIAlertController alertControllerWithTitle:AMLocalizedString(@"discard", @"discard") message:AMLocalizedString(@"discard_confirm", @"discard_confirm") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:AMLocalizedString(@"discard", @"discard") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self dismissViewControllerAnimated:YES completion:nil];

    }];
    UIAlertAction *apply=[UIAlertAction actionWithTitle:AMLocalizedString(@"apply", @"apply") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([_minTF hasText] && [_maxTF hasText]) {
            [self setValuesToAnimalSelectionDict];

        } else {
            [self.view makeToast:AMLocalizedString(@"complete_fields", nil) duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];
        }
    }];
    [alert addAction:cancel];
    [alert addAction:apply];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)setValuesToAnimalSelectionDict
{
    NSMutableString *breedStr=[[NSMutableString alloc] init];
    if (indexPathArr.count>0) {
        for (NSIndexPath *indePath in indexPathArr) {
            [breedStr appendString:[NSString stringWithFormat:@"%ld,",(long)indePath.row+1]];
        }
        breedStr=[breedStr substringToIndex:breedStr.length-1].mutableCopy;
    } else {
        breedStr=@"".mutableCopy;
    }
    
    [model.animalSelectionDict setValue:_minTF.text forKey:@"min_price"];
    [model.animalSelectionDict setValue:_maxTF.text forKey:@"max_price"];
    [model.animalSelectionDict setValue:_minTieldTF.text forKey:@"yield"];
    [model.animalSelectionDict setValue:_maxYieldTF.text forKey:@"yield_max"];
    [model.animalSelectionDict setValue:breedStr forKey:@"breed_id"];
    [model.animalSelectionDict setValue:[_filterDetails valueForKey:@"category_id"] forKey:@"category_id"];
    [model setAnimalSelection:Selected];
    model.pagination=No;
    [model getPosts];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)onDragSlider:(UISlider *)sender {
    
    CGFloat i=sender.value;
    [self setSliderBuble:i];
}

- (IBAction)onTapSlider:(UITapGestureRecognizer *)sender {
    CGPoint  pointTaped = [sender locationInView:_sliderForDistance];

    float new=_sliderForDistance.minimumValue+pointTaped.x/_sliderForDistance.bounds.size.width*(_sliderForDistance.maximumValue-_sliderForDistance.minimumValue);
    CGFloat i=new;
    [self setSliderBuble:i];
}

- (IBAction)didEndDraggingSlider:(UISlider *)sender {
    CGFloat i=sender.value;
    [self setSliderBuble:i];
}

-(void)setSliderBuble:(CGFloat)position
{

    if (position<0.5) {
        
        [_sliderForDistance setValue:0 animated:YES];
        [_twoLabel setTextColor:[UIColor redColor]];
        [model.animalSelectionDict setValue:@"2" forKey:@"radius"];
        _listingSliderLbl.text=[NSString stringWithFormat:@"%@ 2 kms",AMLocalizedString(@"listing_within", @"listing_within")];

        [_tenLbl setTextColor:[UIColor blackColor]];
        [_fiftyLabel setTextColor:[UIColor blackColor]];
        [_twoHundredLbl setTextColor:[UIColor blackColor]];
        [_fiveHundredLabel setTextColor:[UIColor blackColor]];
        [_thousandLabel setTextColor:[UIColor blackColor]];
        [_threeThousandLbl setTextColor:[UIColor blackColor]];
        
    } else if (position>0.5 && position<1.5) {
        [_sliderForDistance setValue:1 animated:YES];
        
        [_twoLabel setTextColor:[UIColor blackColor]];
        [model.animalSelectionDict setValue:@"10" forKey:@"radius"];
        _listingSliderLbl.text=[NSString stringWithFormat:@"%@ 10 kms",AMLocalizedString(@"listing_within", @"listing_within")];

        [_tenLbl setTextColor:[UIColor redColor]];
        [_fiftyLabel setTextColor:[UIColor blackColor]];
        [_twoHundredLbl setTextColor:[UIColor blackColor]];
        [_fiveHundredLabel setTextColor:[UIColor blackColor]];
        [_thousandLabel setTextColor:[UIColor blackColor]];
        [_threeThousandLbl setTextColor:[UIColor blackColor]];
    } else if (position>1.5 && position<2.5) {
        [_sliderForDistance setValue:2 animated:YES];
        [_twoLabel setTextColor:[UIColor blackColor]];
        [model.animalSelectionDict setValue:@"50" forKey:@"radius"];
        _listingSliderLbl.text=[NSString stringWithFormat:@"%@ 50 kms",AMLocalizedString(@"listing_within", @"listing_within")];

        [_tenLbl setTextColor:[UIColor blackColor]];
        [_fiftyLabel setTextColor:[UIColor redColor]];
        [_twoHundredLbl setTextColor:[UIColor blackColor]];
        [_fiveHundredLabel setTextColor:[UIColor blackColor]];
        [_thousandLabel setTextColor:[UIColor blackColor]];
        [_threeThousandLbl setTextColor:[UIColor blackColor]];
        
    } else if (position>2.5 && position<3.5) {
        [_sliderForDistance setValue:3 animated:YES];
        [_twoLabel setTextColor:[UIColor blackColor]];
        [model.animalSelectionDict setValue:@"200" forKey:@"radius"];
        _listingSliderLbl.text=[NSString stringWithFormat:@"%@ 200kms",AMLocalizedString(@"listing_within", @"listing_within")];

        [_tenLbl setTextColor:[UIColor blackColor]];
        [_fiftyLabel setTextColor:[UIColor blackColor]];
        [_twoHundredLbl setTextColor:[UIColor redColor]];
        [_fiveHundredLabel setTextColor:[UIColor blackColor]];
        [_thousandLabel setTextColor:[UIColor blackColor]];
        [_threeThousandLbl setTextColor:[UIColor blackColor]];
        
    } else if (position>3.5 && position<4.5) {
        [_sliderForDistance setValue:4 animated:YES];
        [_twoLabel setTextColor:[UIColor blackColor]];
        [model.animalSelectionDict setValue:@"500" forKey:@"radius"];
        _listingSliderLbl.text=[NSString stringWithFormat:@"%@ 500kms",AMLocalizedString(@"listing_within", @"listing_within")];

        [_tenLbl setTextColor:[UIColor blackColor]];
        [_fiftyLabel setTextColor:[UIColor blackColor]];
        [_twoHundredLbl setTextColor:[UIColor blackColor]];
        [_fiveHundredLabel setTextColor:[UIColor redColor]];
        [_thousandLabel setTextColor:[UIColor blackColor]];
        [_threeThousandLbl setTextColor:[UIColor blackColor]];
    } else if (position>4.5 && position<5.5) {
        [_sliderForDistance setValue:5 animated:YES];
        [_twoLabel setTextColor:[UIColor blackColor]];
        [model.animalSelectionDict setValue:@"1000" forKey:@"radius"];
        _listingSliderLbl.text=[NSString stringWithFormat:@"%@ 1000 kms",AMLocalizedString(@"listing_within", @"listing_within")];

        [_tenLbl setTextColor:[UIColor blackColor]];
        [_fiftyLabel setTextColor:[UIColor blackColor]];
        [_twoHundredLbl setTextColor:[UIColor blackColor]];
        [_fiveHundredLabel setTextColor:[UIColor blackColor]];
        [_thousandLabel setTextColor:[UIColor redColor]];
        [_threeThousandLbl setTextColor:[UIColor blackColor]];
    } else{
        [_sliderForDistance setValue:6 animated:YES];
        [_twoLabel setTextColor:[UIColor blackColor]];
        [model.animalSelectionDict setValue:@"3000" forKey:@"radius"];
        _listingSliderLbl.text=[NSString stringWithFormat:@"%@ 3000 kms",AMLocalizedString(@"listing_within", @"listing_within")];

        [_tenLbl setTextColor:[UIColor blackColor]];
        [_fiftyLabel setTextColor:[UIColor blackColor]];
        [_twoHundredLbl setTextColor:[UIColor blackColor]];
        [_fiveHundredLabel setTextColor:[UIColor blackColor]];
        [_thousandLabel setTextColor:[UIColor blackColor]];
        [_threeThousandLbl setTextColor:[UIColor redColor]];
    }
}

- (IBAction)onTapApplyBtn:(UIButton *)sender {
//    if ([_minTF hasText] && [_maxTF hasText]) {
        [self setValuesToAnimalSelectionDict];
        
//    } else {
//        [self.view makeToast:AMLocalizedString(@"set_price", nil) duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];
//        
//    }

}

@end

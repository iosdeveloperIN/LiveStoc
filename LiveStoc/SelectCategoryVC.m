//
//  SelectCategoryVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 12/9/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "SelectCategoryVC.h"
#import "EnterLocationVC.h"

@interface SelectCategoryVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *animalCategories;
}
@end

@implementation SelectCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=AMLocalizedString(@"select_category", @"select_category");
    self.typeOfAnimal.text=AMLocalizedString(@"type_of_animal", @"type_of_animal");
    
    [[[UKModel model] sellAnimalDetails] removeAllObjects];
    [[[UKModel model] postImages] removeAllObjects];

    [self getAllCategories];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 12;
    
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UKCollectionCell *item=[self.categoryCollVw dequeueReusableCellWithReuseIdentifier:@"sellCollectionCell" forIndexPath:indexPath];
    
    
    [item.animalImgVwOfSelectCategoryVC sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",animalCategories[indexPath.row][@"logo"]]] placeholderImage:[UIImage imageNamed:@"p"] options:SDWebImageHighPriority];
    
    NSString *langStr=@"";
    NSString *currentLang=[UKNetworkManager getFromDefaultsWithKeyString:@"CURRENT_LANG"];

    
    if ([currentLang isEqualToString:@"es"]) {
        langStr=@"category_spanish";
        
    } else if ([currentLang isEqualToString:@"hi-IN"])
    {
        langStr=@"category_hindi";
        
    }  else if ([currentLang isEqualToString:@"pa-IN"])
    {
        langStr=@"category_punjabi";
        
    }  else if ([currentLang isEqualToString:@"ur"])
    {
        langStr=@"category_urdu";
        
    }  else if ([currentLang isEqualToString:@"gu-IN"])
    {
        langStr=@"category_gujarati";
        
    }  else if ([currentLang isEqualToString:@"ta-IN"])
    {
        langStr=@"category_tamil";
        
    }  else if ([currentLang isEqualToString:@"mr-IN"])
    {
        langStr=@"category_marathi";
        
    } else if ([currentLang isEqualToString:@"kn-IN"])
    {
        langStr=@"category_kannada";
        
    } else if ([currentLang isEqualToString:@"bn-IN"])
    {
        langStr=@"category_bengali";
        
    }  else if ([currentLang isEqualToString:@"ml-IN"])
    {
        langStr=@"category_malayalam";
        
    }  else if ([currentLang isEqualToString:@"te-IN"])
    {
        langStr=@"category_telugu";
        
    }  else if ([currentLang isEqualToString:@"fr"])
    {
        langStr=@"category_french";
        
    }  else if ([currentLang isEqualToString:@"pt-PT"])
    {
        langStr=@"category_portuguese";
        
    } else {
        langStr=@"category";
        
    }
    
    if ([currentLang isEqualToString:@"en"]) {
        
        item.animalNameOfSelectCategoryVC.text=animalCategories[indexPath.row][langStr];
        
    } else {
        
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:animalCategories[indexPath.row][langStr] options:0];
        item.animalNameOfSelectCategoryVC.text = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    }
    
    return item;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((self.categoryCollVw.frame.size.width)/2, (self.categoryCollVw.frame.size.width/2)/2);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [[[UKModel model] sellAnimalDetails] setValue:animalCategories[indexPath.row][@"category_id"] forKey:@"category_id"];
    [[UKModel model] setSelectedCategory:[animalCategories[indexPath.row] mutableCopy]];
    //[self performSegueWithIdentifier:@"toEnterLocation" sender:self];
    NSLog(@"%@",self.navigationController);
    UIStoryboard *sellStoryBoard= [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    EnterLocationVC *lEnterLocationVC=[sellStoryBoard instantiateViewControllerWithIdentifier:@"EnterLocationVC"];
    
    [self.navigationController presentViewController:lEnterLocationVC animated:YES completion:nil];
    
}

-(void)getAllCategories
{
    [UKNetworkManager operationType:POST fromPath:@"category/?" withParameters:@{@"limit":@"1000",@"page":@"1"}.mutableCopy withUploadData:nil :^(id result) {
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            animalCategories=[[NSMutableArray alloc] init];
            animalCategories=[[result valueForKey:@"data"] valueForKey:@"category"];
            
            _categoryCollVw.delegate=self;
            _categoryCollVw.dataSource=self;
            [_categoryCollVw reloadData];
            
        } else {
            
        }
        
    } :^(NSError *error, NSString *errorMessage) {
        
    }];
}

- (IBAction)onTapBackButton:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}

@end

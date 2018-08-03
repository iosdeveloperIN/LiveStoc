//
//  TabBarControllerClass.m
//  LiveStoc
//
//  Created by Harjit Singh on 11/24/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "TabBarControllerClass.h"

@interface TabBarControllerClass ()

@end

@implementation TabBarControllerClass

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=YES;

    
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%lujksdhfk%@",(unsigned long)self.selectedIndex,self.selectedViewController);
    if (self.selectedIndex==2) {
        
        self.navigationController.navigationBarHidden=YES;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end

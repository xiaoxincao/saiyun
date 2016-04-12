//
//  GuideViewController.m
//  SaiyunVideo
//
//  Created by cying on 16/4/9.
//  Copyright © 2016年 cying. All rights reserved.
//

#import "GuideViewController.h"
#import "KSGuideManager.h"
@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *paths = [NSMutableArray new];
    
    [paths addObject:[[NSBundle mainBundle] pathForResource:@"app01" ofType:@"jpg"]];
    [paths addObject:[[NSBundle mainBundle] pathForResource:@"app02" ofType:@"jpg"]];

    [[KSGuideManager shared] showGuideViewWithImages:paths];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

//
//  OpinionViewController.m
//  CloudPlatform
//
//  Created by cying on 15/8/13.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import "OpinionViewController.h"
#import <QuartzCore/QuartzCore.h>


#import "DownMenu.h"

@interface OpinionViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong)DownMenu *downmenu;
@end

@implementation OpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_Opiniontextview becomeFirstResponder];
//    __weak typeof(self) weakSelf = self;
//    self.downmenu = [[DownMenu alloc]initWithDownTitleArray:@[ @"功能建议",@"界面建议",@"操作建议",@"其他建议"]];
//    _downmenu.selectedItemBlock = ^(NSInteger index ,NSString *title){
//        [weakSelf.OpinionBtn setTitle:title forState:UIControlStateNormal];
//    };
//    [_OpinionBtn setTitle:@"功能建议" forState:UIControlStateNormal];
    
    [self initgesture];
}

//添加手势
- (void)initgesture{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (![_Opiniontextview isFirstResponder]) {
        return NO;
    }
    return YES;
}
//隐藏键盘
- (void)hidenKeyboard
{
    [_Opiniontextview resignFirstResponder];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//显示下拉菜单按钮
- (IBAction)OpinionActBtn:(id)sender {
    self.downmenu.isHidden = !self.downmenu.isHidden;
}

- (IBAction)CommitOpinion:(id)sender {
    [[Tool SharedInstance]showtoast:@"提交意见成功"];
}




@end

//
//  TestResultViewController.h
//  SaiyunVideo
//
//  Created by cying on 16/1/23.
//  Copyright © 2016年 cying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestResultViewController : UIViewController

@property (nonatomic, copy)NSString *courwareid;

@property (nonatomic, copy)NSString *courseid;

@property (nonatomic, copy)NSString *ispassteststr;
@property (weak, nonatomic) IBOutlet UILabel *Texttipslab;

@property (weak, nonatomic) IBOutlet UITableView *Testresulttableview;
@property (weak, nonatomic) IBOutlet UIButton *NextBtnpro;

@property (weak, nonatomic) IBOutlet UIButton *AgainBtnpro;
- (IBAction)NextBtnAct:(id)sender;

- (IBAction)AgainBtnAct:(id)sender;

@end

//
//  TestViewController.h
//  SaiyunVideo
//
//  Created by cying on 16/1/20.
//  Copyright © 2016年 cying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *TestTableview;

@property (weak, nonatomic) IBOutlet UIButton *HandAnswerpro;

@property (nonatomic, strong)NSString *courwareid;

@property (nonatomic, strong)NSString *courseid;

- (IBAction)HandAnswerAct:(id)sender;
@end

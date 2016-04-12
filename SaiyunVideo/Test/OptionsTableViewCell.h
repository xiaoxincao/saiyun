//
//  OptionsTableViewCell.h
//  SaiyunVideo
//
//  Created by cying on 16/1/22.
//  Copyright © 2016年 cying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestOptionModel.h"
#import "TestResultModel.h"

@interface OptionsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *optionBtnpro;
@property (weak, nonatomic) IBOutlet UILabel *optionlabel;

@property (nonatomic, strong)TestOptionModel *optionmodel;

@property (nonatomic, strong)TestResultModel *resultmodell;

- (IBAction)optionBtnact:(id)sender;


- (void)setOptionCell:(TestOptionModel *)optionmodel andResult:(TestResultModel *)resultmodel;

- (void)setResltCell:(TestResultModel *)resultmodel andOption:(TestOptionModel *)optionmodel;

@end

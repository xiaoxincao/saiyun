//
//  OptionsTableViewCell.m
//  SaiyunVideo
//
//  Created by cying on 16/1/22.
//  Copyright © 2016年 cying. All rights reserved.
//

#import "OptionsTableViewCell.h"

@implementation OptionsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)optionBtnact:(UIButton *)sender {
    if ((self.resultmodell.optionBtn != sender)){
        self.optionmodel.isChosed = !self.optionmodel.isChosed;
        sender.selected = !sender.selected;
        if ([self.resultmodell.type isEqualToString:@"1"]||[self.resultmodell.type isEqualToString:@"3"]) {
            self.optionmodel.isLast = NO;
            self.resultmodell.optionBtn.selected = NO;
            self.resultmodell.optionBtn = sender;
            self.optionmodel.isLast = self.optionmodel.isChosed;
            
        }
    }
}

- (void)setOptionCell:(TestOptionModel *)optionmodel andResult:(TestResultModel *)resultmodel{
    self.resultmodell = resultmodel;
    self.optionmodel = optionmodel;
    self.optionlabel.text = optionmodel.text;
    self.optionBtnpro.selected = optionmodel.isChosed;
    if ([resultmodel.type isEqualToString:@"1"])
    { //设置button选中和非选中图片；
        [self.optionBtnpro setTitle:@"√" forState:UIControlStateSelected];
        [self.optionBtnpro setTitle:@"○" forState:UIControlStateNormal];
    }
    else if ([resultmodel.type isEqualToString:@"2"])
    { //设置button选中和非选中图片；
        [self.optionBtnpro setTitle:@"×" forState:UIControlStateSelected];
        [self.optionBtnpro setTitle:@"□" forState:UIControlStateNormal];
    }
    else if([resultmodel.type isEqualToString:@"3"])
    { //设置button选中和非选中图片；
        [self.optionBtnpro setTitle:@"√" forState:UIControlStateSelected];
        [self.optionBtnpro setTitle:@"○" forState:UIControlStateNormal];
    }
}

- (void)setResltCell:(TestResultModel *)resultmodel andOption:(TestOptionModel *)optionmodel
{
    self.resultmodell = resultmodel;
    self.optionmodel = optionmodel;
    self.optionlabel.text = optionmodel.text;

    self.optionBtnpro.userInteractionEnabled = NO;
    
    if ([resultmodel.isRight isEqualToString:optionmodel.value]) {
        [self.optionBtnpro setTitle:@"√" forState:UIControlStateNormal];
    }
    if (![resultmodel.isRight isEqualToString:resultmodel.myAns]) {
        if ([resultmodel.myAns isEqualToString:optionmodel.value]) {
            [self.optionBtnpro setTitle:@"×" forState:UIControlStateNormal];
        }
    }
    
}





@end
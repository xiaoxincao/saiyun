//
//  MyTraceTableViewCell.m
//  SaiyunVideo
//
//  Created by cying on 15/12/28.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import "MyTraceTableViewCell.h"

@implementation MyTraceTableViewCell

- (void)awakeFromNib {
    _teacherphoto.layer.cornerRadius = 15;
    _teacherphoto.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setTraceModel:(ValueModel *)valuemodel{
    self.title.text = valuemodel.courseName;
    self.teacherinfo.text = valuemodel.university;
    self.tearchname.text = valuemodel.teacherName;
    NSString *percentstr = [valuemodel.percentComplete stringByAppendingString:@"%"];
    self.percent.text = percentstr;
    NSString *str = valuemodel.imagePath;
    NSMutableString *str1 = [NSMutableString stringWithString:str];
    NSString *str2 = [Port stringByAppendingString:str1];
    [self.photoimage sd_setImageWithURL:[NSURL URLWithString:str2] placeholderImage:[UIImage imageNamed:@"default_horizontalimg@3x.jpg"] ] ;
    
    NSString *str3 = valuemodel.photoPath;
    NSMutableString *str4 = [NSMutableString stringWithString:str3];
    NSString *str5 = [Port stringByAppendingString:str4];
    [self.teacherphoto sd_setImageWithURL:[NSURL URLWithString:str5] placeholderImage:[UIImage imageNamed:@"default.png"]];
}
@end

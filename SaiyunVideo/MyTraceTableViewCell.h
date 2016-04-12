//
//  MyTraceTableViewCell.h
//  SaiyunVideo
//
//  Created by cying on 15/12/28.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ValueModel.h"
@interface MyTraceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoimage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *teacherphoto;
@property (weak, nonatomic) IBOutlet UILabel *teacherinfo;
@property (weak, nonatomic) IBOutlet UILabel *percent;
@property (weak, nonatomic) IBOutlet UILabel *tearchname;



- (void)setTraceModel:(ValueModel *)tracemodel;

@end

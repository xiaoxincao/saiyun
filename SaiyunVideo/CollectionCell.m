//
//  CollectionCell.m
//  SaiyunVideo
//
//  Created by cying on 15/12/15.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import "CollectionCell.h"
#import "CollectionViewController.h"

@implementation CollectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)selectBtnaction:(UIButton *)sender {
    self.collectionmodel.isChosed = !self.collectionmodel.isChosed;
    if (self.collectionmodel.isChosed) {
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"chose2"] forState:UIControlStateNormal];
    }else{
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"chose1@3x"] forState:UIControlStateNormal];
    }

}

- (void)setCollectionModel:(CollectionModel *)collection{
    self.collectionmodel = collection;
    if (self.collectionmodel.isChosed) {
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"chose2"] forState:UIControlStateNormal];
    }else{
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"chose1@3x"] forState:UIControlStateNormal];
    }
    self.totaltime.text = collection.totalTime;
    self.title.text = collection.courseName;
    self.percentlabel.text = collection.percentComplete;
    
    NSString *str = collection.imagePath;
    NSMutableString *str1 = [NSMutableString stringWithString:str];
    //NSRange range = [str rangeOfString:@".."];
    //[str1 replaceCharactersInRange:range withString:@""];
    NSString *str2 = [Port stringByAppendingString:str1];
    [self.bgimage sd_setImageWithURL:[NSURL URLWithString:str2] placeholderImage:[UIImage imageNamed:@"default_horizontalimg@3x.jpg"]] ;
}

@end

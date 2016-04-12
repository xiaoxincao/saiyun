//
//  CollectionCell.h
//  SaiyunVideo
//
//  Created by cying on 15/12/15.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionModel.h"

@protocol CollectionCellDelegate <NSObject>

- (void)choseTerm:(CollectionModel *)model;

@end

@interface CollectionCell : UITableViewCell

@property (assign,nonatomic)id<CollectionCellDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIImageView *bgimage;
@property (strong, nonatomic) IBOutlet UILabel *totaltime;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *percentlabel;
@property (strong, nonatomic)CollectionModel *collectionmodel;


@property (strong, nonatomic) IBOutlet UIButton *selectBtn;

- (IBAction)selectBtnaction:(UIButton *)sender;

- (void)setCollectionModel:(CollectionModel *)collection;

@end

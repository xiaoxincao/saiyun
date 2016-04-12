//
//  CollegeListtableview.h
//  
//
//  Created by cying on 16/1/18.
//
//

#import <Foundation/Foundation.h>

@interface CollegeListtableview : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic,copy)void (^selectedItemBlock)(NSString *id,NSString *selectedTitle);

@end

//
//  CollegeListtableview.m
//  
//
//  Created by cying on 16/1/18.
//
//

#import "CollegeListtableview.h"
#import "ClassifyModel.h"

@implementation CollegeListtableview


- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return self;
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
    
}

#pragma mark -行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;
}

#pragma mark -重用cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor orangeColor];
    ClassifyModel *model = self.dataArray [indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassifyModel *model = self.dataArray [indexPath.row];
    NSString *title = model.name;
    NSString *ccid = model.id;
    self.hidden = !self.hidden;
    if (self.selectedItemBlock) {
        self.selectedItemBlock(ccid,title);
    }
}





@end

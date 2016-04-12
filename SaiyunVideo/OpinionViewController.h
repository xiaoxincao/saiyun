//
//  OpinionViewController.h
//  CloudPlatform
//
//  Created by cying on 15/8/13.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpinionViewController : UIViewController<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *OpinionBtn;
@property (strong, nonatomic) IBOutlet UITextView *Opiniontextview;

- (IBAction)OpinionActBtn:(id)sender;

- (IBAction)CommitOpinion:(id)sender;


@end

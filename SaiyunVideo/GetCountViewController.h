//
//  GetCountViewController.h
//  SaiyunVideo
//
//  Created by cying on 16/4/6.
//  Copyright © 2016年 cying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetCountViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phonetext;
@property (weak, nonatomic) IBOutlet UITextField *Verificationcode;
@property (weak, nonatomic) IBOutlet UITextField *codetext;
@property (weak, nonatomic) IBOutlet UITextField *againcodetext;
- (IBAction)finishBtn:(id)sender;

- (IBAction)getcodeBtn:(id)sender;

@end

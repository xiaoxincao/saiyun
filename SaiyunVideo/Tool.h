//
//  Tool.h
//  CloudPlatform
//
//  Created by cying on 15/9/6.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import <Foundation/Foundation.h>

//定义显示HUD的每个动作，当此东西不需要显示是值设为小于0
typedef enum
{
    HUDShowType_None = 0,
    HUDShowType_RegExistPhone ,
    HUDShowType_RegOrGetPassGetCode,
    HUDShowType_RegOrGetPassAction,
    HUDShowType_GetPassExitPhone,
    HUDShowType_LoginAction,
    HUDShowType_LogoutAction,
    HUDShowType_ChangePassAction,
    HUDShowType_GetEvaOptionAction,
    HUDShowType_EvaAction,
    HUDShowType_PickLocationAction,
    HUDShowType_SaveAddress,
    HUDShowType_DefaultAddress,
    HUDShowType_DeleteAddress
    
}HUDShowType;

@interface Tool : NSObject<UIAlertViewDelegate>


+ (Tool *)SharedInstance;

// toast
- (void)showtoast:(NSString *)toastStr;
- (void)showtoast:(NSString *)toastStr wait:(double)wait;

// progress
- (void)hideprogress;
- (void)showprogress;
- (void)showHUD:(HUDShowType)type;

/**
 *  检测网络连接,当没有网络连接时,将在view上显示 提示重新加载的界面
 *
 *  @param view        view
 *  @param reloadBlock 重新加载界面中,点击重新加载的block
 *
 *  @return 返回是否连接
 */
+ (BOOL)checkConectedWhileFaildShowReloadViewInView:(UIView *)view

                                        reloadBlock:(void (^)())reloadBlock;



/**
 *  弹窗
 *
 *  @param title          弹窗标题
 *  @param message        弹窗信息
 *  @param buttonTitle    取消按钮
 *  @param otherBtnTitles 其他按钮
 */
+ (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message CancelbtnTitle:(NSString *)buttonTitle OtherBtnTitles:(NSString *)otherBtnTitles;

/**
 *  加载数据基类
 *  包括了网络判断
 *  @param url              请求的url
 *  @param completionHandle 取得响应后的block
 */
+ (void)loadDataByGetWithUrl:(NSURL *)url
            completionHandle:(void(^)(id result))completionHandle;

+ (MBProgressHUD *)createHUD;
+ (void)showHUD:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud;
@end

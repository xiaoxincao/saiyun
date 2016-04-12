//
//  UIImage+wiRoundedRectImage.h
//  SaiyunVideo
//
//  Created by cying on 16/2/23.
//  Copyright © 2016年 cying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (wiRoundedRectImage)

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;

@end

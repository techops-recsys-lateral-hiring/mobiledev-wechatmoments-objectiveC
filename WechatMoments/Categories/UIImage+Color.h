//
//  UIImage+Color.h
//  WechatMoments
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

/**
 Create a monochrome picture

 @param color Desired color
 @return Monochrome picture
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

@end

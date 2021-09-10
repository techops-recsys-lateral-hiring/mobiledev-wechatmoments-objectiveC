//
//  UIImageView+Web.h
//  WechatMoments
//

#import <UIKit/UIKit.h>

@interface UIImageView (Web)

/**
 Set network picture

 @param urlString Picture address
 @param placeholderImage Default picture
 */
- (void)jf_setImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage;

@end

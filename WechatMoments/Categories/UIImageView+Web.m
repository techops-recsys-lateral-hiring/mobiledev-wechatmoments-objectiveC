//
//  UIImageView+Web.m
//  WechatMoments
//

#import "UIImageView+Web.h"
#import "WebImageManage.h"

@implementation UIImageView (Web)

- (void)jf_setImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage {
    self.image = placeholderImage;
    [[WebImageManage shareWebImageManage] getImageWithURL:urlString
                                   DownloadCompletedBlock:^(UIImage *image, NSError *error, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                self.image = image;
            }
        });
    }];    
}

@end

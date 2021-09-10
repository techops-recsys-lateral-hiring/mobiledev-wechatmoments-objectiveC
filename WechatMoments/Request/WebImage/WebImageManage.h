//
//  WebImageManage.h
//  WechatMoments
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 Get picture result callback

 @param image image
 @param error error
 @param success Whether the acquisition is successful
 */
typedef void(^DownloadCompletedBlock)(UIImage *image, NSError *error, BOOL success);

@interface WebImageManage : NSObject

+ (WebImageManage *)shareWebImageManage;

/**
 Get network pictures

 @param urlString Picture address
 @param completedBlock Get completed callback
 */
- (void)getImageWithURL:(NSString *)urlString DownloadCompletedBlock:(DownloadCompletedBlock)completedBlock;

@end

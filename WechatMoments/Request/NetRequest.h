//
//  NetRequest.h
//  WechatMoments
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id response);

typedef void(^FailureBlock)(NSError *error);

@interface NetRequest : NSObject

/**
 GET request method

 @param urlString Request server address
 @param successBlock Request success callback
 @param failureBlock Request failed callback
 */
+ (void)RequestGetWithUrl:(NSString *)urlString success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

@end

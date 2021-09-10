//
//  WebImageManage.m
//  WechatMoments
//

#import "WebImageManage.h"
#import "AFImageDownloader.h"

static WebImageManage *webImageManage;

@interface WebImageManage ()

/**
 Get completed callback
 */
@property(nonatomic, strong) NSMutableArray *failUrls;

@end

@implementation WebImageManage

+ (WebImageManage *)shareWebImageManage {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webImageManage = [[WebImageManage alloc] init];
    });
    return webImageManage;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _failUrls = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)getImageWithURL:(NSString *)urlString DownloadCompletedBlock:(DownloadCompletedBlock)completedBlock {

    if ([_failUrls containsObject:urlString]) {
        completedBlock(nil, nil, NO);
        return;
    }

    NSLog(@"Download");
    completedBlock(nil, nil, YES);
}
@end

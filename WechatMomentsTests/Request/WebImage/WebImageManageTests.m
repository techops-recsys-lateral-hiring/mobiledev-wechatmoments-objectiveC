//
//  WebImageManageTests.m
//  WechatMomentsTests
//

#import <XCTest/XCTest.h>
#import "WebImageManage.h"

@interface WebImageManageTests : XCTestCase

@end

@implementation WebImageManageTests

-(void)test_getImageWithURL_imageIsNotNil {
    NSString *url = @"http://img2.findthebest.com/sites/default/files/688/media/images/Mingle_159902_i0.png";
    WebImageManage *webImageManage = [[WebImageManage alloc] init];

    [webImageManage getImageWithURL:url DownloadCompletedBlock:^(UIImage *image, NSError *error, BOOL success) {
        if (success) {
            XCTAssertNotNil(image, @"Image should not be nil");
        }
    }];
}

@end


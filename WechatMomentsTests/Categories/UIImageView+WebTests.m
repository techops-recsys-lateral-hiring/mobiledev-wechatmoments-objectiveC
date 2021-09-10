#import <XCTest/XCTest.h>
#import "UIImageView+Web.h"

@interface UIImageView_WebTests : XCTestCase

@end

@implementation UIImageView_WebTests

-(void)test_setImageWithUrl_imageIsNotNil {
    NSString *url = @"http://img2.findthebest.com/sites/default/files/688/media/images/Mingle_159902_i0.png";
    UIImageView *systemUnderTest = [[UIImageView alloc] init];

    [systemUnderTest jf_setImageWithURL:url placeholderImage:nil];

    XCTAssertNotNil(systemUnderTest.image, @"Image should not be nil");
}

@end

#import <XCTest/XCTest.h>
#import "NSString+MD5.h"

@interface NSString_MD5Tests : XCTestCase

@end

@implementation NSString_MD5Tests

-(void)test_md5String_returnsExpectedString {
    NSString *expectedString = @"8b1a9953c4611296a827abf8c47804d7";
    NSString *systemUnderTest = @"Hello";

    XCTAssertEqual([systemUnderTest md5String], expectedString, @"String should be equals to expected string");
}

@end

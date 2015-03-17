//
//  NSURL+ParameterTests.m
//  NSURL+Parameter
//
//  Created by Takahiro Tsubono on 16/3/15.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSURL+Parameter.h"

@interface NSURL_ParameterTests : XCTestCase
@end

@implementation NSURL_ParameterTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatInitWithStringAndValidParameter {
    NSURL *url = [[NSURL alloc] initWithString:@"http://example.com" parameters:@{@"key" : @"value"}];
    XCTAssertTrue([url.query isEqualToString:@"key=value"]);
}

- (void)testThatInitWithStringAndAParameterWithNullValue {
    NSURL *url = [[NSURL alloc] initWithString:@"http://example.com" parameters:@{@"key" : [NSNull null]}];
    XCTAssertTrue([url.query isEqualToString:@"key="]);
}

- (void)testThatInitWithStringAndAParameterWithNullKey {
    NSURL *url = [[NSURL alloc] initWithString:@"http://example.com" parameters:@{[NSNull null] : @"value"}];
    XCTAssertTrue([url.query isEqualToString:@""]);
}

- (void)testThatInitWithStringAndAParameterWithoutEncode {
    NSURL *url = [[NSURL alloc] initWithString:@"http://example.com" parameters:@{@"key" : @":/?#[]@!$&'()*+,;="}];
    XCTAssertTrue([url.query isEqualToString:@"key=%3A%2F%3F%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D"]);
}

- (void)testThatInitWithStringAndAParameterWithArray {
    NSURL *url = [[NSURL alloc] initWithString:@"http://example.com" parameters:@{@"key" : @[@"value1", @"value2"]}];
    XCTAssertTrue([url.query isEqualToString:@"key%5B%5D=value1&key%5B%5D=value2"]);
}

- (void)testThatInitWithStringAndAParameterWithArrayContainingReservedChar {
    NSURL *url = [[NSURL alloc] initWithString:@"http://example.com" parameters:@{@"key" : @[@":/?#[]@!$&'()*+,;="]}];
    XCTAssertTrue([url.query isEqualToString:@"key%5B%5D=%3A%2F%3F%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D"]);
}

- (void)testThatInitWithStringAndAParameterWithArrayContainingNull {
    NSURL *url = [[NSURL alloc] initWithString:@"http://example.com" parameters:@{@"key" : @[[NSNull null]]}];
    XCTAssertTrue([url.query isEqualToString:@"key%5B%5D="]);
}

- (void)testThatInitWithStringAndAParameterWithSet {
    NSSet *valueSet = [NSSet setWithArray:@[@"value1", @"value2"]];
    NSURL *url = [[NSURL alloc] initWithString:@"http://example.com" parameters:@{@"key" : valueSet}];
    XCTAssertTrue([url.query isEqualToString:@"key%5B%5D=value2&key%5B%5D=value1"] ||
                  [url.query isEqualToString:@"key%5B%5D=value1&key%5B%5D=value2"]);
}

- (void)testThatInitWithStringAndAParameterWithSetContainingReservedChar {
    NSSet *valueSet = [NSSet setWithArray:@[@":/?#[]@!$&'()*+,;="]];
    NSURL *url = [[NSURL alloc] initWithString:@"http://example.com" parameters:@{@"key" : valueSet}];
    XCTAssertTrue([url.query isEqualToString:@"key%5B%5D=%3A%2F%3F%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D"]);
}

- (void)testThatInitWithStringAndAParameterWithSetContainingNull {
    NSSet *valueSet = [NSSet setWithArray:@[[NSNull null]]];
    NSURL *url = [[NSURL alloc] initWithString:@"http://example.com" parameters:@{@"key" : valueSet}];
    XCTAssertTrue([url.query isEqualToString:@"key%5B%5D="]);
}

- (void)testThatInitWithStringAndAParameterWithDictionary {
    NSURL *url = [[NSURL alloc] initWithString:@"http://example.com" parameters:@{@"key" : @{@"inner-key" : @"inner-value"}}];
    XCTAssertTrue([url.query isEqualToString:@"key%5Binner-key%5D=inner-value"]);
}

- (void)testThatInitWithStringAndAParameterWithDictionaryContainingNullValue {
    NSURL *url = [[NSURL alloc] initWithString:@"http://example.com" parameters:@{@"key" : @{@"inner-key" : [NSNull null]}}];
    XCTAssertTrue([url.query isEqualToString:@"key%5Binner-key%5D="]);
}

- (void)testThatInitWithStringAndAParameterWithDictionaryContainingNullKey {
    NSURL *url = [[NSURL alloc] initWithString:@"http://example.com" parameters:@{@"key" : @{[NSNull null] : @"inner-value"}}];
    XCTAssertTrue([url.query isEqualToString:@"key%5B%5D=inner-value"]);
}

@end

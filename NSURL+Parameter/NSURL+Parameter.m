// NSURL+Parameter.h
//
// Copyright (c) 2015 Takahiro Tsubono
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NSURL+Parameter.h"

@interface NSDictionary (QueryString)
- (NSString *)toQueryString;
@end

@implementation NSDictionary (QueryString)

static NSString * const kNonEscapingCharacters = @"";
static NSString * const kEscapingCharacters = @":/?#[]@!$&'()*+,;="; // https://tools.ietf.org/html/rfc3986#section-2.2
static NSInteger const kStringEncoding = NSUTF8StringEncoding;

static NSString *EncodedQueryStringFromString(NSString *string) {
    if (![string isKindOfClass:[NSString class]]) return @"";
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                        (__bridge CFStringRef)string,
                                                                        (__bridge CFStringRef)kNonEscapingCharacters,
                                                                        (__bridge CFStringRef)kEscapingCharacters,
                                                                        CFStringConvertNSStringEncodingToEncoding(kStringEncoding)
                                                                        );
}

static NSString *SerializedQueryStringFromKeyAndValue(NSString *key, id value) {
    NSString *serialized = nil;
    if (![key isKindOfClass:[NSString class]]) {
        serialized = @"";
    } else if ([value isKindOfClass:[NSString class]]) {
        serialized = [NSString stringWithFormat: @"%@=%@",
                      EncodedQueryStringFromString(key),
                      EncodedQueryStringFromString(value)];
    } else if ([value isKindOfClass:[NSArray class]] ||
        [value isKindOfClass:[NSSet class]]) {
        NSMutableArray *encoded = [NSMutableArray array];
        for (id obj in (NSArray *)value) {
            NSString *encodedParameter = [NSString stringWithFormat: @"%@[]=%@",
                                          EncodedQueryStringFromString(key),
                                          EncodedQueryStringFromString(obj)];
            [encoded addObject:encodedParameter];
        }
        serialized = [encoded componentsJoinedByString:@"&"];
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        __block NSMutableArray *encoded = [NSMutableArray array];
        [((NSDictionary *)value) enumerateKeysAndObjectsUsingBlock:^(id keyInValueDic, id obj, BOOL *stop) {
            NSString *encodedParameter = [NSString stringWithFormat: @"%@[%@]=%@",
                                          EncodedQueryStringFromString(key),
                                          EncodedQueryStringFromString(keyInValueDic),
                                          EncodedQueryStringFromString(obj)];
            [encoded addObject:encodedParameter];
        }];
        serialized = [encoded componentsJoinedByString:@"&"];
    } else {
        serialized = [NSString stringWithFormat:@"%@=", key];
    }
    return serialized;
}

- (NSString *)toQueryString {
    __block NSMutableArray *serializedArray = [[NSMutableArray alloc] init];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *serialized = SerializedQueryStringFromKeyAndValue(key, obj);
        if (serialized) {
            [serializedArray addObject:serialized];
        }
    }];
    return [serializedArray componentsJoinedByString:@"&"];
}

@end

@implementation NSURL (Parameter)

- (instancetype)initWithString:(NSString *)URLString parameters:(NSDictionary *)parameters {
    self = [self initWithString:[self _urlStringWithBaseURLString:URLString parameters:parameters]];
    if (!self) return nil;
    return self;
}

+ (instancetype)URLWithString:(NSString *)URLString parameters:(NSDictionary *)parameters {
    return [[self alloc] initWithString:URLString parameters:parameters];
}

#pragma mark -

- (NSString *)_urlStringWithBaseURLString:(NSString *)URLString parameters:(NSDictionary *)parameters {
    NSString *query = [parameters toQueryString];
    return [URLString stringByAppendingFormat:([URLString containsString:@"?"] ? @"&%@" : @"?%@"), query];
}

@end

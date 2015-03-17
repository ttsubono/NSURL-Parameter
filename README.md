NSURL+Parameter
=================

Category to add initializers that takes a url string and a NSDictionary for the query string.

##How To Instal

### Manually
[Download](https://github.com/ttsubono/NSURL-Parameter/archive/master.zip) and add `NSURL+Parameter.h` and `NSURL+Parameter.m` into your project.

### CocoaPods
```objc
platform :ios, '6.0'
pod 'NSURL+Parameter', :git => 'https://github.com/ttsubono/NSURL-Parameter.git'
```

## How To Use

`-initWithString:parameters:`
```objc
// http://example.com?key=value
NSURL *url = [[NSURL alloc] initWithString:@"http://example.com" parameters:@{@"key" : @"value"}];

// http://example.com?key[]=value1&key[]=value2
NSURL *url = [[NSURL alloc] initWithString:@"http://example.com" parameters:@{@"key" : @[@"value1", @"value2"]}];

// http://example.com?key[key1]=value
NSURL *url = [[NSURL alloc] initWithString:@"http://example.com" parameters:@{@"key" : @{@"key1" : @"value"}}];
```

`+URLWithString:parameters:`.
```objc
// http://example.com?key=value
NSURL *url = [NSURL URLWithString:@"http://example.com" parameters:@{@"key" : @"value"}];

// http://example.com?key[]=value1&key[]=value2
NSURL *url = [NSURL URLWithString:@"http://example.com" parameters:@{@"key" : @[@"value1", @"value2"]}];

// http://example.com?key[key1]=value
NSURL *url = [NSURL URLWithString:@"http://example.com" parameters:@{@"key" : @{@"key1" : @"value"}}];
```

## License
MIT lincense. See the LICENSE file for more info.

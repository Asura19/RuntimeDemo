//
//  Cat.m
//  testRuntime
//
//  Created by Phoenix on 2018/2/24.
//  Copyright © 2018年 Phoenix. All rights reserved.
//

#import "Cat.h"
#import <Cocoa/Cocoa.h>

@implementation Cat {
    NSColor *_color;
}

+ (void)mews {
    NSLog(@"+++++喵+++++");
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _color = [NSColor blackColor];
    }
    return self;
}

- (void)mew {
    NSLog(@"-----喵-----");
}

- (void)run {
    NSLog(@"~~run~~");
}

- (NSArray *)method0:(NSArray *)agu0
                agu1:(CGFloat)agu1
                agu2:(NSObject *)agu2
                agu3:(NSString *)agu3
                agu4:(CGRect)agu4 {
    
    NSLog(@"test method");
    return @[];
}

- (void)method0 {
    NSLog(@">>>>>>>>0:%s", __func__);
}
- (void)method1 {
    NSLog(@">>>>>>>>1:%s", __func__);
}
- (void)method2 {
    NSLog(@">>>>>>>>2:%s", __func__);
}
+ (void)catClassMethod {
    NSLog(@"~~cat class method~~");
}
@end

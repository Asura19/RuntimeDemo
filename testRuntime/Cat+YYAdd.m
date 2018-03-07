//
//  Cat+YYAdd.m
//  testRuntime
//
//  Created by Phoenix on 2018/2/24.
//  Copyright © 2018年 Phoenix. All rights reserved.
//

#import "Cat+YYAdd.h"
#import <objc/runtime.h>

@implementation Cat (YYAdd)

- (void)setWeight:(float)weight {
    objc_setAssociatedObject(self, @selector(weight), @(weight), OBJC_ASSOCIATION_ASSIGN);
}

- (float)weight {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)jump {
    NSLog(@"~~Cat jump~~");
}
@end

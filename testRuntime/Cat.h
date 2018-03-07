//
//  Cat.h
//  testRuntime
//
//  Created by Phoenix on 2018/2/24.
//  Copyright © 2018年 Phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Cute
@optional
- (void)isCute;
@end

@protocol Movable
@optional
- (void)run;
@end

@interface Cat : NSObject<Movable>
@property (nonatomic, copy) NSString *name;
- (void)mew;
@end

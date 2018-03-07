//
//  main.m
//  testRuntime
//
//  Created by Phoenix on 2018/2/24.
//  Copyright © 2018年 Phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "Cat.h"
#import "Cat+YYAdd.h"
#import <Cocoa/Cocoa.h>

void classBasic() {
    const char *className = class_getName(Cat.class);
    NSLog(@"%@", [NSString stringWithUTF8String:className]);
    
    Class superClass = class_getSuperclass(Cat.class);
    NSLog(@"%@", superClass);
    
    size_t instanceSizeOfClass = class_getInstanceSize(Cat.class);
    NSLog(@"%zu", instanceSizeOfClass);
    
    Ivar ivar = class_getInstanceVariable(Cat.class, "_color");
    NSLog(@"%@", [NSString stringWithUTF8String:ivar_getName(ivar)]);
    
    objc_property_t prop = class_getProperty(Cat.class, "name");
    NSLog(@"%@", [NSString stringWithUTF8String:property_getName(prop)]);
    
    IMP mewImp = class_getMethodImplementation(Cat.class, @selector(mew));
    mewImp();
    
    unsigned int ivarListCount = 0;
    Ivar *ivars = class_copyIvarList(Cat.class, &ivarListCount);
    for (NSInteger i = 0; i < ivarListCount; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSLog(@"ivarList: %@", [NSString stringWithUTF8String:name]);
    }
    free(ivars);
    
    unsigned int propertyListCount = 0;
    objc_property_t *props = class_copyPropertyList(Cat.class, &propertyListCount);
    for (NSInteger i = 0; i < propertyListCount; i++) {
        objc_property_t property = props[i];
        const char *name = property_getName(property);
        NSLog(@"propertyList: %@", [NSString stringWithUTF8String:name]);
    }
    free(props);
    
    unsigned int methodListCount = 0;
    Method *methods = class_copyMethodList(Cat.class, &methodListCount);
    for (NSInteger i = 0; i < methodListCount; i++) {
        Method method = methods[i];
        SEL name = method_getName(method);
        NSLog(@"methodList: %@", NSStringFromSelector(name));
    }
    free(methods);
    
    unsigned int protocolListCount = 0;
    Protocol * __unsafe_unretained *protocols = class_copyProtocolList(Cat.class, &protocolListCount);
    for (NSInteger i = 0; i < protocolListCount; i++) {
        Protocol *protocal = protocols[i];
        const char *name = protocol_getName(protocal);
        NSLog(@"protocolList: %@", [NSString stringWithUTF8String:name]);
    }
    free(protocols);
    
    Method classMethod = class_getClassMethod(Cat.class, NSSelectorFromString(@"catClassMethod"));
    SEL classMethodName = method_getName(classMethod);
    NSLog(@"clasMethod: %@", NSStringFromSelector(classMethodName));
    IMP classMethodNameIMP = method_getImplementation(classMethod);
    classMethodNameIMP();
    
    Class metaClass = objc_getMetaClass("Cat");
    NSLog(@"meta class: %@", metaClass);
    
    unsigned int metaMethodListCount = 0;
    Method *metaMethods = class_copyMethodList(metaClass, &metaMethodListCount);
    for (NSInteger i = 0; i < metaMethodListCount; i++) {
        Method method = metaMethods[i];
        SEL name = method_getName(method);
        NSLog(@"metaMethodList: %@", NSStringFromSelector(name));
    }
    free(metaMethods);
    
}

void objectBasic() {
    Cat *cat = Cat.new;
    cat.name = @"小麻烦";
    cat.weight = 5.0;
    
    NSLog(@"cat weight: %@", @(cat.weight));
    objc_removeAssociatedObjects(cat);
    NSLog(@"cat weight after remove: %@", @(cat.weight));
    
    Ivar ivar = class_getInstanceVariable(Cat.class, "_color");
    NSLog(@"internal instance old value: %@", object_getIvar(cat, ivar));
    object_setIvar(cat, ivar, [NSColor orangeColor]);
    NSLog(@"internal instance new value: %@", object_getIvar(cat, ivar));
}


NSString *personNameGetter(id classInstance, SEL _cmd) {
    Ivar ivar = class_getInstanceVariable([classInstance class], "_name");
    return object_getIvar(classInstance, ivar);
}

void personNameSetter(id classInstance, SEL _cmd, NSString *newName) {
    Ivar ivar = class_getInstanceVariable([classInstance class], "_name");
    id oldName = object_getIvar(classInstance, ivar);
    if (oldName != newName) object_setIvar(classInstance, ivar, [newName copy]);
}

void createClass() {
    //下面对应的编码值可以在官方文档里面找到
    //编码值     含意
    //c     代表char类型
    //i     代表int类型
    //s     代表short类型
    //l     代表long类型，在64位处理器上也是按照32位处理
    //q     代表long long类型
    //C     代表unsigned char类型
    //I     代表unsigned int类型
    //S     代表unsigned short类型
    //L     代表unsigned long类型
    //Q     代表unsigned long long类型
    //f     代表float类型
    //d     代表double类型
    //B     代表C++中的bool或者C99中的_Bool
    //v     代表void类型
    //*     代表char *类型
    //@     代表对象类型
    //#     代表类对象 (Class)
    //:     代表方法selector (SEL)
    //[array type]     代表array
    //{name=type…}     代表结构体
    //(name=type…)     代表union
    //bnum     A bit field of num bits
    //^type     A pointer to type
    //?     An unknown type (among other things, this code is used for function pointers)
    Class PersonClass = objc_allocateClassPair(NSObject.class, "Person", 0);
    BOOL result = class_addIvar(PersonClass,
                                "_gender",
                                sizeof(NSString *),
                                log2(sizeof(NSString *)),
                                "@");
    
    BOOL result2 = class_addIvar(PersonClass,
                                "_name",
                                sizeof(NSString *),
                                log2(sizeof(NSString *)),
                                "@");
    
    if (result && result2) {
        objc_registerClassPair(PersonClass);
    }
    else {
        objc_disposeClassPair(PersonClass);
    }
    
    // https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
    objc_property_attribute_t type = {"T", "@\"NSString\""};
    objc_property_attribute_t ownership = {"C", ""};
    objc_property_attribute_t nonatomic = {"N", ""};
    objc_property_attribute_t backingIvar = {"V", "_name"};
    objc_property_attribute_t attrs[] = {type, ownership, nonatomic, backingIvar};
    class_addProperty(PersonClass, "name", attrs, 4);
    
    SEL getter = NSSelectorFromString(@"name");
    SEL setter = NSSelectorFromString(@"setName:");
    
    class_addMethod(PersonClass, getter, (IMP)personNameGetter, "@@:"); // or use method_getTypeEncoding for last argument
    class_addMethod(PersonClass, setter, (IMP)personNameSetter, "v@:@");
    

    Ivar ivar = class_getInstanceVariable(PersonClass, "_gender");
    NSLog(@"Person ivar:%@",[NSString stringWithUTF8String:ivar_getName(ivar)]);
    
    objc_property_t prop = class_getProperty(PersonClass, "name");
    NSLog(@"Person property:%@",[NSString stringWithUTF8String:property_getName(prop)]);
    
    
    Method method = class_getInstanceMethod(PersonClass, NSSelectorFromString(@"setName:"));
    NSLog(@"%@", NSStringFromSelector(method_getName(method)));
    
    
    id person = [PersonClass new];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [person performSelector:setter withObject:@"Phoenix"];
    NSLog(@"person name get:%@", [person performSelector:getter withObject:nil]);
#pragma clang diagnostic pop
    
}

void newCatMethod() {
    NSLog(@"~~汪~~");
}

void replaceMethod() {
    class_replaceMethod(Cat.class, @selector(mew), (IMP)newCatMethod, NULL);
    IMP mew = class_getMethodImplementation(Cat.class, @selector(mew));
    mew();
}

void methodBasic() {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    Method method = class_getInstanceMethod(Cat.class, @selector(method0:agu1:agu2:agu3:agu4:));
#pragma clang diagnostic pop
    
    SEL methodName = method_getName(method);
    NSLog(@"%@", NSStringFromSelector(methodName));
    
    IMP methodIMP = method_getImplementation(method);
#pragma unused(methodIMP)
    
    const char *attrs = method_getTypeEncoding(method);
    NSLog(@"%@", [NSString stringWithUTF8String:attrs]);
    
    unsigned int count = method_getNumberOfArguments(method);
    NSLog(@"%u", count);
    
    for (unsigned int i =0 ; i < count; i++) {
        char result[1024] = {};
        method_getArgumentType(method, i, result, 1024);
        NSLog(@"类型是 %s", result);
    }
    
    char returnType[1024] = {};
    method_getReturnType(method, returnType, 1024);
    NSLog(@"return type:%s",returnType);
    
    struct objc_method_description result7 = *method_getDescription(method);
    NSLog(@"description ~%@ ~%@",NSStringFromSelector(result7.name),[NSString stringWithUTF8String:result7.types]);
}

void exchangeMethod() {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    Method result0 = class_getInstanceMethod(Cat.class, @selector(method0));
    Method result1 = class_getInstanceMethod(Cat.class, @selector(method1));
    Method result2 = class_getInstanceMethod(Cat.class, @selector(method2));
    method_setImplementation(result0, method_getImplementation(result1));
    
    method_getImplementation(result0)();
    
    method_exchangeImplementations(result0, result2);
    
    method_getImplementation(result0)();
    method_getImplementation(result2)();
#pragma clang diagnostic pop
    
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        classBasic();
        NSLog(@"\n---------------------\n\n");
        objectBasic();
        NSLog(@"\n---------------------\n\n");
        createClass();
        NSLog(@"\n---------------------\n\n");
        replaceMethod();
        methodBasic();
        exchangeMethod();
    }
    return 0;
}


//
//  HookUtil.m
//  Snip
//
//  Created by isee15 on 2019/5/7.
//  Copyright © 2019 isee15. All rights reserved.
//

#import "HookUtil.h"

#import <objc/runtime.h>
#import <objc/message.h>

#define SwizzleSelector(clazz, selector, newImplementation, pPreviousImplementation) \
(*pPreviousImplementation) = (__typeof((*pPreviousImplementation)))class_swizzleSelector((clazz), (selector), (IMP)(newImplementation))

#define SwizzleClassSelector(clazz, selector, newImplementation, pPreviousImplementation) \
(*pPreviousImplementation) = (__typeof((*pPreviousImplementation)))class_swizzleClassSelector((clazz), (selector), (IMP)(newImplementation))

#define SwizzleSelectorWithBlock_Begin(clazz, selector) { \
SEL _cmd = selector; \
__block IMP _imp = class_swizzleSelectorWithBlock((clazz), (selector),
#define SwizzleSelectorWithBlock_End );}

#define SwizzleClassSelectorWithBlock_Begin(clazz, selector) { \
SEL _cmd = selector; \
__block IMP _imp = class_swizzleClassSelectorWithBlock((clazz), (selector),
#define SwizzleClassSelectorWithBlock_End );}

IMP class_swizzleSelector(Class clazz, SEL selector, IMP newImplementation)
{
    // If the method does not exist for this class, do nothing
    Method method = class_getInstanceMethod(clazz, selector);
    if (! method) {
        // Cannot swizzle methods which are not implemented by the class or one of its parents
        return NULL;
    }

    // Make sure the class implements the method. If this is not the case, inject an implementation, only calling 'super'
    const char *types = method_getTypeEncoding(method);

#if !defined(__arm64__)
    NSUInteger returnSize = 0;
    NSGetSizeAndAlignment(types, &returnSize, NULL);

    // Large structs on 32-bit architectures
    if (sizeof(void *) == 4 && types[0] == _C_STRUCT_B && returnSize != 1 && returnSize != 2 && returnSize != 4 && returnSize != 8) {
        class_addMethod(clazz, selector, imp_implementationWithBlock(^(__unsafe_unretained id self, va_list argp) {
            struct objc_super super = {
                .receiver = self,
                .super_class = class_getSuperclass(clazz)
            };

            // Sufficiently large struct
            typedef struct LargeStruct_ {
                char dummy[16];
            } LargeStruct;

            // Cast the call to objc_msgSendSuper_stret appropriately
            LargeStruct (*objc_msgSendSuper_stret_typed)(struct objc_super *, SEL, va_list) = (void *)&objc_msgSendSuper_stret;
            return objc_msgSendSuper_stret_typed(&super, selector, argp);
        }), types);
    }
    // All other cases
    else {
#endif
        class_addMethod(clazz, selector, imp_implementationWithBlock(^(__unsafe_unretained id self, va_list argp) {
            struct objc_super super = {
                .receiver = self,
                .super_class = class_getSuperclass(clazz)
            };

            // Cast the call to objc_msgSendSuper appropriately
            id (*objc_msgSendSuper_typed)(struct objc_super *, SEL, va_list) = (void *)&objc_msgSendSuper;
            return objc_msgSendSuper_typed(&super, selector, argp);
        }), types);
#if !defined(__arm64__)
    }
#endif

    // Swizzling
    return class_replaceMethod(clazz, selector, newImplementation, types);
}

IMP class_swizzleClassSelector(Class clazz, SEL selector, IMP newImplementation)
{
    return class_swizzleSelector(object_getClass(clazz), selector, newImplementation);
}

IMP class_swizzleSelectorWithBlock(Class clazz, SEL selector, id newImplementationBlock)
{
    IMP newImplementation = imp_implementationWithBlock(newImplementationBlock);
    return class_swizzleSelector(clazz, selector, newImplementation);
}

IMP class_swizzleClassSelectorWithBlock(Class clazz, SEL selector, id newImplementationBlock)
{
    IMP newImplementation = imp_implementationWithBlock(newImplementationBlock);
    return class_swizzleClassSelector(clazz, selector, newImplementation);
}

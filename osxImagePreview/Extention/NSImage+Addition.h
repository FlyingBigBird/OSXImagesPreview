//
//  NSImage+Addition.h
//  osxImagePreview
//
//  Created by BaoBaoDaRen on 2019/8/16.
//  Copyright © 2019 Boris. All rights reserved.
//
typedef NS_ENUM(NSUInteger, SaveImageType) {
    
    NSPNGImageType,
    NSJPGImageType,
};
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSImage (Helper)

+ (BOOL)saveImage:(NSImage *)img withName:(NSString *)imgName imgType:(SaveImageType)type;

+ (NSImage *)resizeImage:(NSImage *)sourceImage forSize:(NSSize)size;


@end

NS_ASSUME_NONNULL_END

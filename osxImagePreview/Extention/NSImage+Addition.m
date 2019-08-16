//
//  NSImage+Addition.m
//  osxImagePreview
//
//  Created by BaoBaoDaRen on 2019/8/16.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "NSImage+Addition.h"

@implementation NSImage (Helper)

+ (BOOL)saveImage:(NSImage *)img withName:(NSString *)imgName imgType:(SaveImageType)type
{
    if (!img) {
        return NO;
    }
    
    // 选择文件路径...
    NSString *filePath = [NSString getFilePath:imgName];
    if (filePath.length <= 0) {
        
        return NO;
    }
    
    NSData *imgData = [img TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imgData];

    NSNumber *objectType = [NSNumber numberWithFloat:.85]; // 压缩率
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:objectType forKey:NSImageCompressionFactor];

    if ([imgName.pathExtension containsString:@"jpg"] || [imgName.pathExtension containsString:@"jpeg"]) {

        // 压缩jpg...
        imgData = [imageRep representationUsingType:NSJPEGFileType properties:imageProps];

        if (!([imgName containsString:@".jpg"] || [imgName containsString:@".jpeg"])) {
            
            imgName = [NSString stringWithFormat:@"%@.jpg",imgName];
        }
    } else {
        // 压缩png...
        imgData = [imageRep representationUsingType:NSPNGFileType properties:imageProps];
        if (!([imgName containsString:@".png"] || [imgName containsString:@".png"])) {
            
            imgName = [NSString stringWithFormat:@"%@.png",imgName];
        }
    }
    filePath = [NSString stringWithFormat:@"%@/%@",filePath,imgName];
    NSLog(@"path:%@ \n dataLenght:【%lu】KB\n",filePath,(unsigned long)imgData.length/1000);
    
    
    NSError *error = nil ;
    BOOL isSaved = [imgData writeToFile:filePath options:NSDataWritingAtomic error:&error];
    NSLog(@"error:%@:",error);

    return isSaved;
    
}

+ (NSImage *)resizeImage:(NSImage*)sourceImage forSize:(NSSize)size {
    
    NSRect targetFrame = NSMakeRect(0, 0, size.width, size.height);
    
    NSImageRep *sourceImageRep = [sourceImage bestRepresentationForRect:targetFrame context:nil hints:nil];
    
    NSImage *targetImage = [[NSImage alloc] initWithSize:size];
    
    [targetImage lockFocus];
    [sourceImageRep drawInRect: targetFrame];
    [targetImage unlockFocus];
    
    return targetImage;
}

@end

//
//  ScrlDocumentView.h
//  osxImagePreview
//
//  Created by BaoBaoDaRen on 2019/8/16.
//  Copyright © 2019 Boris. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScrlDocumentView : NSView

@property (nonatomic, strong) NSImageView *imgView;


- (void) updateImage:(NSImage *)img;

- (void) serverImageUrl:(NSString *)url;


@end

NS_ASSUME_NONNULL_END

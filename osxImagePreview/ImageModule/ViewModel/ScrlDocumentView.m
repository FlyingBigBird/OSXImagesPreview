//
//  ScrlDocumentView.m
//  osxImagePreview
//
//  Created by BaoBaoDaRen on 2019/8/16.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "ScrlDocumentView.h"

@implementation ScrlDocumentView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        
        [self showUI];
    }
    return self;
}

- (void)showUI
{
    self.imgView = [[NSImageView alloc] init];
    [self addSubview:self.imgView];
    [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(self);
    }];
  
}
- (void)updateImage:(NSImage *)img
{
    self.imgView.image = img;
    
    CGFloat imgWidth = img.size.width;
    CGFloat imgHeight = img.size.height;
    if (imgWidth < self.superview.frame.size.width) {
        
        imgWidth = self.superview.frame.size.width;
    }
    if (imgHeight < self.superview.frame.size.height) {
        
        imgHeight = self.superview.frame.size.height;
    }
    self.frame = CGRectMake(self.superview.frame.size.width/2 - self.frame.size.width/2, self.superview.frame.size.height/2 - self.frame.size.height/2, imgWidth, imgHeight);
    self.imgView.frame = CGRectMake(self.frame.size.width/2 - img.size.width/2, self.frame.size.height/2 - img.size.height/2, img.size.width, img.size.height);
    
}
- (void) serverImageUrl:(NSString *)url
{
    // SD_WebImage获取image后，调用updateImage:方法...
}

@end

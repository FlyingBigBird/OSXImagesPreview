//
//  RootWindowController.m
//  osxImagePreview
//
//  Created by BaoBaoDaRen on 2019/8/16.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "RootWindowController.h"
#import "ScrlDocumentView.h"
#import "Snip/CScreenshot.h"
#import "MQUI/MQSCCaptureWindowManager.h"
#import "HookUtil.h"
#import "JTHeader.h"

@interface RootWindowController ()
{
    CGFloat maxScale;
    CGFloat minScale;
    CGFloat zoomScale;
    NSInteger rotateAngle;
}
@property (weak) IBOutlet NSScrollView *scrollView;
@property (nonatomic, strong) ScrlDocumentView *docView;
@property (nonatomic, strong) NSImage *currentImg;

@end

@implementation RootWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    zoomScale = 1;
    maxScale = 2.5;
    minScale = 0.25;
    rotateAngle = 0;
    
    [self windowInit];
    
}
- (void)windowInit;
{
    [self.window center];
    [self.window center];
    [self.window setFrameOrigin:NSMakePoint(self.window.screen.frame.size.width / 2 - self.window.frame.size.width / 2, self.window.screen.frame.size.height / 2 - self.window.frame.size.height / 2)];
    [self.window frame];
    
    self.scrollView.scrollerStyle = NSScrollerStyleOverlay;
    [self.scrollView setHasVerticalScroller:YES];//有垂直滚动条
    [self.scrollView setHasHorizontalRuler:YES];//有垂直滚动条

    self.docView = [[ScrlDocumentView alloc] initWithFrame:self.window.contentView.bounds];
    NSImage *getImg = [NSImage imageNamed:@"laobaoheihei"];
    self.currentImg = getImg;
    [self.docView updateImage:getImg];
    [self.scrollView setDocumentView:self.docView];
    self.scrollView.maxMagnification = maxScale;
    self.scrollView.minMagnification = minScale;
    self.scrollView.magnification = zoomScale;
    self.scrollView.allowsMagnification = YES;
    
    [self screenSnipInit];
}
- (void)screenSnipInit
{
    __weak typeof(self)weakSelf = self;
    SwizzleSelectorWithBlock_Begin([[MQSCCaptureWindowManager sharedInstance] class], @selector(captureFinished:))
    ^(MQSCCaptureWindowManager *oriSelf, NSNotification *noti) {
        ((void (*)(id, SEL,NSNotification *))_imp)(oriSelf, _cmd, noti);
        NSLog(@"finishedCapture：%@",noti);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
            NSArray *classArray = [NSArray arrayWithObject:[NSImage class]];
            NSDictionary *options = [NSDictionary dictionary];
            BOOL ok = [pasteboard canReadObjectForClasses:classArray options:options];
            if (ok) {
                NSArray *objectsToPaste = [pasteboard readObjectsForClasses:classArray options:options];
                NSImage *image = [objectsToPaste objectAtIndex:0];
                NSLog(@"image:%@",image);
                [weakSelf.docView updateImage:image];
            }
        });
    }
    SwizzleSelectorWithBlock_End;
    SwizzleSelectorWithBlock_Begin([[JTCaptureManager sharedInstance] class], @selector(captureDidFinishWithImage:needSave:isHighResolution:))
    ^(JTCaptureManager *oriSelf, id arg1,BOOL arg2,BOOL arg3) {
        ((BOOL (*)(id, SEL,id,BOOL,BOOL))_imp)(oriSelf, _cmd, arg1,arg2,arg3);
        NSLog(@"finishedCapture jt：%@",arg1);
        [weakSelf.docView updateImage:(NSImage *)arg1];

    }
    SwizzleSelectorWithBlock_End;

}


- (IBAction)saveImage:(id)sender {
    
    if (!self.docView.imgView.image) {
        
        return;
    }
    
    // 选择路径...
    BOOL saveSucceed = [NSImage saveImage:[NSImage imageNamed:@"laobaoheihei"] withName:@"imgdemoss" imgType:NSPNGImageType];
    
    if (saveSucceed) {
        
        NSLog(@"保存成功");
    } else {
        NSLog(@"保存失败");
    }
}
- (IBAction)zoomOutImage:(id)sender {
 
    zoomScale -= minScale;
    
    // 缩小...
    if (zoomScale <= minScale) {
        
        zoomScale = minScale;
    } else if (zoomScale >= maxScale) {
        
        zoomScale = maxScale;
    } else {
        
    }
    [self resizeImageWithZoomScale:zoomScale];
}
- (IBAction)zoomInImage:(id)sender {
    
    // 放大...
    zoomScale += minScale;
    
    // 缩小...
    if (zoomScale <= minScale) {
        
        zoomScale = minScale;
    } else if (zoomScale >= maxScale) {
        
        zoomScale = maxScale;
    } else {
        
    }
    [self resizeImageWithZoomScale:zoomScale];
}
- (void)resizeImageWithZoomScale:(CGFloat)zoomScale
{
    CGFloat getWidht = self.currentImg.size.width;
    CGFloat getHeight = self.currentImg.size.height;
    CGFloat resizeWidth = getWidht * zoomScale;
    CGFloat resizeHeight = getHeight * zoomScale;
    NSImage *getImg = [NSImage resizeImage:self.currentImg forSize:CGSizeMake(resizeWidth, resizeHeight)];
    if (getImg) {
        
        [self.docView updateImage:getImg];
    }
    
    [self.scrollView setDocumentView:self.docView];
    [self.scrollView scrollPoint:NSMakePoint(self.scrollView.frame.size.width/2 - getImg.size.width/2, self.scrollView.frame.size.height/2 - getImg.size.height/2)];
}

- (IBAction)imageScreenshoot:(id)sender {
    
    if (![[JTCaptureManager sharedInstance] isCapturing]) {
        [[JTCaptureManager sharedInstance] startCaptureByRequest:nil];
    }
}
- (IBAction)rotateImage:(id)sender {
    
    rotateAngle = 90;

    [self.docView.imgView rotateByAngle:rotateAngle];
    [self resizeImageWithZoomScale:zoomScale];
    
}




@end

//
//  AppDelegate.m
//  osxImagePreview
//
//  Created by BaoBaoDaRen on 2019/8/16.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "AppDelegate.h"
#import "RootWindowController.h"

@interface AppDelegate ()
{
    RootWindowController *rootWVC;
}
@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, strong) RootWindowController *rootWVC;

@end


@implementation AppDelegate

@synthesize rootWVC;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    [self.window center];
    [self.window setFrameOrigin:NSMakePoint(self.window.screen.frame.size.width / 2 - self.window.frame.size.width / 2, self.window.screen.frame.size.height / 2 - self.window.frame.size.height / 2)];
    [self.window frame];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)previewImageStart:(id)sender {
    
    [self.window orderOut:self];
    
    rootWVC = [[RootWindowController alloc] initWithWindowNibName:@"RootWindowController"];
    [rootWVC.window makeKeyAndOrderFront:self];
    [rootWVC.window display];
    
}

@end

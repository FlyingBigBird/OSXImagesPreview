//
//  NSString+Addition.m
//  osxImagePreview
//
//  Created by BaoBaoDaRen on 2019/8/16.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "NSString+Addition.h"

@implementation NSString (Helper)

+ (NSString *) getFilePath:(NSString *)fileName
{
    BOOL isOverlap = NO;
    NSString *filePath = @"";
    
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:YES];// 可选路径...
    [panel setCanChooseFiles:YES];// 可选文件...
    BOOL chooseFinished = (panel.runModal == NSModalResponseOK);
    if (chooseFinished) {
        
        NSString *path = panel.URL.path;

        // 遍历当前文件夹...
        NSString *BASE_PATH = panel.URL.path;
        NSFileManager *myFileManager = [NSFileManager defaultManager];
        NSDirectoryEnumerator *myDirectoryEnumerator = [myFileManager enumeratorAtPath:BASE_PATH];

        BOOL isDir = NO;
        BOOL isExist = NO;
        
        // 遍历文件夹...
        for (NSString *path in myDirectoryEnumerator.allObjects) {
            
            isExist = [myFileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@", BASE_PATH, path] isDirectory:&isDir];
            if (isDir) {
                NSLog(@"路径:%@", path);
            } else {
                NSLog(@"文件:%@", path);
                
                if ([path containsString:fileName]) {
                    
                    // 文件名已存在...
                    NSAlert *alert = [[NSAlert alloc] init];
                    
                    NSString *title = [NSString stringWithFormat:@"%@%@%@已存在。您要替换它吗？",@"“",fileName,@"”"];
                    NSString *message = [NSString stringWithFormat:@"当前文件夹已有相同名称的文件或文件夹。替换它将覆盖其当前内容。"];
                    
                    [alert setMessageText:title];
                    [alert setInformativeText:message];
                    [alert addButtonWithTitle:@"取消"];
                    [alert setAlertStyle:NSAlertStyleWarning];
                    [alert runModal];
                    isOverlap = YES;
                }
            }
        }
    
        if (path) {
            
            filePath = path;
        }
        if (isOverlap == YES) {
            filePath = @"";
        }
    }
    
    return filePath;
}


@end

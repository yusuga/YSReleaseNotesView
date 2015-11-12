//
//  main.m
//  YSReleaseNotesViewExample
//
//  Created by Yu Sugawara on 2015/03/07.
//  Copyright (c) 2015年 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <LumberjackLauncher/LumberjackLauncher.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [LumberjackLauncher launchStandardLoggers];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

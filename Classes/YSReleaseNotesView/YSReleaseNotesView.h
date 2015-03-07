//
//  YSReleaseNotesView.h
//  YSReleaseNotesViewExample
//
//  Created by Yu Sugawara on 2015/03/07.
//  Copyright (c) 2015年 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YSReleaseNotesViewCompletion)(NSError *error);

/**
 Example usage
 
 if (![YSReleaseNotesView isAppOnFirstLaunch] && [YSReleaseNotesView isAppVersionUpdated]) {
     [YSReleaseNotesView showWithAppIdentifier:kAppIdentifier completion:^(NSError *error) {
         NSLog(@"complete, error = %@", error);
     }];
 }
 
 */

@interface YSReleaseNotesView : UIView

+ (void)showWithAppIdentifier:(NSString*)appIdentifier
                   completion:(YSReleaseNotesViewCompletion)completion;

+ (void)showWithReleaseNote:(NSString*)releaseNote
                 completion:(YSReleaseNotesViewCompletion)completion;

+ (BOOL)isAppVersionUpdated;
+ (BOOL)isAppOnFirstLaunch;

@end

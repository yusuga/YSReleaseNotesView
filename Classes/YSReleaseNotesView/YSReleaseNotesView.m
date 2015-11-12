//
//  YSReleaseNotesView.m
//  YSReleaseNotesViewExample
//
//  Created by Yu Sugawara on 2015/03/07.
//  Copyright (c) 2015年 Yu Sugawara. All rights reserved.
//

#import "YSReleaseNotesView.h"
#import <TWSReleaseNotesView/TWSReleaseNotesView.h>
#import <TWSReleaseNotesView/TWSReleaseNotesDownloadOperation.h>
#import <KLCPopup/KLCPopup.h>
#import <LumberjackLauncher/LumberjackLauncher.h>

static CGFloat const kMaxSize = 400.f;
static CGFloat const kSpace = 15.f;

static NSString * const kYSReleaseNotesViewVersionKey = @"kYSReleaseNotesViewVersionKey";


NSString *YSReleaseNotesViewLocalizedString(NSString *key)
{
    return NSLocalizedStringFromTable(key, @"YSReleaseNotesViewLocalizable", nil);
}

NSString *ys_CFBundleShortVersionString()
{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
}

@interface YSReleaseNotesView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) KLCPopup *popup;

@end

@implementation YSReleaseNotesView

+ (void)showWithAppIdentifier:(NSString*)appIdentifier
                   completion:(YSReleaseNotesViewCompletion)completion
{
    // Setup operation queue
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    operationQueue.maxConcurrentOperationCount = 1;
    TWSReleaseNotesDownloadOperation *operation = [[TWSReleaseNotesDownloadOperation alloc] initWithAppIdentifier:appIdentifier];
    
    __weak TWSReleaseNotesDownloadOperation *weakOperation = operation;
    [operation setCompletionBlock:^{
        TWSReleaseNotesDownloadOperation *strongOperation = weakOperation;
        if (strongOperation.error) {
            NSError *error = strongOperation.error;
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                // Perform completion block with error
                DDLogError(@"%s; %@", __func__, error);
                if (completion) completion(error);
            }];
        } else {
            // Get release note text
            NSString *releaseNotesText = strongOperation.releaseNotesText;
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self showWithReleaseNote:releaseNotesText completion:completion];
            }];
        }
    }];
    
    // Add operation
    [operationQueue addOperation:operation];
    
}

+ (void)showWithReleaseNote:(NSString*)releaseNote
                 completion:(YSReleaseNotesViewCompletion)completion
{
    YSReleaseNotesView *releaseNotesView = [[YSReleaseNotesView alloc] initWithReleaseNote:releaseNote];
    
    KLCPopup *popup = [KLCPopup popupWithContentView:releaseNotesView
                                            showType:KLCPopupShowTypeGrowIn
                                         dismissType:KLCPopupDismissTypeGrowOut
                                            maskType:KLCPopupMaskTypeDimmed
                            dismissOnBackgroundTouch:NO
                               dismissOnContentTouch:NO];
    releaseNotesView.popup = popup;
    
    popup.didFinishDismissingCompletion = ^{
        if (completion) completion(nil);
    };
    
    [popup show];
}

#pragma mark -

+ (BOOL)isAppVersionUpdated
{
    // Read stored version string and current version string
    NSString *previousAppVersion = [[NSUserDefaults standardUserDefaults] stringForKey:kYSReleaseNotesViewVersionKey];
    NSString *currentAppVersion = ys_CFBundleShortVersionString();
    
    // Flag app as updated if a previous version string is found and it does not match with the current version string
    BOOL isUpdated = (previousAppVersion && ![previousAppVersion isEqualToString:currentAppVersion]) ? YES : NO;
    
    if (isUpdated || !previousAppVersion)
    {
        // Store current app version if needed
        [self storeCurrentAppVersionString];
    }
    
    return isUpdated;
}

+ (BOOL)isAppOnFirstLaunch
{
    // Read stored version string
    NSString *previousAppVersion = [[NSUserDefaults standardUserDefaults] stringForKey:kYSReleaseNotesViewVersionKey];
    
    // Flag app as on first launch if no previous app string is found
    BOOL isFirstLaunch = (!previousAppVersion) ? YES : NO;
    
    if (isFirstLaunch)
    {
        // Store current app version if needed
        [self storeCurrentAppVersionString];
    }
    
    return isFirstLaunch;
}

+ (void)storeCurrentAppVersionString
{
    // Store current app version string in the user defaults
    NSString *currentAppVersion = ys_CFBundleShortVersionString();
    [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion forKey:kYSReleaseNotesViewVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark Life cycle

- (instancetype)initWithReleaseNote:(NSString*)releaseNote
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    self = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    NSParameterAssert(self);    
    
    /* Text */
    
    self.titleLabel.text = [NSString stringWithFormat:YSReleaseNotesViewLocalizedString(@"Release notes title format"), ys_CFBundleShortVersionString()];
    self.textView.text = releaseNote;
    [self.textView scrollRangeToVisible:NSMakeRange(0, 0)];
    [self.cancelButton setTitle:@"OK"
                       forState:UIControlStateNormal];
    
    /* Frame */
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat minSize = MIN(size.width, size.height) - kSpace*2.f;
    if (minSize > kMaxSize) {
        minSize = kMaxSize;
    }
    CGRect frame = self.frame;
    frame.size = CGSizeMake(minSize, minSize);
    self.frame = frame;
    
    return self;
}

#pragma mark - Button

- (IBAction)cancelButtonDidPush:(id)sender
{
    [self.popup dismissPresentingPopup];
}

@end

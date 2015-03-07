//
//  TableViewController.m
//  YSReleaseNotesViewExample
//
//  Created by Yu Sugawara on 2015/03/07.
//  Copyright (c) 2015年 Yu Sugawara. All rights reserved.
//

#import "TableViewController.h"
#import "YSReleaseNotesView.h"

static NSString * const kAppIdentifier = @"910000043";

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![YSReleaseNotesView isAppOnFirstLaunch] && [YSReleaseNotesView isAppVersionUpdated]) {
        [YSReleaseNotesView showWithAppIdentifier:kAppIdentifier completion:^(NSError *error) {
            NSLog(@"complete, error = %@", error);
        }];
    }
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [YSReleaseNotesView showWithReleaseNote:@"relase note" completion:^(NSError *error) {
                NSLog(@"complete, error = %@", error);
            }];
            break;
        case 1:
        {
            [YSReleaseNotesView showWithAppIdentifier:kAppIdentifier completion:^(NSError *error) {
                NSLog(@"complete, error = %@", error);
            }];
            break;
        }
        default:
            abort();
            break;
    }
}

@end

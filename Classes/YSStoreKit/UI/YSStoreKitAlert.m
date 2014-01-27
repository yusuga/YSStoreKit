//
//  YSStoreKitAlert.m
//  YSStoreKitHelperDevelopment
//
//  Created by Yu Sugawara on 2014/01/08.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "YSStoreKitAlert.h"
#import "YSStoreKitFunction.h"

@implementation YSStoreKitAlert

#pragma mark - Alert

+ (void)showIAPMaskedErrorAlert
{
    [[[UIAlertView alloc] initWithTitle:YSStoreKitLocalizedString(@"Alert IAP masked error Title")
                                message:YSStoreKitLocalizedString(@"Alert IAP masked error Msg")
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

+ (void)showNewtworkErrorAlert
{
    [[[UIAlertView alloc] initWithTitle:YSStoreKitLocalizedString(@"Alert Network error Title")
                                message:YSStoreKitLocalizedString(@"Alert Network error Msg")
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

+ (void)showITunesSearverErrorAlert
{
    [[[UIAlertView alloc] initWithTitle:YSStoreKitLocalizedString(@"Alert iTunesStore error Title")
                                message:YSStoreKitLocalizedString(@"Alert iTunesStore error Msg")
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

+ (void)showIAPErrorAlertWithError:(NSError*)error
{
    [[[UIAlertView alloc] initWithTitle:YSStoreKitLocalizedString(@"Error")
                                message:YSNSStringFromSKError(error)
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end

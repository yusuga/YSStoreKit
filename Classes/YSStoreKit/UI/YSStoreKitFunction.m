//
//  YSStoreKitFunction.m
//  YSStoreKitHelperDevelopment
//
//  Created by Yu Sugawara on 2014/01/08.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

@import StoreKit;

#import "YSStoreKitFunction.h"

NSString *YSStoreKitLocalizedString(NSString *key)
{
    return NSLocalizedStringFromTable(key, @"YSStoreKitLocalizable", nil);
}

NSString *YSNSStringFromSKError(NSError *error)
{
    //※ LocalizedDescriptionは全て「iTunes Storeに接続できません」になっている
    switch (error.code) {
        case SKErrorUnknown:
            return YSStoreKitLocalizedString(@"SKError Unknown");
        case SKErrorClientInvalid:
            return YSStoreKitLocalizedString(@"SKError ClientInvalid");
        case SKErrorPaymentCancelled:
            return YSStoreKitLocalizedString(@"SKError Cancel");
        case SKErrorPaymentInvalid:
            return YSStoreKitLocalizedString(@"SKError PaymentInvalid");
        case SKErrorPaymentNotAllowed:
            return YSStoreKitLocalizedString(@"SKError PaymentNotAllowed");
        default:
            return [NSString stringWithFormat:@"Unknown SKErrorCode; error = %@;", error];
    }
}

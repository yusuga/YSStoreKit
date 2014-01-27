//
//  YSStoreKitAlert.h
//  YSStoreKitHelperDevelopment
//
//  Created by Yu Sugawara on 2014/01/08.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSStoreKitAlert : NSObject

+ (void)showIAPMaskedErrorAlert;
+ (void)showNewtworkErrorAlert;
+ (void)showITunesSearverErrorAlert;
+ (void)showIAPErrorAlertWithError:(NSError*)error;

@end

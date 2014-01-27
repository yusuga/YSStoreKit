//
//  YSStoreKit.h
//  YSStoreKitExample
//
//  Created by Yu Sugawara on 2014/01/08.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^YSStoreKitSubscriptionsPurchased)(NSString *productId);
typedef void(^YSStoreKitSubscriptionsInvalid)(NSString *productId);

@interface YSStoreKit : NSObject

+ (instancetype)sharedManager;

- (void)buyFeature:(NSString*) featureId
        onComplete:(void (^)(NSString* purchasedFeature, NSData*purchasedReceipt, NSArray* availableDownloads)) completionBlock
       onCancelled:(void (^)(void)) cancelBlock;

- (void)restorePreviousTransactionsOnComplete:(void (^)(void)) completionBlock
                                       onError:(void (^)(NSError* error)) errorBlock;

- (void)registerForNotificationsWithSubscriptionsPurchased:(YSStoreKitSubscriptionsPurchased)purchased
                                      subscriptionsInvalid:(YSStoreKitSubscriptionsInvalid)invalid;

- (BOOL)isFeaturePurchased:(NSString*) featureId;
- (BOOL)isSubscriptionActive:(NSString*) featureId;

- (BOOL)debug_removeAllKeychainData;

@end
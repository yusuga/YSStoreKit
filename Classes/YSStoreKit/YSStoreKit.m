//
//  YSStoreKit.m
//  YSStoreKitExample
//
//  Created by Yu Sugawara on 2014/01/08.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "YSStoreKit.h"
#import "YSStoreKitActivityIndicatorView.h"
#import "YSStoreKitAlert.h"

#import <MKStoreKit/MKStoreManager.h>
#import <AFNetworking/AFNetworking.h>

@interface YSStoreKit ()

@property (nonatomic) YSStoreKitActivityIndicatorView *activityIndicatorView;

@property (copy, nonatomic) YSStoreKitSubscriptionsPurchased subscriptionsPurchased;
@property (copy, nonatomic) YSStoreKitSubscriptionsInvalid subscriptionsInvalid;
@property (nonatomic, getter=isProductsAvailable) BOOL isProductsAvailable;

@end

@implementation YSStoreKit

+ (YSStoreKit*)sharedManager
{
    static id s_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_sharedManager = [[self alloc] init];
    });
    return s_sharedManager;
}

- (id)init
{
    if (self = [super init]) {
        self.activityIndicatorView = [[YSStoreKitActivityIndicatorView alloc] init];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}

- (void)registerForNotificationsWithSubscriptionsPurchased:(YSStoreKitSubscriptionsPurchased)purchased
                                      subscriptionsInvalid:(YSStoreKitSubscriptionsInvalid)invalid
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(subscriptionsPurchasedNotification:)
                   name:kSubscriptionsPurchasedNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(subscriptionsInvalidNotification:)
                   name:kSubscriptionsInvalidNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(productFetchedNotification:)
                   name:kProductFetchedNotification
                 object:nil];
    
    self.subscriptionsPurchased = purchased;
    self.subscriptionsInvalid = invalid;
}

#pragma mark - Public

- (void)buyFeature:(NSString*) featureId
         onComplete:(void (^)(NSString* purchasedFeature, NSData*purchasedReceipt, NSArray* availableDownloads)) completionBlock
        onCancelled:(void (^)(void)) cancelBlock
{
    if ([[self class] isIAPAvailableWithErrorAlertShown:YES] == NO) return;
    
    [self.activityIndicatorView show];
    
    __weak typeof(self) wself = self;
    [[MKStoreManager sharedManager] buyFeature:featureId
                                    onComplete:^(NSString *purchasedFeature, NSData *purchasedReceipt, NSArray *availableDownloads){
                                        [wself.activityIndicatorView hide];
                                        completionBlock(purchasedFeature, purchasedReceipt, availableDownloads);
                                    }onCancelled:^{
                                        [wself.activityIndicatorView hide];
                                        cancelBlock();
                                    }];
}

- (void)restorePreviousTransactionsOnComplete:(void (^)(void)) completionBlock
                                      onError:(void (^)(NSError* error)) errorBlock
{
    if ([[self class] isIAPAvailableWithErrorAlertShown:YES] == NO) return;
    
    [self.activityIndicatorView show];
    
    __weak typeof(self) wself = self;
    [[MKStoreManager sharedManager] restorePreviousTransactionsOnComplete:^{
        [wself.activityIndicatorView hide];
        completionBlock();
    }onError:^(NSError *error){
        [wself.activityIndicatorView hide];
        errorBlock(error);
    }];
}

- (BOOL)isFeaturePurchased:(NSString*) featureId
{
    return [MKStoreManager isFeaturePurchased:featureId];
}

- (BOOL)isSubscriptionActive:(NSString*) featureId
{
    return [[MKStoreManager sharedManager] isSubscriptionActive:featureId];
}

- (BOOL)debug_removeAllKeychainData
{
    return [[MKStoreManager sharedManager] removeAllKeychainData];
}

#pragma mark - Notification

- (void)productFetchedNotification:(NSNotification*)notification
{
    NSNumber *available = notification.object;
    NSAssert1([available isKindOfClass:[NSNumber class]], @"available is not NSNumber class. available class = %@;", NSStringFromClass([available class]));
    if ([available isKindOfClass:[NSNumber class]]) {
        self.isProductsAvailable = [available boolValue];
    }
}

- (void)subscriptionsPurchasedNotification:(NSNotification*)notification
{
    NSLog(@"%s", __func__);
    NSLog(@"id = %@", notification.object);
    if (self.subscriptionsPurchased) self.subscriptionsPurchased(notification.object);
}

- (void)subscriptionsInvalidNotification:(NSNotification*)notification
{
    NSLog(@"=========");
    NSLog(@"Error: %s", __func__);
    NSLog(@"id = %@", notification.object);
    NSLog(@"=========\n\n\n");
    if (self.subscriptionsInvalid) self.subscriptionsInvalid(notification.object);
}

#pragma mark - Helper

+ (BOOL)isIAPAvailableWithErrorAlertShown:(BOOL)alertShown
{
    if (![SKPaymentQueue canMakePayments]) {
        if (alertShown) [YSStoreKitAlert showIAPMaskedErrorAlert];
        return NO;
    }
    if (![AFNetworkReachabilityManager sharedManager].isReachable) {
        if (alertShown) [YSStoreKitAlert showNewtworkErrorAlert];
        return NO;
    }
    if (![[self sharedManager] isProductsAvailable]) {
        if (alertShown) [YSStoreKitAlert showITunesSearverErrorAlert];
        return NO;
    }
    return YES;
}

@end

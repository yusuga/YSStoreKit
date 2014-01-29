//
//  ViewController.m
//  YSStoreKitExample
//
//  Created by Yu Sugawara on 2014/01/12.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "ViewController.h"
#import "YSStoreKit.h"
#import "YSStoreKitIAPProductIds.h"
#import <UIAlertView+Blocks/UIAlertView+Blocks.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)awakeFromNib
{
    __weak typeof(self) wself = self;
    [[YSStoreKit sharedManager] registerForNotificationsWithSubscriptionsPurchased:^(NSString *productId){
        [wself refreshTableView];
    }subscriptionsInvalid:^(NSString *productId){
        [wself refreshTableView];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshTableView
{
    NSLog(@"%s", __func__);
    [self.tableView reloadData];
}

- (NSString*)productIdForIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    return kIAPProductIdItem01;
                case 1:
                    return kIAPProductIdItem02;
                case 2:
                    return kIAPProductIdItem03;
                default:
                    abort();
            }
        case 1:
            switch (indexPath.row) {
                case 0:
                    return kIAPProductId7Days;
                case 1:
                    return kIAPProductId1Month7DaysFreeTrial;
                default:
                    abort();
                    break;
            }
            break;
        default:
            abort();
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *lbl = cell.detailTextLabel;
    
    NSString *productId = [self productIdForIndexPath:indexPath];
    BOOL purchased;
    switch (indexPath.section) {
        case 0:
            purchased = [[YSStoreKit sharedManager] isFeaturePurchased:productId];
            lbl.text = purchased ? @"Purchased" : @"NO";
            break;
        case 1:
            purchased = [[YSStoreKit sharedManager] isSubscriptionActive:productId];
            lbl.text = purchased ? @"Active" : @"inactive";
            break;
        default:
            abort();
    }
    
    lbl.textColor = purchased ? [UIColor blueColor] : [UIColor redColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) wself = self;
    void(^request)(void) = ^{
        [[YSStoreKit sharedManager] buyFeature:[self productIdForIndexPath:indexPath]
                                          onComplete:^(NSString *purchasedFeature, NSData *purchasedReceipt, NSArray *availableDownloads) {
                                              [wself refreshTableView];
                                          } onCancelled:^{
                                              [wself refreshTableView];
                                          }];
    };

#define kAlertViewTest 0
#if kAlertViewTest
    [UIAlertView showWithTitle:@"Show UIAlertView test"
                       message:nil
             cancelButtonTitle:@"OK"
             otherButtonTitles:nil
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          request();
                      }];
#else
    request();
#endif
}

#pragma mark - Button action

- (IBAction)refreshButtonDidPush:(id)sender
{
    [self refreshTableView];
}

- (IBAction)restoreButtonDidPush:(id)sender
{
    __weak typeof(self) wself = self;
    [[YSStoreKit sharedManager] restorePreviousTransactionsOnComplete:^{
        [wself refreshTableView];
    }onError:^(NSError *error){
        [wself refreshTableView];
    }];
}

@end

//
//  YSStoreKitActivityIndicatorView.m
//  YSStoreKitHelperDevelopment
//
//  Created by Yu Sugawara on 2014/01/08.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "YSStoreKitActivityIndicatorView.h"

@interface YSStoreKitActivityIndicatorView ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation YSStoreKitActivityIndicatorView

- (id)init
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    self = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    CGRect f = self.frame;
    f.size = [UIScreen mainScreen].bounds.size;
    self.frame= f;
    [self.activityIndicatorView startAnimating];
    return self;
}

- (void)show
{
    [self setShown:YES];
}

- (void)hide
{
    [self setShown:NO];
}

- (void)setShown:(BOOL)shown
{
    if (shown) {
        [[UIApplication sharedApplication].delegate.window addSubview:self];
        self.alpha = 0.0;
    }
    
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.3 animations:^{
        wself.alpha = shown;
    }completion:^(BOOL finished){
        if (shown == NO) {
            [wself removeFromSuperview];
        }
    }];
}

@end

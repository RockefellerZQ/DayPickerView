//
//  ZQPresentTransition.m
//  DayPickerViewController
//
//  Created by Ant on 15/8/17.
//  Copyright (c) 2015年 aoliday. All rights reserved.
//

#import "ZQPresentTransition.h"

@implementation ZQPresentTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return _animationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [fromVC.view removeFromSuperview];
    fromView = [fromView snapshotViewAfterScreenUpdates:YES];
    UIView *contanierView = [transitionContext containerView];
    [contanierView addSubview:fromView];
    [contanierView addSubview:toView];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    toView.frame = CGRectOffset(finalFrame, 0, finalFrame.size.height);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toView.frame = finalFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end

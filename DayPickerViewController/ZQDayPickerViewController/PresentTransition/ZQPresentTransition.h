//
//  ZQPresentTransition.h
//  DayPickerViewController
//
//  Created by Ant on 15/8/17.
//  Copyright (c) 2015年 aoliday. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQPresentTransition : NSObject <UIViewControllerAnimatedTransitioning>

// 视图从底部呈现动画的时间， 如果为0则不呈现动画
@property (nonatomic, assign) NSTimeInterval animationDuration;

@end

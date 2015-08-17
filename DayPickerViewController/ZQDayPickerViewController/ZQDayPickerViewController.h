//
//  ZQDayPickerViewController.h
//  DayPickerViewController
//
//  Created by Ant on 15/8/14.
//  Copyright (c) 2015年 aoliday. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZQDayPickerViewController;
@protocol ZQDayPickerViewControllerDelegate <NSObject>

@optional
- (void)dayPickerViewControllerCancled:(ZQDayPickerViewController *)dayPickerViewController;
- (void)dayPickerViewControllerChoosedDate:(ZQDayPickerViewController *)dayPickerViewController;

@end

@interface ZQDayPickerViewController : UIViewController

/**
 *  设置提示的文本，默认nil
 */
@property (nonatomic, copy) NSString *hintTitle;

/**
 *  设置开始显示的时间, 默认是当前时间, 当选择之后，这个就是选择的时间
 */
@property (nonatomic) NSDate *date;

/**
 *  选中时间后，文本的颜色 默认darkTextColor
 */
@property (nonatomic) UIColor *selectedColor;

/**
 *  从设置date开始需要显示的天数
 */
@property (nonatomic, assign) NSInteger numberOfDays;

@property (nonatomic, weak) id <ZQDayPickerViewControllerDelegate>delegate;

@end

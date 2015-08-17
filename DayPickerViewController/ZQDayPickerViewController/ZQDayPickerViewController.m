//
//  ZQDayPickerViewController.m
//  DayPickerViewController
//
//  Created by Ant on 15/8/14.
//  Copyright (c) 2015年 aoliday. All rights reserved.
//

#import "ZQDayPickerViewController.h"
#import "ZQPresentTransition.h"

@interface ZQDayPickerViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate>
/**
 *  提示文本框的label
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 *  时间选择器
 */
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic) ZQPresentTransition *presentTransition;


/**
 *  *****************************************************
 */

/**
 *  当前的日历
 */
@property (nonatomic) NSCalendar *currenCalendar;

@property (nonatomic) NSDateComponents *dateComponents;

/**
 *  日期格式
 */
@property (nonatomic, copy) NSDateFormatter *dateFormatter;
@property (nonatomic, assign) NSInteger currentDay;
@property (nonatomic, assign) NSInteger currentHour;
@property (nonatomic, assign) NSInteger currentMinute;

@end

@implementation ZQDayPickerViewController
{
    // 临时变量 用于计算天数
    NSInteger tempSelectedDay;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeValues];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initializeValues];
    }
    return self;
}

- (void)initializeValues
{
    _hintTitle = nil;
    _date = [NSDate date];
    _currenCalendar = [NSCalendar currentCalendar];
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    _dateFormatter.dateFormat = @"MM月dd日 EE";
    _selectedColor = [UIColor darkTextColor];
    _numberOfDays = 30;
    _presentTransition = [ZQPresentTransition new];
    _presentTransition.animationDuration = 0;
    self.transitioningDelegate = self;
    [self initComponentsWithDate:_date];
}

- (void)createTapGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleButtonPressed:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    tapGesture = nil;
}

- (void)initComponentsWithDate:(NSDate *)date
{
    _dateComponents = [_currenCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    _currentDay = tempSelectedDay = _dateComponents.day;
    _currentHour = _dateComponents.hour;
    _currentMinute = _dateComponents.minute;
}

- (void)setDate:(NSDate *)date
{
    if (_date != date)
    {
        _date = date;
        [self initComponentsWithDate:_date];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLabel.text = _hintTitle;
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_pickerView selectRow:_currentHour inComponent:1 animated:NO];
    [_pickerView selectRow:_currentMinute inComponent:2 animated:NO];
    self.view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    [self createTapGesture];
    // Do any additional setup after loading the view from its nib.
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;

{
    return _presentTransition;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showDayPickerAnimate];
    [self pickerView:_pickerView didSelectRow:0 inComponent:0];
    [self pickerView:_pickerView didSelectRow:_currentHour inComponent:1];
    [self pickerView:_pickerView didSelectRow:_currentMinute inComponent:2];
}

#pragma mark Picker View Delegate
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rows = 0;
    switch (component) {
        case 0:
            rows = _numberOfDays;
            break;
        case 1:
            rows = 24;
            break;
        case 2:
            rows = 60;
            break;
        default:
            rows = 0;
            break;
    }
    return rows;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    CGFloat width = pickerView.frame.size.width;
    CGFloat space = width / 3.0;
    space += 40;
    CGFloat lastTwoSpace = (width - space) / 2.0;
    
    // 这个view每次都是nil，并没有重用的view
    UILabel *label = (UILabel *)view;
    if (!label)
    {
        CGRect rect = component == 0 ? CGRectMake(0, 0, space, 40.0) : CGRectMake(0, 0, lastTwoSpace, 40.0);
        label = [[UILabel alloc] initWithFrame:rect];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:18.0];
        label.backgroundColor = [UIColor clearColor];
    }
    
    NSString *showString = nil;
    if (component == 0)
    {
        NSInteger day = tempSelectedDay + row;
        _dateComponents.day = day;
        showString = [self getDayShowStringFromDateComponents:_dateComponents];
    } else {
        showString = [NSString stringWithFormat:@"%.2li", row];
    }
    label.text = showString;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
    label.textColor = _selectedColor;
    if (component == 0)
    {
        _currentDay = tempSelectedDay + row;
    }
    
    if (component == 1)
    {
        _currentHour = row;
    }
    
    if (component == 2)
    {
        _currentMinute = row;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat width = pickerView.frame.size.width;
    CGFloat space = width / 3.0;
    space += 40;
    CGFloat lastTwoSpace = (width - space) / 2.0;
    if (component == 0)
    {
        return space;
    } else {
        return lastTwoSpace;
    }
}

#pragma custom method
// 获取当前日期的字符串
- (NSString *)getDayShowStringFromDateComponents:(NSDateComponents *)dateComponents
{
    NSDate *date = [_currenCalendar dateFromComponents:dateComponents];
    return [_dateFormatter stringFromDate:date];
}

- (void)showDayPickerAnimate
{
    _bottomConstraint.constant = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)hiddenDayPickerAnimateWithComplectionBlock:(void(^)(void))complectionBlock
{
    _bottomConstraint.constant = -_contentView.frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (complectionBlock)
        {
            complectionBlock();
        }
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (IBAction)cancleButtonPressed:(id)sender {
    __weak typeof(self) weakSelf = self;
    [weakSelf hiddenDayPickerAnimateWithComplectionBlock:^{
        if (_delegate && [_delegate respondsToSelector:@selector(dayPickerViewControllerCancled:)])
        {
            [_delegate dayPickerViewControllerCancled:weakSelf];
        }
    }];
}

- (IBAction)sureButtonPressed:(id)sender {
    _dateComponents.day = _currentDay;
    _dateComponents.hour = _currentHour;
    _dateComponents.minute = _currentMinute;
    _date = [_currenCalendar dateFromComponents:_dateComponents];
    __weak typeof(self) weakSelf = self;
    [weakSelf hiddenDayPickerAnimateWithComplectionBlock:^{
        if (_delegate && [_delegate respondsToSelector:@selector(dayPickerViewControllerChoosedDate:)]) {
            [_delegate dayPickerViewControllerChoosedDate:weakSelf];
        }
    }];
}

#pragma mark gesture delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint touchPoint = [gestureRecognizer locationInView:self.view];
    touchPoint = [self.view convertPoint:touchPoint toView:_contentView];
    if (CGRectContainsPoint(_contentView.bounds, touchPoint))
    {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _currenCalendar = nil;
    _date = nil;
    _hintTitle = nil;
    _dateFormatter = nil;
}

@end

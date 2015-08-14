//
//  ViewController.m
//  DayPickerViewController
//
//  Created by Ant on 15/8/14.
//  Copyright (c) 2015年 aoliday. All rights reserved.
//

#import "ViewController.h"
#import "ZQDayPickerViewController.h"

@interface ViewController () <ZQDayPickerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buttonPressed:(UIButton *)sender {
    ZQDayPickerViewController *dayPickerViewController = [[ZQDayPickerViewController alloc] initWithNibName:NSStringFromClass([ZQDayPickerViewController class]) bundle:nil];
    dayPickerViewController.selectedColor = [UIColor orangeColor];
    dayPickerViewController.hintTitle = @"选取时间";
    dayPickerViewController.delegate = self;
    [self presentViewController:dayPickerViewController animated:NO completion:nil];
}

- (void)dayPickerViewControllerChoosedDate:(ZQDayPickerViewController *)dayPickerViewController
{
    _textField.text = [self dateStringFromDate:dayPickerViewController.date];
}

- (NSString *)dateStringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy年MM月dd日 HH:mm";
    return [formatter stringFromDate:date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

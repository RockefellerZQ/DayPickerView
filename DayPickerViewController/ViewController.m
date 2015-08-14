//
//  ViewController.m
//  DayPickerViewController
//
//  Created by Ant on 15/8/14.
//  Copyright (c) 2015年 aoliday. All rights reserved.
//

#import "ViewController.h"
#import "ZQDayPickerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buttonPressed:(UIButton *)sender {
    ZQDayPickerViewController *dayPickerViewController = [[ZQDayPickerViewController alloc] initWithNibName:NSStringFromClass([ZQDayPickerViewController class]) bundle:nil];
    dayPickerViewController.selectedColor = [UIColor orangeColor];
    [self presentViewController:dayPickerViewController animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

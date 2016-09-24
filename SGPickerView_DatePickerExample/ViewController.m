//
//  ViewController.m
//  SGPickerView_DatePickerExample
//
//  Created by Sorgle on 16/9/23.
//  Copyright © 2016年 Sorgle. All rights reserved.
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
//
//  - - 如在使用中, 遇到什么问题或者有更好建议者, 请于kingsic@126.com邮箱联系 - - - - - //
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - GitHub下载地址 https://github.com/kingsic/SGPickerView_DatePicker.git - - //
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

#import "ViewController.h"
#import "SGPicker.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)pickerView_bottom:(id)sender {
    SGPickerView *pickerView = [[SGPickerView alloc] init];
    [pickerView show];
    pickerView.locationMessage = ^(NSString *str){
        self.title = str;
    };
}

- (IBAction)pickerView_center:(id)sender {
    SGPickerView *pickerView = [[SGPickerView alloc] init];
    pickerView.pickerViewType = SGPickerViewTypeCenter;
    
    [pickerView show];
    pickerView.locationMessage = ^(NSString *str){
        self.title = str;
    };
}


- (IBAction)datePicker_bottom:(id)sender {
    // 日期
    SGDatePicker *datePicker = [[SGDatePicker alloc] init];
    datePicker.isBeforeTime = YES; // 日期一定要设置
    datePicker.datePickerMode = UIDatePickerModeDate; // 日期一定要设置
    __weak typeof(self) weakSelf = self;
    [datePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        weakSelf.title = [self dateStringWithDate:selectedDate DateFormat:@"yyyy年MM月dd日"];
    }];
    [datePicker show];
}
- (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}
- (IBAction)datePicker_center:(id)sender {
    // 时间
    SGDatePicker *datePicker = [[SGDatePicker alloc] init];
    datePicker.datePickerType = SGDatePickerTypeCenter;
    __weak typeof(self) weakSelf = self;
    [datePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        weakSelf.title = [self dateStringWithDate:selectedDate DateFormat:@"MM月dd日 HH:mm"];
    }];
    [datePicker show];
}



@end



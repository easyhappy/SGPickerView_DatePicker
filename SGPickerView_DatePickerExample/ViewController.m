//
//  ViewController.m
//  SGPickerView_DatePickerExample
//
//  Created by Sorgle on 16/9/23.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
//
//  - - 欢迎前来GitHub下载最新、最完善的Demo - - - - - - - - - - - - - - - - - - - //
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - GitHub下载地址 https://github.com/kingsic/SGPickerView_DatePicker.git - - //
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //


#import "ViewController.h"
#import "SGPicker.h"

@interface ViewController ()
@property (nonatomic, strong) SGDatePicker *datePicker;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)pickerView_bottom:(id)sender {
    SGPickerView *pickerView = [[SGPickerView alloc] init];
    pickerView.locationMessage = ^(NSString *str){
        self.title = str;
    };
}

- (IBAction)pickerView_center:(id)sender {
    
}


- (IBAction)datePicker_bottom:(id)sender {
    self.datePicker = [[SGDatePicker alloc] init];
    _datePicker.isBeforeTime = YES; // 日期一定要设置
    _datePicker.datePickerMode = UIDatePickerModeDate; // 日期一定要设置
    __weak typeof(self) weakSelf = self;
    [self.datePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        weakSelf.title = [self dateStringWithDate:selectedDate DateFormat:@"yyyy年MM月dd日"];
    }];

    // 时间的获取
//    _timePicker = [[MHDatePicker alloc] init];
//    __weak typeof(self) weakSelf = self;
//    [_timePicker didFinishSelectedDate:^(NSDate *selectedDate) {
//        weakSelf.title = [weakSelf dateStringWithDate:selectedDate DateFormat:@"MM月dd日 HH:mm"];
//    }];

}
- (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}

- (IBAction)datePicker_center:(id)sender {
    
}



@end



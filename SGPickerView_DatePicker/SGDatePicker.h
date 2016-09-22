//
//  SGDatePicker.h
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


#import <UIKit/UIKit.h>
#import "SGDatePickerSheetView.h"

typedef void (^DataTimeSelect)(NSDate *selectDataTime);

@interface SGDatePicker : UIView

/** 当前选中的Date */
@property (nonatomic, strong) NSDate *selectDate;
/** 是否可选择当前时间之前的时间, 默认为NO */
@property (nonatomic, assign) BOOL isBeforeTime;
/** DatePickerMode, 默认是DateAndTime */
@property (nonatomic, assign) UIDatePickerMode datePickerMode;

- (void)didFinishSelectedDate:(DataTimeSelect)selectDataTime;

@property (nonatomic, strong) NSDate *maxSelectDate;
/** 优先级低于isBeforeTime */
@property (nonatomic, strong) NSDate *minSelectDate;

@end

//
//  SGDatePicker.m
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


#import "SGDatePicker.h"

#define SG_screenWidth [UIScreen mainScreen].bounds.size.width
#define SG_screenHeight [UIScreen mainScreen].bounds.size.height
#define SGLocationPickerSheetViewHeight SG_screenHeight * 0.35

@interface SGDatePicker ()
/** SGDatePickerSheetView对象 */
@property (nonatomic, strong) SGDatePickerSheetView *datePickerSheetView;
/** 遮盖 */
@property (nonatomic, strong) UIButton *coverView;
@property (nonatomic, copy) DataTimeSelect selectBlock;

@end

@implementation SGDatePicker

- (instancetype)init {
    
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SG_screenWidth, SG_screenHeight); // 设置self的frame， 若没有设置button的点击事件不响应（想要响应button的点击事件， 其父视图必须有frame且大于button）
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        
        // 遮盖
        self.coverView = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0.0;
        [_coverView addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
        _coverView.frame = CGRectMake(0, 0, SG_screenWidth, SG_screenHeight);
        [self addSubview:self.coverView];
        
        // SGLocationPickerSheetViewHeight
        self.datePickerSheetView = [[[NSBundle mainBundle] loadNibNamed:@"SGDatePickerSheetView" owner:nil options:nil] firstObject];
        _datePickerSheetView.frame = CGRectMake(0, SG_screenHeight, SG_screenWidth, SGLocationPickerSheetViewHeight);
        [_datePickerSheetView addTargetCancelBtn:self action:@selector(dismissPickerView)];
        [_datePickerSheetView addTargetSureBtn:self action:@selector(sureBtnClick)];
        [_datePickerSheetView.datePicker addTarget:self action:@selector(datePickerValueChange:) forControlEvents:UIControlEventValueChanged];
        //DatePicker属性设置
        _selectDate = [NSDate new];
        _datePickerSheetView.datePicker.date = _selectDate;
        _datePickerSheetView.datePicker.minimumDate = _selectDate;
        _datePickerSheetView.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [self addSubview:_datePickerSheetView];
        
        // 出现
        [self show];
        
    }
    return self;
}

#pragma mark - - - 按钮的点击事件
- (void)sureBtnClick {
    if (_selectBlock) {
        _selectBlock(_selectDate);
    }
    [self dismissPickerView];
}

//DatePicker值改变
- (void)datePickerValueChange:(id)sender {
    _selectDate = [sender date];
}

// 消失
- (void)dismissPickerView {
    [UIView animateWithDuration:0.2 animations:^{
        self.datePickerSheetView.transform = CGAffineTransformMakeTranslation(0, SGLocationPickerSheetViewHeight);
        self.coverView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.datePickerSheetView removeFromSuperview];
        [self.coverView removeFromSuperview];
        [self removeFromSuperview];
    }];

}

// 出现
- (void)show {
    [UIView animateWithDuration:0.2 animations:^{
        self.datePickerSheetView.transform = CGAffineTransformMakeTranslation(0, - SGLocationPickerSheetViewHeight);
        self.coverView.alpha = 0.2;
    }];
}

#pragma mark - - - setter
- (void)setSelectDate:(NSDate *)selectDate {
    _selectDate = selectDate;
    if (selectDate) {
        _datePickerSheetView.datePicker.date = selectDate;
    }
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode {
    _datePickerSheetView.datePicker.datePickerMode = datePickerMode;
}

- (void)setIsBeforeTime:(BOOL)isBeforeTime {
    if (isBeforeTime) {
        [_datePickerSheetView.datePicker setMinimumDate:[NSDate dateWithTimeIntervalSince1970:0]];
    } else {
        [_datePickerSheetView.datePicker setMinimumDate:[NSDate date]];
    }
}

- (void)setMinSelectDate:(NSDate *)minSelectDate {
    if (minSelectDate) {
        [_datePickerSheetView.datePicker setMinimumDate:minSelectDate];
    }
}

- (void)setMaxSelectDate:(NSDate *)maxSelectDate {
    if (maxSelectDate) {
        [_datePickerSheetView.datePicker setMaximumDate:maxSelectDate];
    }
}

- (void)didFinishSelectedDate:(DataTimeSelect)selectDataTime {
    _selectBlock = selectDataTime;
}


@end



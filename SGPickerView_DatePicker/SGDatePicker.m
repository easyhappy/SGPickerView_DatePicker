//
//  SGDatePicker.m
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

#import "SGDatePicker.h"
#import "SGDatePickerSheetView.h"
#import "SGDatePickerCenterView.h"

#define SG_screenWidth [UIScreen mainScreen].bounds.size.width
#define SG_screenHeight [UIScreen mainScreen].bounds.size.height
#define SGLocationPickerSheetViewHeight SG_screenHeight * 0.35
#define SGLocationPickerCenterViewHeight SG_screenHeight * 0.4

@interface SGDatePicker ()
/** SGDatePickerSheetView对象 */
@property (nonatomic, strong) SGDatePickerSheetView *datePickerSheetView;
/** SGDatePickerCenterView对象 */
@property (nonatomic, strong) SGDatePickerCenterView *datePickerCenterView;
/** 遮盖 */
@property (nonatomic, strong) UIButton *coverView;
@property (nonatomic, copy) DataTimeSelect selectBlock;

@end

@implementation SGDatePicker

/** SGDatePickerCenterView距离X轴的距离 */
static CGFloat const margin_column_X = 20;
/** 动画时间 */
static CGFloat const SG_animateWithDuration = 0.2;

- (instancetype)init {
    
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SG_screenWidth, SG_screenHeight); // 设置self的frame， 若没有设置button的点击事件不响应（想要响应button的点击事件， 其父视图必须有frame且大于button）
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        
        self.datePickerType = SGDatePickerTypeBottom;
        
        // 遮盖
        self.coverView = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0.0;
        [_coverView addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
        _coverView.frame = CGRectMake(0, 0, SG_screenWidth, SG_screenHeight);
        [self addSubview:self.coverView];
    
        [self setupDatePickerSheetView];
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
    if (self.datePickerType == SGDatePickerTypeCenter) {
        [self.datePickerCenterView removeFromSuperview];
        [self.coverView removeFromSuperview];
        [self removeFromSuperview];
    } else {
        [UIView animateWithDuration:SG_animateWithDuration animations:^{
            self.datePickerSheetView.transform = CGAffineTransformMakeTranslation(0, SGLocationPickerSheetViewHeight);
            self.coverView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.datePickerSheetView removeFromSuperview];
            [self.coverView removeFromSuperview];
            [self removeFromSuperview];
        }];
    }
}

// 出现
- (void)show {
    if (self.datePickerType == SGDatePickerTypeCenter) {
        [self animationWithView:self.datePickerCenterView duration:0.3];
        self.coverView.alpha = 0.2;
    } else {
        [UIView animateWithDuration:SG_animateWithDuration animations:^{
            self.datePickerSheetView.transform = CGAffineTransformMakeTranslation(0, - SGLocationPickerSheetViewHeight);
            self.coverView.alpha = 0.2;
        }];
    }
}

- (void)setupDatePickerSheetView {
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
}

- (void)setupDatePickerCenterView {
    [self.datePickerSheetView removeFromSuperview];
    self.datePickerSheetView = nil;
    
    self.datePickerCenterView = [[[NSBundle mainBundle] loadNibNamed:@"SGDatePickerCenterView" owner:nil options:nil] firstObject];
    CGFloat pickerCenterViewX = margin_column_X;
    CGFloat pickerCenterViewY = (SG_screenHeight - SGLocationPickerCenterViewHeight) * 0.5;
    _datePickerCenterView.frame = CGRectMake(pickerCenterViewX, pickerCenterViewY, SG_screenWidth - 2 * pickerCenterViewX, SGLocationPickerCenterViewHeight);
    _datePickerCenterView.layer.cornerRadius = 7;
    _datePickerCenterView.layer.masksToBounds = YES;
    [_datePickerCenterView addTargetCancelBtn:self action:@selector(dismissPickerView)];
    [_datePickerCenterView addTargetSureBtn:self action:@selector(sureBtnClick)];
    [_datePickerCenterView.datePicker addTarget:self action:@selector(datePickerValueChange:) forControlEvents:UIControlEventValueChanged];
    //DatePicker属性设置
    _selectDate = [NSDate new];
    _datePickerCenterView.datePicker.date = _selectDate;
    _datePickerCenterView.datePicker.minimumDate = _selectDate;
    _datePickerCenterView.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [self addSubview:_datePickerCenterView];
}

/** SGDatePickerCenterView弹出样式 */
- (void)animationWithView:(UIView *)view duration:(CFTimeInterval)duration{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values_Arr = [NSMutableArray array];
    [values_Arr addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values_Arr addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values_Arr addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values_Arr;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [view.layer addAnimation:animation forKey:nil];
}

#pragma mark - - - setter
- (void)setSelectDate:(NSDate *)selectDate {
    _selectDate = selectDate;
    if (self.datePickerType == SGDatePickerTypeCenter) {
        if (selectDate) {
            _datePickerCenterView.datePicker.date = selectDate;
        }
    } else {
        if (selectDate) {
            _datePickerSheetView.datePicker.date = selectDate;
        }
    }
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode {
    if (self.datePickerType == SGDatePickerTypeCenter) {
        _datePickerCenterView.datePicker.datePickerMode = datePickerMode;
    } else {
        _datePickerSheetView.datePicker.datePickerMode = datePickerMode;
    }
}

- (void)setIsBeforeTime:(BOOL)isBeforeTime {
    if (self.datePickerType == SGDatePickerTypeCenter) {
        if (isBeforeTime) {
            [_datePickerCenterView.datePicker setMinimumDate:[NSDate dateWithTimeIntervalSince1970:0]];
        } else {
            [_datePickerCenterView.datePicker setMinimumDate:[NSDate date]];
        }

    } else {
        if (isBeforeTime) {
            [_datePickerSheetView.datePicker setMinimumDate:[NSDate dateWithTimeIntervalSince1970:0]];
        } else {
            [_datePickerSheetView.datePicker setMinimumDate:[NSDate date]];
        }
    }
}

- (void)setMinSelectDate:(NSDate *)minSelectDate {
    if (self.datePickerType == SGDatePickerTypeCenter) {
        if (minSelectDate) {
            [_datePickerCenterView.datePicker setMinimumDate:minSelectDate];
        }
    } else {
        if (minSelectDate) {
            [_datePickerSheetView.datePicker setMinimumDate:minSelectDate];
        }
    }
}

- (void)setMaxSelectDate:(NSDate *)maxSelectDate {
    if (self.datePickerType == SGDatePickerTypeCenter) {
        if (maxSelectDate) {
            [_datePickerCenterView.datePicker setMaximumDate:maxSelectDate];
        }
    } else {
        if (maxSelectDate) {
            [_datePickerSheetView.datePicker setMaximumDate:maxSelectDate];
        }
    }
}

- (void)didFinishSelectedDate:(DataTimeSelect)selectDataTime {
    _selectBlock = selectDataTime;
}

- (void)setDatePickerType:(SGDatePickerType)datePickerType {
    _datePickerType = datePickerType;
    if (self.datePickerType == SGDatePickerTypeCenter) {
        [self setupDatePickerCenterView];
    }
}

@end



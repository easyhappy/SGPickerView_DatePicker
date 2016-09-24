//
//  SGPickerView.m
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

#import "SGPickerView.h"
#import "SGLocationPickerSheetView.h"
#import "SGLocationPickerCenterView.h"

#define SG_component_total 3
#define SG_screenWidth [UIScreen mainScreen].bounds.size.width
#define SG_screenHeight [UIScreen mainScreen].bounds.size.height
#define SG_columnWidth SG_screenWidth / SG_component_total
#define SGLocationPickerSheetViewHeight SG_screenHeight * 0.35
#define SGLocationPickerCenterViewHeight SG_screenHeight * 0.4


@interface SGPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>
/** SGLocationPickerSheetView对象 */
@property (nonatomic, strong) SGLocationPickerSheetView *locationPickerSheetView;
/** SGLocationPickerSheetView对象 */
@property (nonatomic, strong) SGLocationPickerCenterView *locationPickerCenterView;

/** 遮盖 */
@property (nonatomic, strong) UIButton *coverView;
// data
@property (strong, nonatomic) NSDictionary *pickerDic;
/** 省份 */
@property (strong, nonatomic) NSArray *province_Arr;
/** 城市 */
@property (strong, nonatomic) NSArray *city_Arr;
/** 区，县 */
@property (strong, nonatomic) NSArray *area_Arr;
/** 选择的数据 */
@property (strong, nonatomic) NSArray *selected_Arr;

@end

@implementation SGPickerView
/** SGLocationPickerCenterView距离X轴的距离 */
static CGFloat const margin_column_X = 20;
/** 动画时间 */
static CGFloat const SG_animateWithDuration = 0.2;

- (instancetype)init {
    
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SG_screenWidth, SG_screenHeight); // 设置self的frame， 若没有设置button的点击事件不响应（想要响应button的点击事件， 其父视图必须有frame且大于button）
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        
        self.pickerViewType = SGPickerViewTypeBottom;
        
        // 遮盖
        self.coverView = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0.0;
        [_coverView addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
        _coverView.frame = CGRectMake(0, 0, SG_screenWidth, SG_screenHeight);
        [self addSubview:self.coverView];

        // 获取数据
        [self getLocationDateSourse];
        
        // SGLocationPickerSheetView
        [self setupSGLocationPickerSheetView];

    }
    return self;
}

#pragma mark - - - 按钮的点击事件
- (void)sureBtnClick {
    if (self.pickerViewType == SGPickerViewTypeCenter) {
        NSString *province = [NSString stringWithFormat:@"%@", [self.province_Arr objectAtIndex:[self.locationPickerCenterView.pickerView selectedRowInComponent:0]]];
        NSString *city = [NSString stringWithFormat:@"%@", [self.city_Arr objectAtIndex:[self.locationPickerCenterView.pickerView selectedRowInComponent:1]]];
        NSString *area = [NSString stringWithFormat:@"%@", [self.area_Arr objectAtIndex:[self.locationPickerCenterView.pickerView selectedRowInComponent:2]]];
        
        NSString *location = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
        
        self.locationMessage(location);
    } else {
        NSString *province = [NSString stringWithFormat:@"%@", [self.province_Arr objectAtIndex:[self.locationPickerSheetView.pickerView selectedRowInComponent:0]]];
        NSString *city = [NSString stringWithFormat:@"%@", [self.city_Arr objectAtIndex:[self.locationPickerSheetView.pickerView selectedRowInComponent:1]]];
        NSString *area = [NSString stringWithFormat:@"%@", [self.area_Arr objectAtIndex:[self.locationPickerSheetView.pickerView selectedRowInComponent:2]]];
        
        NSString *location = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
        
        self.locationMessage(location);
    }

    [self dismissPickerView];
}

// 消失
- (void)dismissPickerView {
    if (self.pickerViewType == SGPickerViewTypeCenter) {
        [self.coverView removeFromSuperview];
        [self removeFromSuperview];
    } else {
        [UIView animateWithDuration:SG_animateWithDuration animations:^{
            self.locationPickerSheetView.transform = CGAffineTransformMakeTranslation(0, SGLocationPickerSheetViewHeight);
            self.coverView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.locationPickerSheetView removeFromSuperview];
            [self.coverView removeFromSuperview];
            [self removeFromSuperview];
        }];
    }
}

// 出现
- (void)show {
    if (self.pickerViewType == SGPickerViewTypeCenter) {
        [self setupSGLocationPickerCenterView];
        [self animationWithView:self.locationPickerCenterView duration:0.3];
        [UIView animateWithDuration:SG_animateWithDuration animations:^{
            self.coverView.alpha = 0.2;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.locationPickerSheetView.transform = CGAffineTransformMakeTranslation(0, - SGLocationPickerSheetViewHeight);
            self.coverView.alpha = 0.2;
        }];
    }
}

- (void)setupSGLocationPickerSheetView {
    self.locationPickerSheetView = [[[NSBundle mainBundle] loadNibNamed:@"SGLocationPickerSheetView" owner:nil options:nil] firstObject];
    _locationPickerSheetView.frame = CGRectMake(0, SG_screenHeight, SG_screenWidth, SGLocationPickerSheetViewHeight);
    _locationPickerSheetView.pickerView.delegate = self;
    _locationPickerSheetView.pickerView.dataSource = self;
    [_locationPickerSheetView addTargetCancelBtn:self action:@selector(dismissPickerView)];
    [_locationPickerSheetView addTargetSureBtn:self action:@selector(sureBtnClick)];
    [self addSubview:_locationPickerSheetView];
}

- (void)setupSGLocationPickerCenterView {
    [self.locationPickerCenterView removeFromSuperview];
    
    CGFloat pickerCenterView_X = margin_column_X;
    CGFloat pickerCenterView_Y = (SG_screenHeight - SGLocationPickerCenterViewHeight) * 0.5;
    CGFloat pickerCenterView_W = SG_screenWidth - 2 * pickerCenterView_X;
    self.locationPickerCenterView = [[[NSBundle mainBundle] loadNibNamed:@"SGLocationPickerCenterView" owner:nil options:nil] firstObject];
    _locationPickerCenterView.frame = CGRectMake(pickerCenterView_X, pickerCenterView_Y, pickerCenterView_W, SGLocationPickerCenterViewHeight);
    _locationPickerCenterView.layer.cornerRadius = 7;
    _locationPickerCenterView.layer.masksToBounds = YES;
    _locationPickerCenterView.pickerView.delegate = self;
    _locationPickerCenterView.pickerView.dataSource = self;
    [_locationPickerCenterView addTargetCancelBtn:self action:@selector(dismissPickerView)];
    [_locationPickerCenterView addTargetSureBtn:self action:@selector(sureBtnClick)];
    [self addSubview:_locationPickerCenterView];
}

/** SGLocationPickerCenterView弹出样式 */
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

#pragma mark - 获取地区数据
- (void)getLocationDateSourse {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.province_Arr = [self.pickerDic allKeys];
    self.selected_Arr = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:0]];
    
    if (self.selected_Arr.count > 0) {
        self.city_Arr = [[self.selected_Arr objectAtIndex:0] allKeys];
    }
    
    if (self.city_Arr.count > 0) {
        self.area_Arr = [[self.selected_Arr objectAtIndex:0] objectForKey:[self.city_Arr objectAtIndex:0]];
    }
}

#pragma mark - - - UIPickerViewDataSource - UIPickerViewDelegate
// 返回列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return SG_component_total;
}
// 每列多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.province_Arr.count;
    } else if (component == 1) {
        return self.city_Arr.count;
    } else {
        return self.area_Arr.count;
    }
}

// 返回当前行的内容, 此处是将数组中数值添加到滚动的那个显示栏上
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.province_Arr[row];
    } else if (component == 1) {
        return self.city_Arr[row];
    } else {
        return self.area_Arr[row];
    }
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return SG_columnWidth - margin_column_X;
    } else if (component == 1) {
        return SG_columnWidth;
    } else {
        return SG_columnWidth - margin_column_X;
    }
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selected_Arr = self.pickerDic[self.province_Arr[row]];
        
        if (self.selected_Arr.count > 0) {
            self.city_Arr = [self.selected_Arr[0] allKeys];
            //            [[self.selectedArr objectAtIndex:0] allKeys];
        } else {
            self.city_Arr = nil;
        }
        if (self.city_Arr.count > 0) {
            self.area_Arr = self.selected_Arr[0][self.city_Arr[0]];
            //            [[self.selectedArr objectAtIndex:0] objectForKey:[self.cityArr objectAtIndex:0]];
        } else {
            self.area_Arr = nil;
        }
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1]; // 刷新列数
    [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
        if (self.selected_Arr.count > 0 && self.city_Arr.count > 0) {
            self.area_Arr = [[self.selected_Arr objectAtIndex:0] objectForKey:[self.city_Arr objectAtIndex:row]];
        } else {
            self.area_Arr = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    
    [pickerView reloadComponent:2];
}

/** 自定义component内容 */
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *label = nil;
    
    if (component == 0) {
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SG_columnWidth - margin_column_X, 30)];
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.text = [self.province_Arr objectAtIndex:row];
        
        label.font = [UIFont systemFontOfSize:16];         //用label来设置字体大小
        
        label.backgroundColor = [UIColor clearColor];
        
    }else if (component == 1) {
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SG_columnWidth - margin_column_X, 30)];
        
        label.text = [self.city_Arr objectAtIndex:row];
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.font = [UIFont systemFontOfSize:16];
        
        label.backgroundColor = [UIColor clearColor];
    } else {
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SG_columnWidth - margin_column_X, 30)];
        
        label.text = [self.area_Arr objectAtIndex:row];
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.font = [UIFont systemFontOfSize:16];
        
        label.backgroundColor = [UIColor clearColor];
        
    }
    return label;
}


@end



//
//  SGPickerView.h
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

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SGPickerViewTypeBottom,
    SGPickerViewTypeCenter,
} SGPickerViewType;

typedef void(^MyBlock)(NSString *);

@interface SGPickerView : UIView
/** SGPickerViewType */
@property (nonatomic, assign) SGPickerViewType pickerViewType;
/** 用于传值 */
@property (copy, nonatomic) MyBlock locationMessage;

- (void)show;

@end

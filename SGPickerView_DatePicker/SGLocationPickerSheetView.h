//
//  SGLocationPickerSheetView.h
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

@interface SGLocationPickerSheetView : UIView

/** pickerView */
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

/** 取消按钮的点击事件 */
- (void)addTargetCancelBtn:(id)target action:(SEL)action;
/** 确定按钮的点击事件 */
- (void)addTargetSureBtn:(id)target action:(SEL)action;

@end

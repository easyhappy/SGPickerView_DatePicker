## SGPickerView_DatePicker 用起来极其简单、实用(只需一句代码创建，一句代码传值，一句代码调出)

![](https://github.com/kingsic/SGPickerView_DatePicker/raw/master/Gif/sorgle.gif) 

* 将项目中SGPickerView_DatePicker文件夹拖入工程

* 导入#import "SGPicker.h"头文件

* 通过 alloc init 方法创建

    * 地区的选择
```Objective-C
    SGPickerView *pickerView = [[SGPickerView alloc] init];
    
    pickerView.pickerViewType = SGPickerViewTypeCenter; // 默认pickerViewType为SGPickerViewTypeBottom
    
    [pickerView show];
    
    pickerView.locationMessage = ^(NSString *str){
    
        self.title = str;
    
    };
```
 
   * 日期的选择
```Objective-C
    SGDatePicker *datePicker = [[SGDatePicker alloc] init];
    
    datePicker.isBeforeTime = YES; 
    
    datePicker.datePickerMode = UIDatePickerModeDate; // 日期一定要设置
    
    __weak typeof(self) weakSelf = self;
    
    [datePicker didFinishSelectedDate:^(NSDate *selectedDate) {
    
        weakSelf.title = [self dateStringWithDate:selectedDate DateFormat:@"yyyy年MM月dd日"]; // 日期设置
        
        weakSelf.title = [self dateStringWithDate:selectedDate DateFormat:@"MM月dd日 HH:mm"]; // 时间设置

    }];
    
    [datePicker show];
```


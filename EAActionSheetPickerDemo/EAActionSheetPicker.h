//
//  EAActionSheetPicker.h
//  Bold
//
//  Created by Erik Andersen on 5/21/13.
//  Copyright (c) 2013 Erik Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 This protocol method returns (id) because the return type is dependent on the type of picker currently active. Return types:
 
 EAActionSheetPickerTypeStandard returns an NSString
 EAActionSheetPickerTypeDate returns an NSDate
 
 As such, return types need to be checked in the delegate
 */

@class EAActionSheetPicker;
@protocol EAActionSheetPickerDelegate <UIActionSheetDelegate>
-(void)EAActionSheetPicker:(EAActionSheetPicker *)actionSheet didDismissWithSelection:(id)selection;
@end

typedef enum {
    EAActionSheetPickerTypeStandard,
    EAActionSheetPickerTypeDate
} EAActionSheetPickerType;

@interface EAActionSheetPicker : UIActionSheet <UIPickerViewDataSource, UIPickerViewDelegate>

/*
    The following three properties (picker, datePicker, and doneButton) DO NOT need to be touched by you for the typical user experience.
    We made them publicly accessible just in case there was custom coloring, drawing, etc. that you wanted to make unique for your application
 */

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UISegmentedControl *doneButton;

/*
 It isn't necessary to specify the type when you instantitate EAActionSheetPicker
 
 If you setPickerOptions then we automatically set the type to EAActionSheetPickerTypeStandard
 Also, if you set the dateMode we automatically set the type to EAActionSheetPickerTypeDate
 */

@property (nonatomic, weak) id <EAActionSheetPickerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *pickerOptions;
@property (nonatomic) EAActionSheetPickerType type;
@property (nonatomic) UIDatePickerMode dateMode;


-(id)initWithOptions:(NSArray *)options;
-(id)initWithDatePickerMode:(UIDatePickerMode)mode;
-(void)show;

@end

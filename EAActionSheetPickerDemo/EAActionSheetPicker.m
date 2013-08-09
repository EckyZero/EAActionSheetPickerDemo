//
//  EAActionSheetPicker.m
//  Bold
//
//  Created by Erik Andersen on 5/21/13.
//  Copyright (c) 2013 Erik Andersen. All rights reserved.
//

#import "EAActionSheetPicker.h"

#define PICKER_COMPONENTS  1
#define PICKER_CLOSE_BTN_BLUE   [UIColor colorWithRed:0.3 green:0.3 blue:1.0 alpha:1.0]
#define PICKER_CLOSE_BTN_FRAME  CGRectMake(260, 7, 50, 30)
#define PICKER_FRAME            CGRectMake(0, 40, 0, 0)
#define PICKER_SHEET_BOUNDS     CGRectMake(0, 0, 320, 485)
#define PICKER_CANCEL_BTN_FRAME CGRectMake(10, 7, 50, 30)

@interface EAActionSheetPicker ()

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation EAActionSheetPicker

@synthesize dateMode = _dateMode;

#pragma mark -
#pragma mark - Constructors

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithOptions:(NSMutableArray *)options{
    self = [super init];
    if(self){
        self.pickerOptions = options;
    }
    return self;
}

- (id)initWithDatePickerMode:(UIDatePickerMode)mode{
    self = [super init];
    if(self){
        self.dateMode = mode;
    }
    return self;
}

-(void)layoutSubviews{
    [self setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [self addSubview:self.leftControl];
    [self addSubview:self.rightControl];
    [self resignFirstResponder];
}

#pragma mark -
#pragma mark - Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return PICKER_COMPONENTS;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.pickerOptions count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.pickerOptions objectAtIndex:row];
}

#pragma mark -
#pragma mark - Setters

-(void)setDelegate:(id<EAActionSheetPickerDelegate>)delegate{
    [super setDelegate:delegate];
}

-(void)setDateMode:(UIDatePickerMode)dateMode{
    _dateMode = dateMode;
    self.type = EAActionSheetPickerTypeDate;
}

-(void)setPickerOptions:(NSMutableArray *)pickerOptions{
    _pickerOptions = pickerOptions;
    [self.picker reloadAllComponents];
    self.type = EAActionSheetPickerTypeStandard;
}

-(void)setType:(EAActionSheetPickerType)type{
    _type = type;
    
    if(_type == EAActionSheetPickerTypeDate){
        [self.picker removeFromSuperview];
        [self addSubview:self.datePicker];
        self.datePicker.datePickerMode = self.dateMode;
    } else if(_type == EAActionSheetPickerTypeStandard){
        [self.datePicker removeFromSuperview];
        [self addSubview:self.picker];
    }
}

-(void)setMinimumDate:(NSDate *)minimumDate{
    _minimumDate = minimumDate;
    self.datePicker.minimumDate = minimumDate;
    self.type = EAActionSheetPickerTypeDate;
}

-(void)setMaximumDate:(NSDate *)maximumDate{
    _maximumDate = maximumDate;
    self.datePicker.maximumDate = maximumDate;
    self.type = EAActionSheetPickerTypeDate;
}

#pragma mark -
#pragma mark - Getters

-(UIDatePickerMode)dateMode{
    if(!_dateMode){
        _dateMode = UIDatePickerModeDate;
    }
    return _dateMode;
}

-(UISegmentedControl *)leftControl{
    if(!_leftControl){
        _leftControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Cancel"]];
        _leftControl.momentary = YES;
        _leftControl.frame = PICKER_CANCEL_BTN_FRAME;
        _leftControl.segmentedControlStyle = UISegmentedControlStyleBar;
        [_leftControl addTarget:self action:@selector(hide:) forControlEvents:UIControlEventValueChanged];
    }
    return _leftControl;
}

-(UIDatePicker *)datePicker{
    if(!_datePicker){
        _datePicker = [[UIDatePicker alloc] initWithFrame:PICKER_FRAME];
    }
        _datePicker.datePickerMode = self.dateMode;
    return _datePicker;
}

-(UISegmentedControl *)rightControl{
    if(!_rightControl){
        _rightControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Done",nil]];
        _rightControl.momentary = YES;
        _rightControl.frame = PICKER_CLOSE_BTN_FRAME;
        _rightControl.segmentedControlStyle = UISegmentedControlStyleBar;
        _rightControl.tintColor = PICKER_CLOSE_BTN_BLUE;
        [_rightControl addTarget:self action:@selector(hide:) forControlEvents:UIControlEventValueChanged];
    }
    return _rightControl;
}

-(UIPickerView *)picker{
    if(!_picker){
        _picker = [[UIPickerView alloc] initWithFrame:PICKER_FRAME];
        _picker.showsSelectionIndicator = YES;
        _picker.dataSource = self;
        _picker.delegate = self;
    }
    return _picker;
}

#pragma mark -
#pragma mark - Actions

-(void)showInView:(UIView *)view {
    
    if(self.type == EAActionSheetPickerTypeStandard && !self.pickerOptions){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Options Specified"
                                                       message:@"You must set values to the pickerOptions property before proceeding"
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            [super showInView:[[UIApplication sharedApplication] keyWindow]];
            [self setBounds:PICKER_SHEET_BOUNDS];
        } completion:^(BOOL finished) {
            [self removeKeyboardFromView:view];
        }];
    }
}

#pragma mark -
#pragma mark - Private Helper Methods

- (void)hide:(UISegmentedControl *)sender {
    [self dismissWithClickedButtonIndex:0 animated:YES];
    
    // Only dismiss with selected if the last index on the right side was selected
    if(sender == self.rightControl){
        if(self.rightControl.selectedSegmentIndex == self.rightControl.numberOfSegments - 1){
            NSInteger row = [self.picker selectedRowInComponent:0];
            
            if(self.type == EAActionSheetPickerTypeStandard) {
                [self setDefaultValue:[self.pickerOptions objectAtIndex:row]];
                if([self.delegate respondsToSelector:@selector(EAActionSheetPicker:didDismissWithSelection:inTextField:)]){
                    [self.delegate EAActionSheetPicker:self
                               didDismissWithSelection:[self.pickerOptions objectAtIndex:row]
                                           inTextField:self.textField];
                }
            } else if(self.type == EAActionSheetPickerTypeDate){
                NSString *result;
                if(self.dateMode == UIDatePickerModeCountDownTimer){
                    result = [NSString stringWithFormat:@"%i",(int)self.datePicker.countDownDuration];
                } else if(self.dateMode == UIDatePickerModeDate){
                    result = [[NSString stringWithFormat:@"%@", self.datePicker.date] substringToIndex:10];
                } else if(self.dateMode == UIDatePickerModeDateAndTime){
                    result = [[NSString stringWithFormat:@"%@", self.datePicker.date] substringToIndex:19];
                }
//                else if(self.dateMode == UIDatePickerModeTime){
//                    result = [NSString stringWithFormat:@"%@", self.datePicker.date];
//                }
                
                [self setDefaultValue:result];
                if([self.delegate respondsToSelector:@selector(EAActionSheetPicker:didDismissWithSelection:inTextField:)]){
                    
                     if(self.dateMode == UIDatePickerModeCountDownTimer){
                         [self.delegate EAActionSheetPicker:self
                                    didDismissWithSelection:[NSNumber numberWithDouble:self.datePicker.countDownDuration]
                                                 inTextField:self.textField];
                     } else {
                         [self.delegate EAActionSheetPicker:self
                                    didDismissWithSelection:self.datePicker.date
                                                inTextField:self.textField];
                     }
                }
            }
        }
    }
}

-(void)setDefaultValue:(NSString *)value{
    if(self.textField){
        self.textField.text = value;
    }
    if(self.label){
        self.label.text = value;
    }
}

- (void)removeKeyboardFromView:(UIView *)view {
    
    [self.textField resignFirstResponder];
}

@end

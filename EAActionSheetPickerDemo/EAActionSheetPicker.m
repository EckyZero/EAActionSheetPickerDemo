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
@property (nonatomic, strong) NSString *headerTag;

@end

@implementation EAActionSheetPicker

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
    
    [super layoutSubviews];
    
    [self setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [self addSubview:self.leftControl];
    [self addSubview:self.rightControl];
    [self resignFirstResponder];
    
    [self.picker selectRow:1 inComponent:0 animated:YES];
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

-(UIView *)pickerView:(UIPickerView *)pickerView
           viewForRow:(NSInteger)row
         forComponent:(NSInteger)component
          reusingView:(UIView *)view {
    
    UILabel* label = [[UILabel alloc] init];
    NSString *text = [self.pickerOptions objectAtIndex:row];
    
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    
    // set font
    if ([text rangeOfString:self.headerTag].location != NSNotFound) {
        
        label.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
        label.backgroundColor = [UIColor colorWithRed:227/255.0 green:127/255.0 blue:102/255.0 alpha:1.0];;
        label.text = [text stringByReplacingOccurrencesOfString:self.headerTag withString:@""];
        label.textColor = [UIColor whiteColor];
        label.layer.shadowColor = [UIColor colorWithRed:157/255.0 green:40/255.0 blue:51/255.0 alpha:1.0].CGColor;
        label.layer.shadowOffset = CGSizeMake(0, 2);
        label.layer.shadowOpacity = 0.8;
        
    } else {
        
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"Arial-RegularMT" size:16];
    }
    
    return label;
}

#pragma mark -
#pragma mark - Picker View delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if([[self.pickerOptions objectAtIndex:row] rangeOfString:self.headerTag].location != NSNotFound) {
        [pickerView selectRow:row+1 inComponent:component animated:YES];
    }
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
    } else if(_type == EAActionSheetPickerTypeStandard){
        [self.datePicker removeFromSuperview];
        [self addSubview:self.picker];
    }
}

#pragma mark -
#pragma mark - Subcomponents

-(NSString *)headerTag {
    if(!_headerTag) {
        _headerTag = [NSString stringWithFormat:@"<h1>"];
    }
    return _headerTag;
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
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }
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
                    [super showInView:[[UIApplication sharedApplication] keyWindow]];
        [UIView animateWithDuration:0.25 animations:^{
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
            
            NSString *formattedResult = [[self.pickerOptions objectAtIndex:row] stringByReplacingOccurrencesOfString:self.headerTag
                                                                                                          withString:@""];
            if(self.type == EAActionSheetPickerTypeStandard) {
                [self setDefaultValue:formattedResult];
                if([self.delegate respondsToSelector:@selector(EAActionSheetPicker:didDismissWithSelection:inTextField:)]){
                    [self.delegate EAActionSheetPicker:self
                               didDismissWithSelection:formattedResult
                                           inTextField:self.textField];
                }
            } else if(self.type == EAActionSheetPickerTypeDate){
                [self setDefaultValue:[[NSString stringWithFormat:@"%@", self.datePicker.date] substringToIndex:10]];
                if([self.delegate respondsToSelector:@selector(EAActionSheetPicker:didDismissWithSelection:inTextField:)]){
                    [self.delegate EAActionSheetPicker:self
                               didDismissWithSelection:self.datePicker.date
                                           inTextField:self.textField];
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

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

@interface EAActionSheetPicker ()

@end

@implementation EAActionSheetPicker

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
    [self addSubview:self.doneButton];
}

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

#pragma mark - Subcomponents

-(UIDatePicker *)datePicker{
    if(!_datePicker){
        _datePicker = [[UIDatePicker alloc] initWithFrame:PICKER_FRAME];
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }
    return _datePicker;
}

-(UISegmentedControl *)doneButton{
    if(!_doneButton){
        _doneButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
        _doneButton.momentary = YES;
        _doneButton.frame = PICKER_CLOSE_BTN_FRAME;
        _doneButton.segmentedControlStyle = UISegmentedControlStyleBar;
        _doneButton.tintColor = PICKER_CLOSE_BTN_BLUE;
        [_doneButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventValueChanged];
    }
    return _doneButton;
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

#pragma mark - Actions
- (void)hide {
    [self dismissWithClickedButtonIndex:0 animated:YES];
    
    
    NSInteger row = [self.picker selectedRowInComponent:0];
    
    if(self.type == EAActionSheetPickerTypeStandard) {
        [self.delegate EAActionSheetPicker:self didDismissWithSelection:[self.pickerOptions objectAtIndex:row]];
    } else if(self.type == EAActionSheetPickerTypeDate){
        [self.delegate EAActionSheetPicker:self didDismissWithSelection:self.datePicker.date];
    }
}

-(void)show {
    
    if(self.type == EAActionSheetPickerTypeStandard && !self.pickerOptions){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Options Specified"
                                                       message:@"You must set values to the pickerOptions property before proceeding"
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            [self showInView:[[UIApplication sharedApplication] keyWindow]];
            [self setBounds:PICKER_SHEET_BOUNDS];
        } completion:^(BOOL finished) {}];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



@end

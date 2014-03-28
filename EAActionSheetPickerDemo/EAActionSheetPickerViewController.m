//
//  EAActionSheetPickerViewController.m
//  EAActionSheetDemo
//
//  Created by Erik Andersen on 5/21/13.
//  Copyright (c) 2013 Erik Andersen. All rights reserved.
//

#import "EAActionSheetPickerViewController.h"

@interface EAActionSheetPickerViewController ()

@property (nonatomic, strong) EAActionSheetPicker *picker;

@end

@implementation EAActionSheetPickerViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSArray *options = [NSArray arrayWithObjects:@"<h1>Numbers", @"1", @"2", @"3", @"4", @"5", @"<h1>Text", @"One", @"Two", @"Three", @"Four", @"Five", nil];
    self.picker = [[EAActionSheetPicker alloc]initWithOptions:options];
    self.picker.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)switchTapped:(UISwitch *)sender {
    
    if(sender.on){
        self.picker.type = EAActionSheetPickerTypeStandard;
    } else {
        self.picker.type = EAActionSheetPickerTypeDate;
        self.picker.maximumDate = [NSDate date];
        self.picker.dateMode = UIDatePickerModeDate;
    }
}

#pragma mark - EAActionSheetPicker Delegate

-(void)EAActionSheetPicker:(EAActionSheetPicker *)actionSheet
   didDismissWithSelection:(id)selection
               inTextField:(UITextField *)textField{
    
    // optional delegate method
    // The purpose is to specify another target for your selected text
    // i.e. label, textView, etc.
    // textField will be nil if none were previously specified
}

#pragma mark - UITextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.picker.textField = textField;
    [self.picker showInView:self.view];
}



@end

EAActionSheetPickerDemo
=======================

EAActionSheetPicker allows users to simply implement a UIActionSheet along with a UIPickerView/UIDatePicker without having to worry about messy allocations, display, etc. It's as simple as alloc initing the EAActionSheetPicker and you're done.

![Example Image](https://raw.github.com/EckyZero/EAActionSheetPickerDemo/master/EAActionSheetPickerDemo/Screenshot(2).PNG)

How To Use:
-----------

1. Copy EAActionSheetPicker.m/.h into your project
2. Import EAActionSheetPicker.h in the class you'd like to reference

After that, here's how simple it is to use:

    NSArray *options = [NSMutableArray arrayWithObjects:@"One", @"Two", @"Three", @"Four", @"Five", nil];
    EAActionSheetPicker *actionPicker = [[EAActionSheetPicker alloc]initWithOptions:options];
    actionPicker.textField = self.emailField;
    actionPicker.delegate = self;

    [actionPicker showInView:self.view];
    
If you have multiple textFields and want to use the same picker, set the associated textfield to the actionPicker in this UITextField delegate method

    -(void)textFieldDidBeginEditing:(UITextField *)textField{
        self.actionPicker.textField = textField;
        [self.actionPicker showInView:self.view];
    }
    
EAActionSheetPicker give you the option to implement one delegate method as shown below (using self.resultLabel to show how to handle what this delegate methods returns):

    // This returns a type of id because the return type is determined by which pickerType you're currently using. 
    -(void)EAActionSheetPicker:(EAActionSheetPicker *)actionSheet didDismissWithSelection:(id)selection inTextField:(UITextField *)textField{
    
      if([selection isKindOfClass:[NSString class]]){
            self.resultLabel.text = selection;
        } else if([selection isKindOfClass:[NSDate class]]){
            self.resultLabel.text = [NSString stringWithFormat:@"%@", selection];
        }
    }

Types do not need to be expressely assigned (but they can be if necessary). They are assigned dynamically as follows:

    // This automatically assigns the actionPicker to display a PickerView with the specified options
    actionPicker.pickerOptions = [NSMutableArray arrayWithObjects:@"One", @"Two", @"Three", nil];
    
    // This automatically assigns the actionPicker to display a DatePicker with the specified datePickerMode
    actionPicker.dateMode = UIDatePickerModeDate;
    
This allows you to use the same actionPicker to switch between displaying a datePicker or pickerView. If you'd like to manually switch display types, it's as simple as:
    
    // This means when you next call [actionPicker show], a pickerView will be displayed
    actionPicker.type = EAActionSheetPickerTypeStandard;
    
    // This means when you next call [actionPicker show], a datePicker will be displayed
    actionPicker.type = EAActionSheetPickerTypeDate;
    
We also provide several convenient init methods to get you started faster.

    // This instantiates an actionPicker as a pickerView with the specified options
    NSMutableArray *options = [NSMutableArray arrayWithObjects:@"One", @"Two", @"Three", @"Four", @"Five", nil];
    EAActionSheetPicker *actionPicker = [[EAActionSheetPicker alloc]initwithOptions:options];
    
    // This instantiates an actionPicker as a datePicker with the specified mode
    EAActionSheetPicker *actionPicker = [[EAActionSheetPicker alloc]initwithDatePickerMode:UIDatePickerModeDate];

If you're looking for section headers in your UIPickerView, then just add \<h1> to the text of your relevant pickerOptions. Example is shown below. This will give you section headers like the one shown in the preview above.
    
    NSMutableArray *options = [NSMutableArray arrayWithObjects:@"<h1>Numbers", @"1", @"2", @"3", @"4", @"5", @"<h1>Text", @"One", @"Two", @"Three", @"Four", @"Five", nil];
    
    
Enjoy!
    
- Cocoapod support coming soon

The MIT License (MIT)
---------------------

Copyright (c) 2013 Erik Andersen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

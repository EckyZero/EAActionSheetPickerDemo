//
//  EAActionSheetPickerViewController.h
//  EAActionSheetDemo
//
//  Created by Erik Andersen on 5/21/13.
//  Copyright (c) 2013 Erik Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAActionSheetPicker.h"

@interface EAActionSheetPickerViewController : UIViewController <EAActionSheetPickerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
- (IBAction)buttonTapped:(UIButton *)sender;
- (IBAction)switchTapped:(UISwitch *)sender;

@end

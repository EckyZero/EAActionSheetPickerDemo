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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSArray *options = [NSArray arrayWithObjects:@"One", @"Two", @"Three", @"Four", @"Five", nil];
    self.picker = [[EAActionSheetPicker alloc]initWithOptions:options];
    self.picker.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonTapped:(UIButton *)sender {
    
    [self.picker showInView:self.view];
}

- (IBAction)switchTapped:(UISwitch *)sender {
    
    if(sender.on){
        self.picker.type = EAActionSheetPickerTypeStandard;
    } else {
        self.picker.type = EAActionSheetPickerTypeDate;
    }
}

-(void)EAActionSheetPicker:(EAActionSheetPicker *)actionSheet didDismissWithSelection:(id)selection{
    if([selection isKindOfClass:[NSString class]]){
            self.resultLabel.text = selection;
    } else if([selection isKindOfClass:[NSDate class]]){
        self.resultLabel.text = [NSString stringWithFormat:@"%@", selection];
    }
}



@end

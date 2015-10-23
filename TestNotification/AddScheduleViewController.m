//
//  AddScheduleViewController.m
//  TestNotification
//
//  Created by Văn Tiến Tú on 10/22/15.
//  Copyright © 2015 Văn Tiến Tú. All rights reserved.
//

#import "AddScheduleViewController.h"

@interface AddScheduleViewController () <UITextFieldDelegate>

@end

@implementation AddScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _txtAddNote.delegate = self;
    
    [self setupView];
}

#pragma mark setup view

- (void) setupView {
    
    self.view.backgroundColor = [UIColor grayColor];
    
    _cancelBtn.backgroundColor = [UIColor whiteColor];
}

#pragma mark implement IABC


- (IBAction)cancelOnClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveScheduleReminderOnClicked:(id)sender {
    
    if ([_txtAddNote.text isEqual:@""] ||
        _datePicker.date == nil) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reminder" message:@"Missing infomation or this time is not exist" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK Action") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"OK Action");
            
            //[self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        [_delegate textFiled:_txtAddNote.text date:_datePicker.date];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    //_txtAddNote.text = @"";
    
    [_txtAddNote resignFirstResponder];
    
    return YES;
}



@end

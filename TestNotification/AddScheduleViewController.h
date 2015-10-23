//
//  AddScheduleViewController.h
//  TestNotification
//
//  Created by Văn Tiến Tú on 10/22/15.
//  Copyright © 2015 Văn Tiến Tú. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddScheduleDelegate

- (void) textFiled: (NSString *) txtAddNote date: (NSDate *) date;

@end


@interface AddScheduleViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *txtAddNote;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIButton *saveScheduleReminder;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;


@property (strong, nonatomic) id<AddScheduleDelegate> delegate;


@end

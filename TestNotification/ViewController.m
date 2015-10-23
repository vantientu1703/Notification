//
//  ViewController.m
//  TestNotification
//
//  Created by Văn Tiến Tú on 10/22/15.
//  Copyright © 2015 Văn Tiến Tú. All rights reserved.
//

#import "ViewController.h"
#import "AddScheduleViewController.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate,AddScheduleDelegate>

@property (nonatomic, strong) NSMutableArray *shoppingList;

@property (nonatomic, strong) NSString *txtNote;

@property (nonatomic, strong) NSDate *date;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
 
    [self setupNotificationSetting];
    
    [self setupView];
}

#pragma mark implement action



- (IBAction)addScheduleOnClicked:(id)sender {
    
    AddScheduleViewController *addScheduleViewCotroller = [[AddScheduleViewController alloc] init];
    
    addScheduleViewCotroller.delegate = self;
    
    [self.navigationController pushViewController:addScheduleViewCotroller animated:YES];
}

#pragma  mark setup view

- (void) setupView {
    
    _addSchedulebtn.layer.cornerRadius = _addSchedulebtn.bounds.size.width / 2;
    
    _addSchedulebtn.layer.masksToBounds = YES;
}
- (void) setupNotificationSetting{
    
    UIMutableUserNotificationAction *notificationAction1 = [[UIMutableUserNotificationAction alloc] init];
    notificationAction1.identifier = @"Accept";
    notificationAction1.title = @"Accept";
    notificationAction1.activationMode = UIUserNotificationActivationModeBackground;
    notificationAction1.destructive = NO;
    notificationAction1.authenticationRequired = NO;
    
    UIMutableUserNotificationAction *notificationAction2 = [[UIMutableUserNotificationAction alloc] init];
    notificationAction2.identifier = @"Reject";
    notificationAction2.title = @"Reject";
    notificationAction2.activationMode = UIUserNotificationActivationModeBackground;
    notificationAction2.destructive = YES;
    notificationAction2.authenticationRequired = YES;
    
    UIMutableUserNotificationAction *notificationAction3 = [[UIMutableUserNotificationAction alloc] init];
    notificationAction3.identifier = @"Reply";
    notificationAction3.title = @"Reply";
    notificationAction3.activationMode = UIUserNotificationActivationModeForeground;
    notificationAction3.destructive = NO;
    notificationAction3.authenticationRequired = YES;
    
    UIMutableUserNotificationCategory *notificationCategory = [[UIMutableUserNotificationCategory alloc] init];
    notificationCategory.identifier = @"Email";
    [notificationCategory setActions:@[notificationAction1,notificationAction2,notificationAction3] forContext:UIUserNotificationActionContextDefault];
    [notificationCategory setActions:@[notificationAction1,notificationAction2] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:notificationCategory, nil];
    
    UIUserNotificationType notificationType = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:notificationType categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    
    [self.tableView reloadData];
    
//    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
//    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
//    localNotification.alertBody = @"Testing";
//    localNotification.category = @"Email"; //  Same as category identifier
//    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}


#pragma mark AddScheduleDelegate

- (void) textFiled:(NSString *)txtAddNote date:(NSDate *)date {
    
    _txtNote = txtAddNote;
    _date = date;
    
    
    UILocalNotification *localNotifi = [[UILocalNotification alloc] init];
    
    localNotifi.alertBody = _txtNote;
    
    localNotifi.fireDate = _date;
    
    localNotifi.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotifi.soundName = (UILocalNotificationDefaultSoundName);
    
    localNotifi.alertAction = @"View List";
    
    localNotifi.category = @"Email";
    
    localNotifi.applicationIconBadgeNumber = 1;
    
    //localNotifi.repeatInterval = 0;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotifi];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    [self.tableView reloadData];

    NSLog(@"%@ %@",txtAddNote,date);
    NSLog(@"location Notification %@", localNotifi);
}

#pragma mark table view

- (NSInteger ) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger ) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[UIApplication sharedApplication] scheduledLocalNotifications] count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 60;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifer = @"cellIdentifer";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifer];
    }
    
    
    NSArray *notifiArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    UILocalNotification *notification = [notifiArray objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    
    [dateFomatter setDateFormat:@"yyyy - MM - dd hh:mm a"];
    
    cell.textLabel.text = notification.alertBody;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[dateFomatter stringFromDate:notification.fireDate]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSArray *notifi = [[UIApplication sharedApplication] scheduledLocalNotifications];
        
        [[UIApplication sharedApplication] cancelLocalNotification:[notifi objectAtIndex:indexPath.row]];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.tableView reloadData];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        [self.tableView reloadData];
    }
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"NOTE";
}
#pragma mark function














@end

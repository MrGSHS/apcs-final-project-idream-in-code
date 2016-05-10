//
//  SettingsViewController.m
//  BellSchedule
//
//  Created by Rahman on 5/3/16.
//  Copyright © 2016 AliRahman. All rights reserved.
//

#import "SettingsViewController.h"
#import "SlideNavigationController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set textfield based on current school
    NSString *curr =[[NSUserDefaults standardUserDefaults] valueForKey:@"SchoolDisplay"];
    [schoolField setText:curr];
    
    // Cell must adjust to accomodate suggestion box
    textFieldCellHeight = 82;
    
    // Set textfield delegate to be self
    [schoolField setDelegate:self];
    // Pull schools from an array (probably scrape the options off the internet)
    schools = [self parseAvailableSchoolSchedules];

    // Color picker setup

    // Do any additional setup after loading the view.
}

-(NSArray *)parseAvailableSchoolSchedules {
    NSMutableArray *finalarr = [[NSMutableArray alloc] init];
    NSString *link = @"http://alirahm.com/schedules/schools.txt";
    NSString *file = [NSString stringWithContentsOfURL:[NSURL URLWithString:link] encoding:NSStringEncodingConversionAllowLossy error:nil];
    NSMutableArray *arr = [[file componentsSeparatedByString:@"\n"] mutableCopy];
    [arr removeObject:@""];
    for (int i = 0; i < arr.count; i++) {
        NSArray *comps = [arr[i] componentsSeparatedByString:@"-"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if (comps.count >= 3) {
            [dict setValue:comps[0] forKey:@"DisplayText"];
            [dict setValue:comps[1] forKey:@"DisplaySubText"];
            [dict setValue:[comps[2] stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"code"];
        }
        [finalarr addObject:dict];
    }
    return [finalarr copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)dataForPopoverInTextField:(MPGTextField *)textField {
    return schools;
}

-(BOOL)textFieldShouldSelect:(MPGTextField *)textField {
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    // To resign first responder if keyboard is active
    tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tapBackground setNumberOfTapsRequired:1];
  //  [self.view addGestureRecognizer:tapBackground];
    

    textFieldCellHeight = 290;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    textFieldCellHeight = 82;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
   // [self.view removeGestureRecognizer:tapBackground];
}

-(void)textField:(MPGTextField *)textField didEndEditingWithSelection:(NSDictionary *)result {
    NSString *code = [result objectForKey:@"code"];
    NSLog(@"%@", code);
    if (code != [[NSUserDefaults standardUserDefaults] valueForKey:@"SchoolName"] && ![code isEqualToString: @"" ] && code != nil) {
        [[NSUserDefaults standardUserDefaults] setValue:code forKey:@"SchoolName"];
        [[NSUserDefaults standardUserDefaults] setValue:[result objectForKey:@"DisplayText"] forKey:@"SchoolDisplay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //TextField
    if (indexPath.section == 0 && indexPath.row == 0) {
        return textFieldCellHeight;
    }
    else {
        return 82;
    }
}

-(IBAction) dismissKeyboard {
    schoolField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"SchoolDisplay"];
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [schoolField setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"SchoolDisplay"]];

}

-(IBAction)setColorScheme:(id)sender {
    
    /* http://www.touch-code-magazine.com/web-color-to-uicolor-convertor/ -> Converted Flat Color hex to obj c.
       1 = Default white/gray
       2 = Blue
       3 = Green
       4 = Red
       5 = Orange
       6 = Purple   */
    
    UIColor *mainColor;
    UIColor *secondaryColor;
    
    switch ([sender tag]) {
        case 2:
            mainColor = [UIColor colorWithRed:0.773 green:0.937 blue:0.969 alpha:1]; /*#c5eff7*/
            secondaryColor = [UIColor colorWithRed:0.349 green:0.671 blue:0.89 alpha:1]; /*#59abe3*/
            break;
        case 3:
            mainColor = [UIColor colorWithRed:0.4 green:0.8 blue:0.6 alpha:1]; /*#66cc99*/
            secondaryColor = [UIColor colorWithRed:0 green:0.694 blue:0.416 alpha:1]; /*#00b16a*/
            break;
        case 4:
            mainColor = [UIColor colorWithRed:0.925 green:0.392 blue:0.294 alpha:1]; /*#ec644b*/
            secondaryColor = [UIColor colorWithRed:0.937 green:0.282 blue:0.212 alpha:1]; /*#ef4836*/
            break;
        case 5:
            mainColor = [UIColor colorWithRed:0.957 green:0.702 blue:0.314 alpha:1]; /*#f4b350*/
            secondaryColor = [UIColor colorWithRed:0.973 green:0.58 blue:0.024 alpha:1]; /*#f89406*/
            break;

        case 6:
            mainColor = [UIColor colorWithRed:0.745 green:0.565 blue:0.831 alpha:1]; /*#be90d4*/
            secondaryColor = [UIColor colorWithRed:0.557 green:0.267 blue:0.678 alpha:1]; /*#8e44ad*/
            break;
            
        default:
            mainColor = [UIColor whiteColor];
            secondaryColor = [UIColor whiteColor];
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:mainColor] forKey:@"mainColor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:secondaryColor] forKey:@"secondaryColor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[self.navigationController navigationBar] setBarTintColor:secondaryColor];
    
}

-(IBAction)togglePushNotifications:(id)sender {
    UISwitch *notificationSwitch = (UISwitch *)sender;
    
    /*  Used to test notifications
     UILocalNotification *test = [[UILocalNotification alloc] init];
     [test setAlertTitle:@"Test Notfication"];
     [test setAlertBody:@"This better work"];
     [test setFireDate:[NSDate dateWithTimeIntervalSinceNow:5]];
     [test setTimeZone:[NSTimeZone defaultTimeZone]];
     [[UIApplication sharedApplication] scheduleLocalNotification:test];
     */
    
    if ([notificationSwitch isOn]) {
        // Enable Local Notifications
        [[NSUserDefaults standardUserDefaults] setValue:@1 forKey:@"notifications"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    else {
        // Disable Local Notifications
        [[NSUserDefaults standardUserDefaults] setValue:@0 forKey:@"notifications"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

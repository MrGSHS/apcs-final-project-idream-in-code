//
//  ScheduleListViewController.m
//  BellSchedule
//
//  Created by Rahman on 4/29/16.
//  Copyright © 2016 AliRahman. All rights reserved.
//

#import "ScheduleListViewController.h"
#import "ScheduleManager.h"
#import "SlideNavigationController.h"
#import "SettingsViewController.h"

@interface ScheduleListViewController ()

@end

@implementation ScheduleListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *school = [[NSUserDefaults standardUserDefaults] valueForKey:@"SchoolName"];
    scheduleManager = [[ScheduleManager alloc] initWithSchool:school];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[scheduleManager schedule] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scheduleCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"scheduleCell"];
    }
    NSMutableString *t = [[NSMutableString alloc] init];
    [t appendString:[[[scheduleManager schedule] objectAtIndex: indexPath.row] objectAtIndex:0]];
    [t appendString:@" ("];
    [t appendString:[scheduleManager getClassLengthOf:indexPath.row]];
    [t appendString:@")"];
    [cell.textLabel setText:t];
    return cell;
}

-(IBAction)openSettings {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingsViewController *settings = (SettingsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"settingsVC"];
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:settings withCompletion:^ {
        NSLog(@"Completed popping and switching...");
    }];
}

-(void) updateTable {
    NSString *school = [[NSUserDefaults standardUserDefaults] valueForKey:@"SchoolName"];
    scheduleManager = [[ScheduleManager alloc] initWithSchool:school];
    [table reloadData];
    NSLog(@"Updating schedule list...");
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

//
//  SettingsViewController.m
//  BellSchedule
//
//  Created by Rahman on 5/3/16.
//  Copyright © 2016 AliRahman. All rights reserved.
//

#import "SettingsViewController.h"

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
        return 44;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

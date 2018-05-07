//
//  UITableViewController+EditPhoneViewController.m
//  TrakURep
//
//  Created by Aidan Curtis on 1/1/18.
//  Copyright © 2018 OSX. All rights reserved.
//

#import "VerifyClinicIDViewController.h"
#import "common.h"
#import "MBProgressHUD.h"

@implementation VerifyClinicIDViewController:UITableViewController

-(IBAction)textFieldDidChangeText:(id)sender {
    if ([_phoneInput.text length] > 0) {
        self.navigationItem.title = @"";
    }
    else {
        self.navigationItem.title = @"Enter Your Clinic ID";
    }
}
#pragma mark - Webservice Call

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (IBAction)savePressed:(id)sender {
    
    if([_phoneInput.text isEqualToString: [[NSUserDefaults standardUserDefaults] valueForKey:@"uniqueclinicid"]]){
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UINavigationController *controller = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"SettingsPage"];

        [[self navigationController] showViewController:controller sender:nil];
    }else{
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Incorrect Clinic ID" message:@"Please try again" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];

        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


@end

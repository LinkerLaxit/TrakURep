//
//  UITableViewController+EditPhoneViewController.m
//  TrakURep
//
//  Created by Aidan Curtis on 1/1/18.
//  Copyright © 2018 OSX. All rights reserved.
//

#import "MessageClinicIDViewController.h"
#import "common.h"
#import "MBProgressHUD.h"

@implementation MessageClinicIDViewController:UITableViewController

#pragma mark - Webservice Call

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)savePressed:(id)sender {
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"uniqueclinicid"]);
    NSLog(@"%@", _phoneInput.text);
    if([_phoneInput.text isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"uniqueclinicid"]]){
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UINavigationController *controller = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"MessagesViewController"];
        _phoneInput.text = @"";
        [[self navigationController] showViewController:controller sender:nil];
    }else{ // “Incorrect Clinic ID”

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

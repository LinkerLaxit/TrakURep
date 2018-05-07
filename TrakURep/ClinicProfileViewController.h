//
//  ClinicProfileViewController.h
//  TrakURep
//
//  Created by OSX on 11/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
@interface ClinicProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *img_Profile;
@property (strong, nonatomic) IBOutlet UIButton *btn_Logout;
@property (strong, nonatomic) IBOutlet UIButton *btn_Settings;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Clinic_Name;
@property (strong, nonatomic) IBOutlet UILabel *lbl_email;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Address;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Phone_Number;
@property (strong, nonatomic) IBOutlet UIButton *btn_Dispensed;
@property (strong, nonatomic) IBOutlet UIButton *btn_Received;
@property (strong, nonatomic) IBOutlet UIButton *btn_inventory;
@property (weak, nonatomic) IBOutlet UIButton *btn_Green_Action;
@property (weak, nonatomic) IBOutlet UIButton *btn_Red_Action;
@property (weak, nonatomic) IBOutlet UIButton *btn_Yellow_Action;





- (IBAction)btnLogout_Action:(id)sender;
- (IBAction)btn_Settings_Action:(id)sender;
- (IBAction)btn_Dispensed_Action:(id)sender;
- (IBAction)btn_Received_Action:(id)sender;
- (IBAction)btn_Inventory_Action:(id)sender;


@end

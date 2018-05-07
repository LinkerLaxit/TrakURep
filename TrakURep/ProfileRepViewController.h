//
//  ProfileRepViewController.h
//  TrakURep
//
//  Created by OSX on 08/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
@interface ProfileRepViewController : UIViewController
- (IBAction)btn_VerifiedT_action:(id)sender;
- (IBAction)btn_settings_Action:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *vendid;


@property (weak, nonatomic) IBOutlet UILabel *exp_Date;
@property (strong, nonatomic) IBOutlet UIImageView *img_Profile;
@property (strong, nonatomic) IBOutlet UILabel *lbl_FullName;
@property (strong, nonatomic) IBOutlet UILabel *lbl_CompanyName;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Email;
@property (strong, nonatomic) IBOutlet UILabel *lbl_PhoneNo;

- (IBAction)btn_Logout_Action:(id)sender;
    
@end

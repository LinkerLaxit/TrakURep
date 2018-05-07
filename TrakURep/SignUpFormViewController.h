//
//  SignUpFormViewController.h
//  TrakURep
//
//  Created by OSX on 06/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkEngine.h"
#import "common.h"
@interface SignUpFormViewController : UIViewController<UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BOOL isAgreed;

    NSData *Pimagedata;
    NSMutableArray *arrStates;
    NSString* stateID;
}
@property (strong, nonatomic)  NSString *strUserType;

@property (strong, nonatomic) IBOutlet UIButton *btn_Profile;
@property (strong, nonatomic) IBOutlet UIView *view_Form_1;
@property (strong, nonatomic) IBOutlet UIView *view_Form_2;

@property (strong, nonatomic) IBOutlet UITextField *addr2;
@property (strong, nonatomic) IBOutlet UITextField *addr1;
@property (strong, nonatomic) IBOutlet UITextField *zipCode;
@property (strong, nonatomic) IBOutlet UITextField *city;
@property (strong, nonatomic) IBOutlet UITextField *state;
@property (strong, nonatomic) IBOutlet UITextField *institutionPhnNumber;
@property (strong, nonatomic) IBOutlet UITextField *ClinicName;
@property (strong, nonatomic) IBOutlet UITextField *ConfirmPass;
@property (strong, nonatomic) IBOutlet UITextField *Password;
@property (strong, nonatomic) IBOutlet UITextField *Email;
@property (strong, nonatomic) IBOutlet UITextField *txt_confirmEmail;
@property (strong, nonatomic) IBOutlet UIView *view_AccountVerifyWait;
@property (strong, nonatomic) IBOutlet UITableView *tbl_States;
@property (strong, nonatomic) IBOutlet UILabel *lblTermsCondition;

- (IBAction)btn_Tick_action:(id)sender;
- (IBAction)btn_Continue2_action:(id)sender;
- (IBAction)btn_States_Action:(id)sender;

@end

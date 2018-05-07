//
//  RepSignUpViewController.h
//  TrakURep
//
//  Created by OSX on 07/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
@interface RepSignUpViewController : UIViewController<UIImagePickerControllerDelegate>
{
       NSData *Pimagedata;
       BOOL isAgreed;
       NSMutableArray *arrStates;
       NSString* stateID;
    BOOL isCheckEmail;
}
@property (strong, nonatomic) IBOutlet UITextField *txt_email;
@property (strong, nonatomic) IBOutlet UITextField *txt_password;
@property (strong, nonatomic) IBOutlet UITextField *txt_confirmEmail;
@property (strong, nonatomic) IBOutlet UITextField *txt_CPass;
@property (strong, nonatomic) IBOutlet UIButton *_btn_Profile;
@property (strong, nonatomic) IBOutlet UIScrollView *_view_Form_1;
- (IBAction)btn_continue_Action:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txt_firstN;
@property (strong, nonatomic) IBOutlet UITextField *txt_CompName;
@property (strong, nonatomic) IBOutlet UITextField *txt_LastN;
@property (strong, nonatomic) IBOutlet UITextField *txt_contactNumber;
@property (strong, nonatomic) IBOutlet UITextField *txt_addr1;
@property (strong, nonatomic) IBOutlet UITextField *txt_addr2;
@property (strong, nonatomic) IBOutlet UITextField *txt_zipC;
@property (strong, nonatomic) IBOutlet UITextField *txt_City;
@property (strong, nonatomic) IBOutlet UITextField *txt_State;
@property (strong, nonatomic) IBOutlet UITableView *tbl_States;
@property (strong, nonatomic) IBOutlet UIButton *btn_states;
- (IBAction)btn_continue2_action:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *_view_Form_2;
- (IBAction)btn_Back2_Action:(id)sender;
- (IBAction)btn_back1_Action:(id)sender;
- (IBAction)btn_ProfilePic_Action:(id)sender;
- (IBAction)btn_states_Action:(id)sender;

@end

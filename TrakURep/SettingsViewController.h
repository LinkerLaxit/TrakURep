//
//  SettingsViewController.h
//  TrakURep
//
//  Created by MAC on 01/11/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *view_ChangeEmailPAss;
@property (strong, nonatomic) IBOutlet UIView *view_Clear;
@property (strong, nonatomic) IBOutlet UIView *view_Pic;

@property (strong, nonatomic) IBOutlet UIView *view_Changephone;
@property (strong, nonatomic) IBOutlet UIView *view_Bottom_Rep;
@property (strong, nonatomic) IBOutlet UIView *view_Bottom_Clinic;
@property (strong, nonatomic) IBOutlet UIView *view_Drop;
@property (strong, nonatomic) IBOutlet UITextField *txt_1;
@property (strong, nonatomic) IBOutlet UITextField *txt_2;
- (IBAction)btn_History_Action:(id)sender;
- (IBAction)btn_Message_Action:(id)sender;
- (IBAction)btn_Save_Action:(id)sender;
- (IBAction)btn_TopSave_Action:(id)sender;
- (IBAction)btn_Cancel_Action:(id)sender;
- (IBAction)btn_Back_Action:(id)sender;

@end

//
//  ViewController.h
//  TrakURep
//
//  Created by OSX on 05/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
@interface ViewController : UIViewController
-(BOOL)IsValidEmail:(NSString *)checkString;
- (IBAction)btn_SignIn_Action:(id)sender;
- (IBAction)btn_SignUp_Action:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txt_Email;
@property (strong, nonatomic) IBOutlet UITextField *txt_Password;
@property (strong, nonatomic) IBOutlet UILabel *lblPrivacyPolicy;

@end


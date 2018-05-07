//
//  ForgotPasswordViewController.h
//  TrakURep
//
//  Created by Darshit Vadodaria on 26/02/18.
//  Copyright © 2018 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"

@interface ForgotPasswordViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@end

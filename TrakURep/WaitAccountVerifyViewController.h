//
//  WaitAccountVerifyViewController.h
//  TrakURep
//
//  Created by OSX on 06/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"
#import "common.h"
@interface WaitAccountVerifyViewController : UIViewController<PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate>
{
    BOOL isAccountVerified;
    BOOL isAgreed;
}
@property (strong, nonatomic) IBOutlet UIButton *btn_Back;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Await;
@property (strong, nonatomic) IBOutlet UIImageView *img_Top;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Bottom_text;
@property (strong, nonatomic) IBOutlet UIView *viewPayments;

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, strong, readwrite) NSString *resultText;
@property (nonatomic, strong) NSString * isSingUp;

- (IBAction)btn_PayPAl_Action:(id)sender;
- (IBAction)btn_Tick_Action:(id)sender;
- (IBAction)btn_TapContinue_Action:(id)sender;


@end

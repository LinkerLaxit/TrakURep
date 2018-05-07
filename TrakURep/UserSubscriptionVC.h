//
//  UserSubscriptionVC.h
//  TrakURep
//
//  Created by Vikash Kumar on 09/04/18.
//  Copyright © 2018 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserSubscriptionVC : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *btnRestorePurchase;
@property (strong, nonatomic) IBOutlet UIButton *btnPurchase;
@property (strong, nonatomic) IBOutlet UILabel *lblTermsCondition;
@property (strong, nonatomic) IBOutlet UILabel *lblTermsAndPrivacy;
@property (strong, nonatomic) IBOutlet UITextView *txtvSubcriptionInfo;

@property  Boolean isSingUp;

@end 

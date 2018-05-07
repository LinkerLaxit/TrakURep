//
//  UserSubscriptionVC.m
//  TrakURep
//
//  Created by Vikash Kumar on 09/04/18.
//  Copyright © 2018 OSX. All rights reserved.
//

#import "UserSubscriptionVC.h"
#import "IAPShare.h"
#import "common.h"
#import "MBProgressHUD.h"
#import "TURTabbarViewController.h"

#define AppSharedSecret  @"21fa19dac7074009863d4ea0bbf41bd8"
#define RepUserSubscriptionProductID @"com.trakurep.repusersubscrition"

@interface UserSubscriptionVC ()
{
    
    NSString* productAmount;
    Boolean isAgreed;
}
@end

@implementation UserSubscriptionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    productAmount = @"$499.99";
    isAgreed = false;
    
    _txtvSubcriptionInfo.layer.borderColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.5] CGColor];
    _txtvSubcriptionInfo.layer.borderWidth = 1.0;
    _txtvSubcriptionInfo.contentOffset = CGPointZero;
    
    [self setTermsConditionText];
    [self setPrivacyLabelText];
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(tapLabel:)];
    [_lblTermsAndPrivacy addGestureRecognizer:gest];
    [_lblTermsAndPrivacy setUserInteractionEnabled:YES];

    [self configureIAP];
    
//    NSString *str1 = @"U+20b9U+00a037,900.00";
//    NSString *str2 = @"\u20b9\u00a037,900.00";
//    if([str1 isEqualToString:str2]) {
//
//    } else {
//
//    }
//    NSString *str3 = @"₠ 500";
//    NSDictionary *dic = @{@"hmm":str3};
//
//    NSLog(@"str1 %@", str1);
//    NSLog(@"str2 %@", str2);
//    NSLog(@"str3 %@", dic);

    //[self getReceipt];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _txtvSubcriptionInfo.contentOffset = CGPointZero;
}

-(void)setPrivacyLabelText {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Privacy Policy"
                                                                             attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSBackgroundColorAttributeName: [UIColor clearColor]}]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" & "]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Terms and Conditions"
                                                                             attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSBackgroundColorAttributeName: [UIColor clearColor]}]];
    _lblTermsAndPrivacy.attributedText = attributedString;
}

-(void)setTermsConditionText {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"By signing in, you are agreeing to our "];
    
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Terms and Conditions"
                                                                             attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone), NSBackgroundColorAttributeName: [UIColor clearColor]}]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" and "]];
    
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Privacy Policy"
                                                                             attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone), NSBackgroundColorAttributeName: [UIColor clearColor]}]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@". Please go to our website, "]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"www.trakurep.com"
                                                                             attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone), NSBackgroundColorAttributeName: [UIColor clearColor]}]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" to review the documents. Additionally, by signing in, this confirms that you are up to date with your employers training practices and policies which may include but not limited to product training, credentialing and HIPAA compliance."]];
    _lblTermsCondition.attributedText = attributedString;
}
#pragma mark - IBActions

- (IBAction)btn_Tick_Action:(id)sender {
    UIButton *btn_Tick= (UIButton *)sender;
    if(btn_Tick.isSelected)
    {
        isAgreed = NO;
        btn_Tick.selected = NO;
    }
    else
    {
        isAgreed = YES;
        btn_Tick.selected = YES;
    }
}

- (IBAction)subscribe_btnClicked:(id)sender {
    
    if([self isAgreedWithPolicy])
        [self purchaseOneYearSubscribtion];
}

- (IBAction)restoreSubscribe_btnClicked:(id)sender {
    if([self isAgreedWithPolicy])
        [self resotrePurchase];
}

-(IBAction)backBtnClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(Boolean)isAgreedWithPolicy {
    if(isAgreed) {
        return YES;
    } else {
        [self showErrorAlert:@"You should agree with our policy."];
        return NO;
    }
}

-(void)configureIAP {
    if(![IAPShare sharedHelper].iap) {
        
        NSSet* dataSet = [[NSSet alloc] initWithObjects:RepUserSubscriptionProductID, nil];
        
        [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
        
        //Change production mode to yes before uploading on app store.
        [IAPShare sharedHelper].iap.production = YES;
        
        [self showHud];

    }
    
    [self.btnPurchase setTitle:@"" forState:UIControlStateNormal];

    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response) {
        [self hideHud];
        
        SKProduct* product =[[IAPShare sharedHelper].iap.products objectAtIndex:0];
        NSString *price = [[IAPShare sharedHelper].iap getLocalePrice:product];
        NSLog(@"Price: %@",price);
        NSLog(@"Title: %@",product.localizedTitle);
        productAmount = price;
        NSString *strinPrice = [NSString stringWithString:price];
        NSDictionary* dic = @{@"amount" : strinPrice};
        NSLog(@"%@", dic);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.btnPurchase setTitle:[NSString stringWithFormat:@"Subscribe [%@/year]", price] forState:UIControlStateNormal];
        });
    }];
}


- (void)purchaseOneYearSubscribtion {
    
    [self showHud];
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response) {
         [self hideHud];

         if([IAPShare sharedHelper].iap.products.count > 0) {
            
             SKProduct* product =[[IAPShare sharedHelper].iap.products objectAtIndex:0];
             [self showHud];
             [[IAPShare sharedHelper].iap buyProduct:product onCompletion:^(SKPaymentTransaction* trans){
                 [self hideHud];
                 NSLog(@"Transaction Detali: %@", trans.description);

                 if(trans.error) {
                     [self showErrorAlert:trans.error.localizedDescription];
                     NSLog(@"Transaction Error: %@", trans.error.localizedDescription);
                     
                 } else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
                     [self getReceipt: trans];
                 } else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                     
                 }
                 
             }];
             
         }
     }];

}



-(void)getReceipt:(SKPaymentTransaction*)trans {
    
    [self showHud];
    
    [[IAPShare sharedHelper].iap checkReceipt:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]] AndSharedSecret:AppSharedSecret onCompletion:^(NSString *response, NSError *error) {
       
        [self hideHud];

        if(error) {
            [self showErrorAlert:error.localizedDescription];
            NSLog(@"%@", error.localizedDescription);

        } else {
            
            NSDictionary* json = [IAPShare toJSON:response];

            if([json[@"status"] integerValue]==0)
            {
                SKProduct* product =[[IAPShare sharedHelper].iap.products objectAtIndex:0];
                NSString *price = [[IAPShare sharedHelper].iap getLocalePrice:product];
                productAmount = price;

                [[IAPShare sharedHelper].iap provideContentWithTransaction:trans];
                
                NSArray *latestTransactions = json[@"latest_receipt_info"];
                NSString *latestReceipt = json[@"latest_receipt"];
                [self sendReciptToServer:latestTransactions.lastObject latestReceipt:latestReceipt];
                
            } else if([json[@"status"] integerValue] == 21007) {
                // Important: During apple approval, apple could be using a sandbox itunes account to purchase stuff in prod!
                // We have to check if receipt comes back with status 21007, that means the tester had used a sanbox account and that we have to post the receipt to sandbox url instead of production
                [IAPShare sharedHelper].iap.production = ![IAPShare sharedHelper].iap.production;
                
                [self getReceipt:trans];
            }

            else {
                NSLog(@"Fail");
            }
        }
    }];
}


-(void)resotrePurchase {
    [self showHud];
    [[IAPShare sharedHelper].iap restoreProductsWithCompletion:^(SKPaymentQueue *payment, NSError *error) {
        [self hideHud];

        if(error) {
            NSLog(@"%@", error.localizedDescription);
        }
        for (SKPaymentTransaction *transaction in payment.transactions)
        {
            
            NSString *purchased = transaction.payment.productIdentifier;
            if([purchased isEqualToString: RepUserSubscriptionProductID])
            {
                [self getReceipt:transaction];
                break;
            }
        }
        
    }];
}

- (void)sendReciptToServer:(NSDictionary*)lastTransactionInfo latestReceipt:(NSString*)latestReceipt {
    
    [self showHud];
    NSString *userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"];
    NSString *isSignup = _isSingUp ? @"1" : @"0";
    NSMutableDictionary *dicttemp=[[NSMutableDictionary alloc] init];
    
    [dicttemp setObject:productAmount forKey:@"amount"];
    [dicttemp setObject:userID forKey:@"userid"];
    [dicttemp setObject:isSignup forKey:@"is_signup"];
    [dicttemp setObject:lastTransactionInfo forKey:@"receiptData"];
    [dicttemp setObject:latestReceipt forKey:@"latest_receipt"];
    
    NSString *stringUrl = [HostName stringByAppendingString:kUpdatePayments];
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dicttemp options:0 error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"AccssToken"] forHTTPHeaderField:@"AuthToken"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    NSURLRequest *requestURL = [[NSURLRequest alloc] init];
    requestURL = request.copy;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];

    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        if(data.length > 0) {
            NSDictionary *dicYourResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            
            NSLog(@"%@", dicYourResponse);
            if([[dicYourResponse valueForKey:@"status"] isEqualToString:@"1"]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"active" forKey:@"user_status"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController pushViewController:[[TURTabbarViewController alloc] initWithUserType:@"RepUser"] animated:YES];
                });
                
            } else if([[dicYourResponse valueForKey:@"status"] isEqualToString:@"2"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }
            
            [self showErrorAlert:dicYourResponse[@"message"]];

        }
        
        [self hideHud];

    }];
    [task resume];

}

-(void)showHud {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
}

-(void)hideHud {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}


-(void)showErrorAlert:(NSString*)message {
    UIAlertController *popup=[UIAlertController alertControllerWithTitle:@"TrakURep" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* CancelButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       
                                   }];
    
    [popup addAction:CancelButton];
    dispatch_async(dispatch_get_main_queue(), ^{

        [self presentViewController:popup animated:YES completion:nil];
    });
}


-(void)tapLabel:(UITapGestureRecognizer*)gesture {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"Privacy Policy & Terms and Conditions"];
    NSRange termsRange = [text.string rangeOfString:@"Terms and Conditions"];
    NSRange privacyRange = [text.string rangeOfString:@"Privacy Policy"];
    NSRange webRange = [text.string rangeOfString:@"www.trakurep.com"];
    
    if([self isTappedAtTextInLabel:_lblTermsAndPrivacy gesture:gesture textRange:termsRange]) {
        
        NSLog(@"Terms and Conditions");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:termsConditionUrl]];
        
    } else if([self isTappedAtTextInLabel:_lblTermsAndPrivacy gesture:gesture textRange:privacyRange]) {
        
        NSLog(@"Privacy Policy");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:privacyPolicyUrl]];

        
    } else if([self isTappedAtTextInLabel:_lblTermsAndPrivacy gesture:gesture textRange:webRange]) {
        
        NSLog(@"www.trakurep.com");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.trakurep.com/"]];

    } else {
        NSLog(@"Other location tapped");
        
    }
}

-(Boolean)isTappedAtTextInLabel:(UILabel*)lable gesture:(UIGestureRecognizer*)gesture textRange:(NSRange)targetRange {
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc]init];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:lable.attributedText];
    
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    
    textContainer.lineFragmentPadding = 0.0;
    textContainer.lineBreakMode = lable.lineBreakMode;
    textContainer.maximumNumberOfLines = lable.numberOfLines;
    CGSize labelSize = lable.bounds.size;
    textContainer.size = labelSize;
    
    CGPoint locationOfTouchInLabel = [gesture locationInView:lable];
    NSUInteger indexOfCharacter = [layoutManager characterIndexForPoint:locationOfTouchInLabel inTextContainer:textContainer fractionOfDistanceBetweenInsertionPoints:nil];
    
//    NSLog(@"%i", indexOfCharacter);
    return NSLocationInRange(indexOfCharacter, targetRange);
}

@end




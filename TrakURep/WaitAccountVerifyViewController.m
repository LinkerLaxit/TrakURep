//
//  WaitAccountVerifyViewController.m
//  TrakURep
//
//  Created by OSX on 06/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import "WaitAccountVerifyViewController.h"
#import "TURTabbarViewController.h"

// Set the environment:
// - For live charges, use PayPalEnvironmentProduction (default).
// - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
// - For testing, use PayPalEnvironmentNoNetwork.
#define kPayPalEnvironment PayPalEnvironmentSandbox

@interface WaitAccountVerifyViewController ()
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@end

@implementation WaitAccountVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //if(isAccountVerified)
    {
//        _btn_Back.hidden=TRUE;
        _img_Top.image=[UIImage imageNamed:@"Whitetick"];
        _lbl_Await.text = @"ACCOUNT VERIFIED" ;
        _lbl_Bottom_text.text = @"Tap anywhere to continue" ;
    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"UserType"] isEqualToString:@"Rep"]) {
        _viewPayments.hidden=FALSE;
    } else {
        _viewPayments.hidden=YES;
    }
    // Do any additional setup after loading the view.
    
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = NO;
    _payPalConfig.merchantName = @"TrakURep, Inc.";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    // Setting the languageOrLocale property is optional.
    //
    // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
    // its user interface according to the device's current language setting.
    //
    // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
    // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
    // to use that language/locale.
    //
    // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    
    // Setting the payPalShippingAddressOption property is optional.
    //
    // See PayPalConfiguration.h for details.
    
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
    // Do any additional setup after loading the view, typically from a nib.
    
    //self.successView.hidden = YES;
    
    // use default environment, should be Production in real life
    self.environment = kPayPalEnvironment;
    
    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
    
    
//    UIApplication *app = [UIApplication sharedApplication];
//    CGFloat statusBarHeight = app.statusBarFrame.size.height;
//    
//    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
//    statusBarView.backgroundColor  =  [UIColor colorWithRed:0.1412 green:0.4706 blue:0.6588 alpha:1];
//    [self.view addSubview:statusBarView];
}
//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden: TRUE];
    // Preconnect to PayPal early
    [self setPayPalEnvironment:self.environment];
}

- (void)setPayPalEnvironment:(NSString *)environment {
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btn_Back_Action:(id)sender {
    if ([_isSingUp isEqualToString:@"0"]) {
        [self.navigationController setNavigationBarHidden: FALSE];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (IBAction)btn_PayPAl_Action:(id)sender {
    if(isAgreed)
    {
      // go to paypal screen
        [self pay];
    }
    else
    {
        UIAlertController *popup=[UIAlertController alertControllerWithTitle:@"Alert!" message:@"Please accept to the Terms of services." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* CancelButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           
                                       }];
        
        
        [popup addAction:CancelButton];
        [self presentViewController:popup animated:YES completion:nil];

    }
    
}

- (IBAction)btn_Tick_Action:(id)sender {
    UIButton *btn_Tick= (UIButton *)sender;
    if(btn_Tick.isSelected)
    {
        isAgreed=FALSE;
        btn_Tick.selected=FALSE;
    }
    else
    {
        isAgreed=TRUE;
        btn_Tick.selected=TRUE;
    }
}

- (IBAction)btn_TapContinue_Action:(id)sender {
    
      [self.navigationController pushViewController:[[TURTabbarViewController alloc] initWithUserType:@"ClinicUser"] animated:YES];
}



#pragma mark - Receive Single Payment

- (void)pay {
    // Remove our last completed payment, just for demo purposes.
    self.resultText = nil;
    
    // Note: For purposes of illustration, this example shows a payment that includes
    //       both payment details (subtotal, shipping, tax) and multiple items.
    //       You would only specify these if appropriate to your situation.
    //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
    //       and simply set payment.amount to your total charge.
    
    // Optional: include multiple items
    PayPalItem *item1 = [PayPalItem itemWithName:@"TrakURep Apps Payment"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"499"]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00037"];
 
    NSArray *items = @[item1];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.0"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.0"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = @"TrakURep App's Payment";
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    self.resultText = [completedPayment description];
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
  

}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    self.resultText = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    NSLog(@"Access Token = %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"AccssToken"]);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone=[NSTimeZone localTimeZone];
    
    //value = 364 days // for resolving issue of exp_date
    //One year = today + 364 days
    NSDate *newDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:364 toDate:[NSDate date] options:0];

    NSDateFormatter *dtFormat=[[NSDateFormatter alloc] init];
    [dtFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *strDate=[dtFormat stringFromDate:newDate];
    
    NSMutableDictionary *dicttemp=[[NSMutableDictionary alloc] init];
   
    if(_isSingUp == nil || ![_isSingUp isEqualToString:@"0"]){
        _isSingUp = @"1";
        [dicttemp setObject:strDate forKey:@"payment_expdate"];
    }
    
    [dicttemp setObject:@"1" forKey:@"payment_status"];
    [dicttemp setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
    [dicttemp setObject:completedPayment.paymentDetails.tax forKey:@"tax"];
    [dicttemp setObject:completedPayment.shortDescription forKey:@"shortDescription"];
    [dicttemp setObject:completedPayment.amount forKey:@"amount"];
    [dicttemp setObject:_isSingUp forKey:@"is_signup"];

    NSString *stringUrl = [HostName stringByAppendingString:kUpdatePayments];
    //   stringUrl = [stringUrl stringByAddingPercentEncodingWithAllowedCharacters:URLHostAllowedCharacterSet];
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    //NSString *wsAuth = [NSString stringWithFormat:@"Basic \%@", [[[[NSUserDefaults standardUserDefaults] valueForKey:@"AccssToken"] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0]];

    NSData *postData = [NSJSONSerialization dataWithJSONObject:dicttemp options:0 error:nil]; //[post dataUsingEncoding:NSASCIIStringEncoding];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"AccssToken"] forHTTPHeaderField:@"AuthToken"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    NSURLRequest *requestURL = [[NSURLRequest alloc] init];
    requestURL = request.copy;
    
    
    // NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil){
             
             NSDictionary *dicYourResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             NSLog(@"%@",dicYourResponse);
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 if(![[dicYourResponse valueForKey:@"status"] isEqualToString:@"0"])
                 {
                     [[NSUserDefaults standardUserDefaults] setObject:@"active" forKey:@"user_status"];
                     if ([_isSingUp isEqualToString:@"0"]) {
                         [self.navigationController setNavigationBarHidden: FALSE];
                         [self.navigationController popToRootViewControllerAnimated:YES];
                     }
                     else{
                         [self.navigationController pushViewController:[[TURTabbarViewController alloc] initWithUserType:@"RepUser"] animated:YES];
                     }
                     
                 } else {
                     [self.navigationController popToRootViewControllerAnimated:YES];
                     [self showErrorAlert:[dicYourResponse valueForKey:@"message"]];
                     
                 }
             });
            
         }
         else{
             [self showErrorAlert:[connectionError description]];
         }
     }];

    
}

-(void)showErrorAlert:(NSString*)message {
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"TrakURep" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
@end

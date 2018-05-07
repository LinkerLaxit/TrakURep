//
//  ViewController.m
//  TrakURep
//
//  Created by OSX on 05/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import "ViewController.h"
#import "NetworkEngine.h"
#import "MBProgressHUD.h"
#import "CustomTabBar.h"
#import "CustomRepTabBar.h"
#import "TURTabbarViewController.h"
#import "UserSubscriptionVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.txt_Email.attributedPlaceholder = str;
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.txt_Password.attributedPlaceholder = str1;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}

-(void)dismissKeyboard {
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [_txt_Email resignFirstResponder];
    [_txt_Password resignFirstResponder];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btn_SignIn_Action:(id)sender {
    [_txt_Email resignFirstResponder];
    [_txt_Password resignFirstResponder];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    if(_txt_Email.text.length>0 && _txt_Password.text.length>0)
    {
        if(![self IsValidEmail:_txt_Email.text])
        {
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Error!" message:@"Please enter a valid email." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //Handle your yes please button action here
                                        }];
            
            
            [alert addAction:yesButton];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:_txt_Email.text forKey:@"email"];
            [dict setObject:_txt_Password.text forKey:@"password"];
            [dict setObject:@"2" forKey:@"user_type_id"];
            NSLog(@"DT %@" , [[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceToken"] );
            if([[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceToken"])
                [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceToken"] forKey:@"device_id"];
            //[dict setObject:@"cSkGau_Eb_o:APA91bFTUNtu3UUUegTM48USkuxDNP9MOClFlmR9ZpJlP5MjBRCQJCYFXxwM8SrM0U4qeRNufTQHTuaUZAOSt_PA-n6VidapGDfVXbPHPn8XL_kxh7G-TIdzjAf69bDsPbj248UNflWz" forKey:@"device_id"];
            
            

            [self WebResponse:dict WebserviceName:kGetLoginResponse];
            
        }
    }
    else
    {
        if(_txt_Email.text.length==0)
        {
            
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Error!" message:@"Please enter email." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //Handle your yes please button action here
                                        }];
            
            
            [alert addAction:yesButton];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if(![self IsValidEmail:_txt_Email.text])
        {
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Error!" message:@"Please enter a valid email." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //Handle your yes please button action here
                                        }];
            
            
            [alert addAction:yesButton];
            
            [self presentViewController:alert animated:YES completion:nil];
        }

        else if (_txt_Password.text.length==0)
        {
           UIAlertController *alert =  [UIAlertController alertControllerWithTitle:@"Error!" message:@"Please enter password." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //Handle your yes please button action here
                                        }];
            
            
            [alert addAction:yesButton];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (IBAction)btn_SignUp_Action:(id)sender {
 self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showSubscriptionScreen"]) {
        UserSubscriptionVC *vc = segue.destinationViewController;
        vc.isSingUp = NO;
    }
}

#pragma mark -  email validation
-(BOOL)IsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
#pragma mark - textfeild delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [textField resignFirstResponder];
    return TRUE;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //self.view.frame = CGRectMake(self.view.frame.origin.x, -150, self.view.frame.size.width, self.view.frame.size.height);
}
#pragma Mark - Webservice call
-(void)WebResponse:(NSDictionary *)Params WebserviceName:(NSString *)WebserviceName
{
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *stringUrl = [HostName stringByAppendingString:WebserviceName];
    //   stringUrl = [stringUrl stringByAddingPercentEncodingWithAllowedCharacters:URLHostAllowedCharacterSet];
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:Params options:0 error:nil]; //[post dataUsingEncoding:NSASCIIStringEncoding];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    // NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
          [MBProgressHUD hideHUDForView:self.view animated:YES];
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *dicYourResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             NSLog(@"%@",dicYourResponse);
             if (dicYourResponse == nil) {
                 
                 return;
             }
             if([[dicYourResponse valueForKey:@"status"] isEqualToString:@"0"])
             {
                 UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Failed!" message:[dicYourResponse valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction* yesButton = [UIAlertAction
                                             actionWithTitle:@"OK"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action) {
                                                 //Handle your yes please button action here
                                             }];
                 
                 
                 [alert addAction:yesButton];
                 
                 [self presentViewController:alert animated:YES completion:nil];

             }
             else
             {
                 if([[[dicYourResponse valueForKey:@"data"] valueForKey:@"status"] isEqualToString:@"0"])
                 {
                     if([[[dicYourResponse valueForKey:@"data"] valueForKey:@"user_type_id"] isEqualToString:@"3"])
                         [[NSUserDefaults standardUserDefaults] setObject:@"Clinic" forKey:@"UserType"];
                     else
                         [[NSUserDefaults standardUserDefaults] setObject:@"Rep" forKey:@"UserType"];

                     [[NSUserDefaults standardUserDefaults] setObject:[[dicYourResponse valueForKey:@"data"] valueForKey:@"userid"] forKey:@"UserId"];
                     [[NSUserDefaults standardUserDefaults] setObject:[[dicYourResponse valueForKey:@"data"] valueForKey:@"access_token"] forKey:@"AccssToken"];
                     NSLog(@"Access Token - %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"AccssToken"]);
                     _txt_Email.text=@"";
                     _txt_Password.text=@"";
                     
                     [[NSUserDefaults standardUserDefaults] setObject:@"active" forKey:@"user_status"];
                     
                     if([[[dicYourResponse valueForKey:@"data"] valueForKey:@"user_type_id"] isEqualToString:@"2"]) {
                         
                         //CustomRepTabBar* vc = [[CustomRepTabBar alloc] init];
                         id tabbar = [[TURTabbarViewController alloc]initWithUserType:@"RepUser"];
                         
                         [self.navigationController pushViewController:tabbar animated:NO];
                         
                     } else{
                         
                         id tabbar = [[TURTabbarViewController alloc]initWithUserType:@"ClinicUser"];
                         [self.navigationController pushViewController:tabbar animated:NO];
                     }
                 }
                else
                {
                    //                    id message = "Your subscription has ended. Please make the payment to use your app account.";
                    NSString* message = dicYourResponse[@"message"];
                    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Alert!" message:message preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* yesButton = [UIAlertAction
                                                actionWithTitle:@"OK"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action) {
                                                    
                                                    //navigate to payment screen if subsription expired
                                                    if([[[dicYourResponse valueForKey:@"data"] valueForKey:@"status"] isEqualToString:@"1"]) {
                                                        [[NSUserDefaults standardUserDefaults] setObject:@"Rep" forKey:@"UserType"];
                                                        [[NSUserDefaults standardUserDefaults] setObject:[[dicYourResponse valueForKey:@"data"] valueForKey:@"userid"] forKey:@"UserId"];
                                                        [[NSUserDefaults standardUserDefaults] setObject:[[dicYourResponse valueForKey:@"data"] valueForKey:@"access_token"] forKey:@"AccssToken"];
                                                        [[NSUserDefaults standardUserDefaults] setObject:@"inactive" forKey:@"user_status"];
                                                        
                                                        [self performSegueWithIdentifier:@"showSubscriptionScreen" sender:self];
                                                    }
                                                }];
                    [alert addAction:yesButton];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }
             }
         }
         else{
             UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Error!" message:[connectionError description] preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* yesButton = [UIAlertAction
                                         actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             //Handle your yes please button action here
                                         }];
             [alert addAction:yesButton];
             
             [self presentViewController:alert animated:YES completion:nil];

         }
     }];
    
}


-(void)tapLabel:(UITapGestureRecognizer*)gesture {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"Terms and Condition && Privacy Policy"];
    NSRange termsRange = [text.string rangeOfString:@"Terms and Condition"];
    NSRange privacyRange = [text.string rangeOfString:@"Privacy Policy"];
    
    if([self isTappedAtTextInLabel:_lblPrivacyPolicy gesture:gesture textRange:termsRange]) {
        NSLog(@"Terms condition tapped");
    } else if([self isTappedAtTextInLabel:_lblPrivacyPolicy gesture:gesture textRange:privacyRange]) {
        NSLog(@"Privacy Policy tapped");

    } else {
        NSLog(@"Other location tapped");

    }
    //if([gesture ])
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
    
    return NSLocationInRange(indexOfCharacter, targetRange);
}

@end

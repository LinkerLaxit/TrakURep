//
//  ProfileRepViewController.m
//  TrakURep
//
//  Created by OSX on 08/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import "ProfileRepViewController.h"
#import "MBProgressHUD.h"
#import "ViewController.h"
#import "UIImageView+WebCache.h"

@interface ProfileRepViewController ()
{
    BOOL isLogout;

}

#define numberOfDays  30
@end

@implementation ProfileRepViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _img_Profile.layer.borderWidth=1.0 ;
    _img_Profile.layer.borderColor=[UIColor lightGrayColor].CGColor;

    isLogout= false;
//    NSMutableDictionary *dictParams=[[NSMutableDictionary alloc] init];
//    [dictParams setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
//    //[self WebResponse:dictParams WebserviceName:kGetProfileUrl];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    _img_Profile.layer.borderWidth=1.0 ;
    _img_Profile.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    isLogout= false;
    NSMutableDictionary *dictParams=[[NSMutableDictionary alloc] init];
    [dictParams setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
    [self WebResponse:dictParams WebserviceName:kGetProfileUrl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_VerifiedT_action:(id)sender {
}

- (IBAction)btn_settings_Action:(id)sender {
}


#pragma Mark - Webservice call
-(void)WebResponse:(NSDictionary *)Params WebserviceName:(NSString *)WebserviceName
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *stringUrl = [HostName stringByAppendingString:WebserviceName];
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    if(Params)
    {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:Params options:0 error:nil]; //[post dataUsingEncoding:NSASCIIStringEncoding];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"AccssToken"] forHTTPHeaderField:@"AuthToken"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
    }
    
    
    NSURLRequest *requestURL = [[NSURLRequest alloc] init];
    requestURL = request.copy;
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSLog(@"%@",[[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8]);

         if ([WebserviceName isEqualToString:kGetProfileUrl] && data.length > 0 && connectionError == nil)
         {
   
             NSDictionary *dicYourResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             if([[dicYourResponse valueForKey:@"status"] isEqualToString:@"1"])
             {
                 NSLog(@"%@", dicYourResponse);

                 [_img_Profile sd_setImageWithURL:[[dicYourResponse valueForKey:@"data"] valueForKey:@"image"]];

                 _lbl_Email.text=[[dicYourResponse valueForKey:@"data"] valueForKey:@"email"];
                 _lbl_FullName.text=[[[dicYourResponse valueForKey:@"data"] valueForKey:@"fname"] stringByAppendingFormat:@" %@",[[dicYourResponse valueForKey:@"data"] valueForKey:@"lname"]];
                 _lbl_CompanyName.text = [[dicYourResponse valueForKey:@"data"] valueForKey:@"company_name"];
                 [self.navigationItem setTitle:[[dicYourResponse valueForKey:@"data"] valueForKey:@"company_name"]];
                _lbl_PhoneNo.text = [[dicYourResponse valueForKey:@"data"] valueForKey:@"phone"];
                 _vendid.text = [NSString stringWithFormat:@"Rep ID: %@",[[dicYourResponse valueForKey:@"data"] valueForKey:@"rep_id"]]; 
                 
                 _exp_Date.text = [@"Expiration Date: " stringByAppendingString:[[dicYourResponse valueForKey:@"data"] valueForKey:@"payment_expdate"]];
                 
                 [[NSUserDefaults standardUserDefaults] setObject:[dicYourResponse valueForKey:@"data"] forKey:@"UserDetails"];
                 [self checkExpDate:dicYourResponse[@"data"]];
                 
             } else {
                 //logout if payment exp error occur.
                 if ([[dicYourResponse valueForKey:@"status"] isEqualToString:@"2"]) {
                     [self doLogout];
                 }
                 [self showAlert:dicYourResponse[@"message"]];

             }
         } else {
             
         }
     }];
    
}

-(void)checkExpDate:(NSDictionary*)dictUser{
    
    NSString *strExpDate = [dictUser valueForKey:@"payment_expdate"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *expDate  = [dateFormatter dateFromString:strExpDate];
    
    NSTimeInterval difference = [expDate timeIntervalSinceDate:[NSDate date]];
    if(difference < (86400*numberOfDays))
    {
        if (difference > 0){
            NSLog(@"Diff is less than 30");
            NSDate *dateOldAlert = [[NSUserDefaults standardUserDefaults]valueForKey:@"oldAlertTime"];
            if(dateOldAlert != nil){
                NSTimeInterval oldAlertdifference = [[NSDate date] timeIntervalSinceDate:dateOldAlert];
                if(oldAlertdifference > 86400)
                {
                    [self showExpiryAlert];
                }
            }
            else{
                [self showExpiryAlert];
            }
        }
        else{
           // [self doLogout];
        }
       
    }
    
}



-(void)showExpiryAlert{
    [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:@"oldAlertTime"];
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Alert!" message:@"Your subscription to TrakURep™ will expire within 30 days.  To prevent any interruption of service, please go to Settings to renew your subscription before it expires." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                }];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)showAlert:(NSString*)message {
    
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Alert!" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                               }];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)btn_Logout_Action:(id)sender {
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Alert!" message:@"Are you sure you want to logout." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                   
                                    [self doLogout];
                                    
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle your yes please button action here
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];


}
-(void)doLogout{
    isLogout= true;
    
    NSMutableDictionary *dictParams=[[NSMutableDictionary alloc] init];
    [dictParams setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
    [self WebResponse:dictParams WebserviceName:kLogout];
    
    NSMutableDictionary *dc =[[NSMutableDictionary alloc] init];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"UserType"];
    [[NSUserDefaults standardUserDefaults] setValue:dc forKey:@"UserDetails"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"dispensed"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"received"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Inventory"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UsersMsg"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"AccssToken"];
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"RCount"];
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"DCount"];
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"ICount"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"oldAlertTime"];
    [[NSUserDefaults standardUserDefaults] setObject:@"1234" forKey:@"uniqueclinicid"];

    [[NSUserDefaults standardUserDefaults] synchronize];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    UINavigationController *controller = (UINavigationController*)[mainStoryboard
                                                                   instantiateViewControllerWithIdentifier: @"NavProfile"];
    
    [[self navigationController] showViewController:controller sender:nil];
}
    @end

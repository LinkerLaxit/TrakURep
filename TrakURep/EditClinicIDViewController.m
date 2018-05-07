//
//  UITableViewController+EditPhoneViewController.m
//  TrakURep
//
//  Created by Aidan Curtis on 1/1/18.
//  Copyright © 2018 OSX. All rights reserved.
//

#import "EditClinicIDViewController.h"
#import "common.h"
#import "MBProgressHUD.h"

@implementation EditClinicIDViewController:UITableViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    if(_isUpdateRepID) {
        [self.navigationItem setTitle:@"Update Rep ID"];
        [_textField setPlaceholder:@"Enter New Rep ID"];
    } else {
        [self.navigationItem setTitle:@"Update Clinic ID"];
        [_textField setPlaceholder:@"Enter New Clinic ID"];
        _hintLabel.text = @"";
    }
}

#pragma mark -


#pragma mark -

- (IBAction)savePressed:(id)sender {
    NSString* text = [_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(text.length>0){
        if(_isUpdateRepID) {
            [self updateRepID];
        } else {
            [self updateClinicID];
        }
    }
    else{
        
        NSString* message = _isUpdateRepID ? @"Please enter a valid Rep ID." : @"Please enter a vaild Clinic ID.";
        [self showErrorAlert:message];
    }
    
    
}


-(void)updateClinicID {
    NSString* text = [_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    [[NSUserDefaults standardUserDefaults] setValue:text forKey:@"uniqueclinicid"];
    [self showAlert:@"Clinic ID saved successfully."];
}

-(void)updateRepID {
    
    NSString* text = [_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([self isValidRepID:text]) {
        NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserDetails"] mutableCopy];
        [dict setObject:text forKey:@"rep_id"];
        [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
        [self WebResponse:dict WebserviceName:kEditProfile];
    } else {
        [self showErrorAlert:@"Your Rep ID password can be as large as 10 characters with capital letters, numbers, and special characters."];
    }
}

-(BOOL)isValidRepID:(NSString *)repID
{
    NSString *stricterFilterString = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@#$!%*?&])[A-Za-z\\d$#@$!%*?&]{10,}";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    return [passwordTest evaluateWithObject:repID];
}

-(void)showAlert:(NSString*)message {
    UIAlertController *popup=[UIAlertController alertControllerWithTitle:@"Update" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [self.navigationController popViewControllerAnimated:YES];
                               }];
    
    
    [popup addAction:okButton];
    
    [self presentViewController:popup animated:YES completion:nil];

}


-(void)showErrorAlert:(NSString*)message {
    UIAlertController *popup=[UIAlertController alertControllerWithTitle:@"Error!" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                               }];
    
    
    [popup addAction:okButton];
    
    [self presentViewController:popup animated:YES completion:nil];
    
}

-(void)WebResponse:(NSDictionary *)Params WebserviceName:(NSString *)WebserviceName
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *stringUrl = [HostName stringByAppendingString:WebserviceName];
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
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
    
    
    // NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSLog(@"data: %@",[[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8]);
         
         if (data.length > 0 && connectionError == nil)
         {
             NSLog(@"%@",[[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8]);
             NSDictionary *dicYourResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             
             if (dicYourResponse) {
                 if(![[dicYourResponse valueForKey:@"status"] isEqualToString:@"0"])
                 {
                     if(ISUPdate) {
                         ISUPdate =FALSE;
                         NSMutableDictionary *dictParams=[[NSMutableDictionary alloc] init];
                         [dictParams setObject:[[dicYourResponse valueForKey:@"data"] valueForKey:@"userid"] forKey:@"userid"];
                         [self WebResponse:dictParams WebserviceName:kGetProfileUrl];
                     } else {
                         [[NSUserDefaults standardUserDefaults] setObject:[dicYourResponse valueForKey:@"data"] forKey:@"UserDetails"];
                         [[self navigationController] popToRootViewControllerAnimated:YES];
                         [self showAlert:@"Your Rep ID updated successfully."];
                     }
                 }else{
                     UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"That Rep ID is taken" message:[dicYourResponse valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
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
         
     }];
    
    
}

@end

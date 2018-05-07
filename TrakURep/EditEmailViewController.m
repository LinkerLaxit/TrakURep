//
//  UITableViewController+EditPhoneViewController.m
//  TrakURep
//
//  Created by Aidan Curtis on 1/1/18.
//  Copyright © 2018 OSX. All rights reserved.
//

#import "EditEmailViewController.h"
#import "common.h"
#import "MBProgressHUD.h"

@implementation EditEmailViewController:UITableViewController

#pragma mark - Webservice Call

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
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
         
         if (data.length > 0 && connectionError == nil)
         {
             NSLog(@"%@",[[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8]);
             NSDictionary *dicYourResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             NSLog(@"%@",dicYourResponse);
             if(dicYourResponse) {
                 if([[dicYourResponse valueForKey:@"status"] isEqualToString:@"1"])
                 {
                     if(ISUPdate) {
                         ISUPdate =FALSE;
                         NSMutableDictionary *dictParams=[[NSMutableDictionary alloc] init];
                         [dictParams setObject:[[dicYourResponse valueForKey:@"data"] valueForKey:@"userid"] forKey:@"userid"];
                         //[self WebResponse:dictParams WebserviceName:kGetProfileUrl];
                         [[self navigationController] popToRootViewControllerAnimated:YES];
                     }
//                     } else {
//                         [[NSUserDefaults standardUserDefaults] setObject:[dicYourResponse valueForKey:@"data"] forKey:@"UserDetails"];
//                         [[self navigationController] popToRootViewControllerAnimated:YES];
//                     }
                 } else {
                     [self showAlert:dicYourResponse[@"message"]];
                 }
             }
             
         }
         else
         {
             
         }
     }];
}


-(void)showAlert:(NSString*)message {
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



- (IBAction)savePressed:(id)sender {
    
    NSString* email = [_txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* emailConfirm = [_txtEmailConfirm.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    ISUPdate = TRUE;
    NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserDetails"] mutableCopy];
    
    if((email.length>0) && ([self IsValidEmail:email])) {
        
        if([email isEqualToString:emailConfirm]) {
            
            [dict setObject:email forKey:@"email"];
            
            [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
            
            [self WebResponse:dict WebserviceName:kEditProfile];

        }
        else
            [self showAlert:@"Email and confirm email does not match."];
    }
    else {
        [self showAlert:@"Please enter an valid email address."];
    }
}

#pragma mark -  email/password validation
-(BOOL)IsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
@end

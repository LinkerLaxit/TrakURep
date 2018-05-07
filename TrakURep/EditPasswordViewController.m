//
//  UITableViewController+EditPhoneViewController.m
//  TrakURep
//
//  Created by Aidan Curtis on 1/1/18.
//  Copyright © 2018 OSX. All rights reserved.
//

#import "EditPasswordViewController.h"
#import "common.h"
#import "MBProgressHUD.h"

@implementation EditPasswordViewController:UITableViewController

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
                     }
                 }
             }
         }
         else
         {
             
         }
     }];
}






- (IBAction)savePressed:(id)sender {
    
    if([_phoneInput.text isEqualToString:_phoneConfirm.text] && [self isValidPassword:_phoneInput.text]){
        
        NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserDetails"] mutableCopy];
        ISUPdate = TRUE;
        [dict setObject:_phoneInput.text forKey:@"password"];
        [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
        [self WebResponse:dict WebserviceName:kEditProfile];
    }
    else
    {
        if(![_phoneInput.text isEqualToString:_phoneConfirm.text]){
            [self showErrorAlert:@"Password and confirm password does not match."];
        }
        if(![self isValidPassword:_phoneInput.text]){
            [self showErrorAlert:@"Your password must include at least 10 characters, one capital letter, one number, and one special character."];
        }
    }
}


-(BOOL)isValidPassword:(NSString *)passwordString
{
    NSString *stricterFilterString = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@#$!%*?&])[A-Za-z\\d$#@$!%*?&]{10,}";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    return [passwordTest evaluateWithObject:passwordString];
}

-(void)showErrorAlert:(NSString*)message {
    UIAlertController *popup=[UIAlertController alertControllerWithTitle:@"Error!" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* CancelButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       
                                   }];
    
    
    [popup addAction:CancelButton];
    [self presentViewController:popup animated:YES completion:nil];
}


@end

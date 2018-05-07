//
//  UITableViewController+EditNameViewController.m
//  TrakURep
//
//  Created by Aidan Curtis on 1/1/18.
//  Copyright © 2018 OSX. All rights reserved.
//

#import "EditNameViewController.h"
#import "common.h"
#import "MBProgressHUD.h"

@implementation EditNameViewController:UITableViewController

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
             
             if (dicYourResponse){
                 if(![[dicYourResponse valueForKey:@"status"] isEqualToString:@"0"])
                 {
                     if(ISUPdate) {
                         ISUPdate =FALSE;
                         [[self navigationController] popToRootViewControllerAnimated:YES];

//                         NSMutableDictionary *dictParams=[[NSMutableDictionary alloc] init];
//                         [dictParams setObject:[[dicYourResponse valueForKey:@"data"] valueForKey:@"userid"] forKey:@"userid"];
//                         [self WebResponse:dictParams WebserviceName:kGetProfileUrl];
                     } else {
//                         [[NSUserDefaults standardUserDefaults] setObject:[dicYourResponse valueForKey:@"data"] forKey:@"UserDetails"];
//                         [[self navigationController] popToRootViewControllerAnimated:YES];
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
    
    ISUPdate = TRUE;
    NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserDetails"] mutableCopy];
    
    if(_nameInput.text.length>0)
        [dict setObject:_nameInput.text forKey:@"company_name"];
    
    id userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"];
    if(userId) {
        [dict setValue:userId forKey:@"userid"];
        
        [self WebResponse:dict WebserviceName:kEditProfile];
    }
}


@end

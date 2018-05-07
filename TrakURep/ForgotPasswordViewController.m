//
//  ForgotPasswordViewController.m
//  TrakURep
//
//  Created by Darshit Vadodaria on 26/02/18.
//  Copyright © 2018 OSX. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "NetworkEngine.h"
#import "MBProgressHUD.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btn_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btn_Send_Email:(id)sender {
    
    [_txtEmail resignFirstResponder];
    if(_txtEmail.text.length>0)
    {
        if(![self IsValidEmail:_txtEmail.text])
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
            [dict setObject:_txtEmail.text forKey:@"email"];
            [self WebResponse:dict WebserviceName:kForgotPassword];
            
        }
    }
    else
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
}

#pragma Mark - Webservice call
-(void)WebResponse:(NSDictionary *)Params WebserviceName:(NSString *)WebserviceName
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *stringUrl = [HostName stringByAppendingString:WebserviceName];
    
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
                 UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Success!" message:[dicYourResponse valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction* yesButton = [UIAlertAction
                                             actionWithTitle:@"OK"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action) {
                                                 [self.navigationController popViewControllerAnimated:TRUE];
                                             }];
                 
                 
                 [alert addAction:yesButton];
                 
                 [self presentViewController:alert animated:YES completion:nil];
                 
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

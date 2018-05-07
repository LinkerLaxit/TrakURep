//
//  UITableViewController+NewSettingsController.m
//  TrakURep
//
//  Created by Aidan Curtis on 12/31/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import "NewRepSettingsController.h"
#import "MBProgressHUD.h"
#import "common.h"
#import "EditClinicIDViewController.h"
#import "UIImage+fixOrientation.h"
#import "WaitAccountVerifyViewController.h"

@interface NewRepSettingsController() <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@end

@implementation NewRepSettingsController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"UpdateRepID"]) {
        EditClinicIDViewController* vc = segue.destinationViewController;
        vc.isUpdateRepID = YES;
    }
}


-(IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo{
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    UIImage* img = [image fixOrientation];

    Pimagedata = UIImageJPEGRepresentation(img, 0.3);
    
    [self saveData];
}


-(void)saveData {
    ISUPdate = TRUE;
    NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserDetails"] mutableCopy];
    [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
    
    if(Pimagedata) {
        NSString *baseString= [Pimagedata base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
        if(baseString)
            [dict setObject:baseString forKey:@"image"];
    }
    
    [self WebResponse:dict WebserviceName:kEditProfile];
}

-(void) uploadImage{
    UIAlertController *popup=[UIAlertController alertControllerWithTitle:@"Select Picture" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* CancelButton = [UIAlertAction
                                   actionWithTitle:@"Photo Library"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                       //picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,kUTTypeImage,nil];
                                       
                                       picker.delegate = self;
                                       picker.editing = YES;
                                       picker.allowsEditing = YES;
                                       
                                       picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                       [self presentViewController:picker animated:YES completion:NULL];
                                   }];
    
    
    [popup addAction:CancelButton];
    
    UIAlertAction* TakeButton = [UIAlertAction
                                 actionWithTitle:@"Take Photo"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                                     {
                                         UIImagePickerController* picker = [[UIImagePickerController alloc] init];
                                         picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                         // picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,kUTTypeImage,nil];
                                         
                                         picker.delegate = self;
                                         [self presentViewController:picker animated:YES completion:NULL];
                                     }
                                     else
                                     {
                                         
                                         
                                         UIAlertController *popup=[UIAlertController alertControllerWithTitle:@"Camera Not Available" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
                                         UIAlertAction* CancelButton = [UIAlertAction actionWithTitle:@"OK"                             style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                         }];
                                         [popup addAction:CancelButton];
                                         
                                         [self presentViewController:popup animated:YES completion:nil];
                                         
                                     }
                                     
                                 }];
    
    
    [popup addAction:TakeButton];
    
    UIAlertAction* libraryButton = [UIAlertAction
                                    actionWithTitle:@"Cancel"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
    
    
    [popup addAction:libraryButton];
    
    
    [self presentViewController:popup animated:YES completion:nil];
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selsel");
    if(indexPath.row==0){
        [self uploadImage];
    } else if (indexPath.row == 5) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:privacyPolicyUrl]];
    } else if(indexPath.row == 6) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:termsConditionUrl]];
    }
    
}

#pragma mark - TextFeild
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}
#pragma mark - Webservice Call
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
             NSDictionary *dicYourResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             NSLog(@"%@",dicYourResponse);
             if(![[dicYourResponse valueForKey:@"status"] isEqualToString:@"0"])
             {
                 if(ISUPdate)
                 {
                     ISUPdate =FALSE;
                     NSMutableDictionary *dictParams=[[NSMutableDictionary alloc] init];
                     [dictParams setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
                     [self WebResponse:dictParams WebserviceName:kGetProfileUrl];
                 }
                 else
                 {
                     [[NSUserDefaults standardUserDefaults] setObject:[dicYourResponse valueForKey:@"data"] forKey:@"UserDetails"];
                     [[self navigationController] popToRootViewControllerAnimated:YES];
                 }
             }
             [[self navigationController] popToRootViewControllerAnimated:YES];
         }
         else
         {
             
         }
     }];
}


@end


//
//  SettingsViewController.m
//  TrakURep
//
//  Created by MAC on 01/11/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import "SettingsViewController.h"
#import "common.h"
#import "MBProgressHUD.h"
#import "UIImage+fixOrientation.h"

@interface SettingsViewController ()
{
    NSData *Pimagedata;
    NSString *Type;
    BOOL ISUPdate;
    NSString *newEmail;
     NSString *newPhone;
     NSString *newPassword;
     NSString *newName;
}
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"UserType"] isEqualToString:@"Rep"])
    {
        _view_Changephone.hidden = false;
        _view_Bottom_Clinic.hidden = true;
        _view_Bottom_Rep.hidden=false;

//        _view_ChangeEmailPAss.frame= CGRectMake( _view_ChangeEmailPAss.frame.origin.x, 123,  _view_ChangeEmailPAss.frame.size.width,  _view_ChangeEmailPAss.frame.size.height);
//        _view_Clear.frame = CGRectMake(_view_Clear.frame.origin.x, 232, _view_Clear.frame.size.width, _view_Clear.frame.size.height);
    }
    else
    {
        _view_Bottom_Rep.hidden=true;
        _view_Bottom_Clinic.hidden = false;
        _view_Changephone.hidden = true;
        _view_ChangeEmailPAss.frame= CGRectMake( _view_ChangeEmailPAss.frame.origin.x, 123,  _view_ChangeEmailPAss.frame.size.width,  _view_ChangeEmailPAss.frame.size.height);
        _view_Clear.frame = CGRectMake(_view_Clear.frame.origin.x, 232, _view_Clear.frame.size.width, _view_Clear.frame.size.height);
    }
    _view_Drop.layer.borderWidth = 1.0;
    _view_Drop.layer.borderColor= [UIColor lightGrayColor].CGColor;
    _view_Drop.layer.cornerRadius = 2.0;
    
    _view_Clear.layer.borderWidth = 0.5;
    _view_Clear.layer.borderColor= [UIColor lightGrayColor].CGColor;
    
    _view_ChangeEmailPAss.layer.borderWidth = 0.5;
    _view_ChangeEmailPAss.layer.borderColor= [UIColor lightGrayColor].CGColor;
    
    _view_Changephone.layer.borderWidth = 0.5;
    _view_Changephone.layer.borderColor= [UIColor lightGrayColor].CGColor;
    
    _view_Pic.layer.borderWidth = 0.5;
    _view_Pic.layer.borderColor= [UIColor lightGrayColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_History_Action:(id)sender {
    [self performSegueWithIdentifier:@"ShowHistory" sender:self];
}

- (IBAction)btn_Message_Action:(id)sender {
    [self performSegueWithIdentifier:@"ShowMsg" sender:self];

}

- (IBAction)btn_Save_Action:(id)sender {
    
    _view_Drop.hidden = true;
    if([Type isEqualToString:@"Email"])
    {
        newEmail = _txt_2.text;
    }
    if([Type isEqualToString:@"pass"])
    {
        newPassword = _txt_2.text;
    }
    if([Type isEqualToString:@"name"])
    {
        newName = _txt_2.text;
    }
    if([Type isEqualToString:@"phone"])
    {
        newPhone = _txt_2.text;
    }
    _txt_1.text= @"";
    _txt_2.text = @"";
}

- (IBAction)btn_TopSave_Action:(id)sender
{
  ISUPdate = TRUE;
    NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserDetails"] mutableCopy];
    
    if(newEmail.length>0)
    [dict setObject:newEmail forKey:@"email"];
    if(newPassword.length>0)
    [dict setObject:newPassword forKey:@"password"];
    
    if(newPhone.length>0)
    [dict setObject:newPhone forKey:@"phone"];
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"UserType"] isEqualToString:@"Rep"])
    {
        if(newName.length>0)
        [dict setObject:newName forKey:@"fname"];
    }
    else
    {
         if(newName.length>0)
       [dict setObject:newName forKey:@"company_name"];
    }
    
    NSString *baseString= [Pimagedata base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
     if(baseString)
         [dict setObject:baseString forKey:@"image"];
    
    [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];

    [self WebResponse:dict WebserviceName:kEditProfile];
}

- (IBAction)btn_Cancel_Action:(id)sender {
    _view_Drop.hidden =true;
}

- (IBAction)btn_Back_Action:(id)sender {
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"UserType"] isEqualToString:@"Rep"])
    {
        [self performSegueWithIdentifier:@"ShowRepProfile" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"ShowClinicProfile" sender:self];
    }
}

- (IBAction)btn_UpdatePic_Action:(id)sender {
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
- (IBAction)btn_Update_Email_Action:(id)sender {
    _view_Drop.hidden = false;
    Type= @"Email";
    _txt_1.placeholder = @"Enter Old Email";
    _txt_2.placeholder = @"Enter New Email";
}
- (IBAction)btn_Update_Password_Action:(id)sender {
    _view_Drop.hidden = false;
    Type= @"pass";
    _txt_1.placeholder = @"Enter Old Password";
    _txt_2.placeholder = @"Enter New Password";
}
- (IBAction)btn_ChangeNAme_Aaction:(id)sender {
    _view_Drop.hidden = false;
    Type= @"name";
    _txt_1.placeholder = @"Enter Old Name";
    _txt_2.placeholder = @"Enter New Name";
}
- (IBAction)btn_ChangePhone_Action:(id)sender {
    _view_Drop.hidden = false;
    Type= @"phone";
    _txt_1.placeholder = @"Enter Old Phone Number";
    _txt_2.placeholder = @"Enter New Phone Number";
}
- (IBAction)btn_Clear_History_Action:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dispensed"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"received"];

    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
    [dict setObject:@"History" forKey:@"type"];
    [self WebResponse:dict WebserviceName:kClearhistory];
}
- (IBAction)btn_ResetSamples_Action:(id)sender {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
    [dict setObject:@"Counter" forKey:@"type"];
    [self WebResponse:dict WebserviceName:kClearhistory];
}
#pragma mark - image picker delegate


//- (void)imagePickerController:(UIImagePickerController *)picker
//        didFinishPickingImage:(UIImage *)image
//                  editingInfo:(NSDictionary *)editingInfo{
//
//
//    [picker dismissViewControllerAnimated:YES completion:NULL];
//    Pimagedata = UIImageJPEGRepresentation(image, 0.3);
//
//
//
//
//}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"%@", info);
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage* img = (UIImage*)[info valueForKey:UIImagePickerControllerEditedImage];
    UIImage* image = [img fixOrientation];
    Pimagedata = UIImageJPEGRepresentation(image, 0.3);
    
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
             if([[dicYourResponse valueForKey:@"status"] isEqualToString:@"0"])
             {
                
             }
             else
             {
                 if(ISUPdate)
                 {
                     ISUPdate =FALSE;
                     NSMutableDictionary *dictParams=[[NSMutableDictionary alloc] init];
                     [dictParams setObject:[[dicYourResponse valueForKey:@"data"] valueForKey:@"userid"] forKey:@"userid"];
                     [self WebResponse:dictParams WebserviceName:kGetProfileUrl];
                 }
                 else
                 {
                    [[NSUserDefaults standardUserDefaults] setObject:[dicYourResponse valueForKey:@"data"] forKey:@"UserDetails"];
                     if([[[NSUserDefaults standardUserDefaults] valueForKey:@"UserType"] isEqualToString:@"Rep"])
                     {
                         [self performSegueWithIdentifier:@"showRepProfile" sender:self];
                     }
                     else
                     {
                         [self performSegueWithIdentifier:@"showClinicProfile" sender:self];
                     }
                 }
             }
         }
         else
         {
            
         }
     }];
    
    
}


@end

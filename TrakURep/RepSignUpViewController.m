//
//  RepSignUpViewController.m
//  TrakURep
//
//  Created by OSX on 07/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import "RepSignUpViewController.h"
#import "MBProgressHUD.h"
#import "UIImage+fixOrientation.h"
#import "UserSubscriptionVC.h"

@interface RepSignUpViewController ()

@end

@implementation RepSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _txt_State.enabled=false;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Email *" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.txt_email.attributedPlaceholder = str;
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Password *" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.txt_password.attributedPlaceholder = str1;
    
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"Confirm Password *" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.txt_CPass.attributedPlaceholder = str2;
    
    NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:@"Company Name *" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.txt_CompName.attributedPlaceholder = str3;
    
    NSAttributedString *contactNumberPlaceholder = [[NSAttributedString alloc] initWithString:@"Contact Number *" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.txt_contactNumber.attributedPlaceholder = contactNumberPlaceholder;

    NSAttributedString *str4 = [[NSAttributedString alloc] initWithString:@"Billing Address 1*" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.txt_addr1.attributedPlaceholder = str4;
    
    NSAttributedString *str5 = [[NSAttributedString alloc] initWithString:@"Billing Address 2" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.txt_addr2.attributedPlaceholder = str5;
    
    NSAttributedString *str6 = [[NSAttributedString alloc] initWithString:@"Zip Code *" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.txt_zipC.attributedPlaceholder = str6;
    
    NSAttributedString *str7 = [[NSAttributedString alloc] initWithString:@"City *" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.txt_City.attributedPlaceholder = str7;
    
    NSAttributedString *str8 = [[NSAttributedString alloc] initWithString:@"State *" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.txt_State.attributedPlaceholder = str8;
    
    NSAttributedString *str9 = [[NSAttributedString alloc] initWithString:@"Confirm Email *" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.txt_confirmEmail.attributedPlaceholder = str9;
    
    NSAttributedString *str10 = [[NSAttributedString alloc] initWithString:@"First Name *" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.txt_firstN.attributedPlaceholder = str10;
    
    NSAttributedString *str11 = [[NSAttributedString alloc] initWithString:@"Last Name *" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.txt_LastN.attributedPlaceholder = str11;

    _tbl_States.layer.cornerRadius = 5;
    _tbl_States.layer.borderWidth = 1.0;
    _tbl_States.layer.borderColor = [UIColor blackColor].CGColor;
    _tbl_States.clipsToBounds = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification*)nf {
    CGSize keyboardSize = [[[nf userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    int height = keyboardSize.height;
    [UIView animateWithDuration:0.3 animations:^{
        [__view_Form_1 setContentInset:UIEdgeInsetsMake(0, 0, height, 0)];
        [__view_Form_2 setContentInset:UIEdgeInsetsMake(0, 0, height, 0)];

    }];
}

- (void)keyboardWillHide:(NSNotification*)nf {
    [UIView animateWithDuration:0.3 animations:^{
        [__view_Form_1 setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [__view_Form_2 setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];

    }];
}


- (IBAction)btn_Back2_Action:(id)sender {
    __view_Form_1.hidden=FALSE;
    __view_Form_2.hidden=TRUE;
}

- (IBAction)btn_back1_Action:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction)btn_ProfilePic_Action:(id)sender {
    UIAlertController *popup=[UIAlertController alertControllerWithTitle:@"Select Picture" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* CancelButton = [UIAlertAction
                                   actionWithTitle:@"Photo Library"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                       
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

- (IBAction)btn_states_Action:(id)sender {
    [_txt_State resignFirstResponder];
    [_txt_CompName resignFirstResponder];
    [_txt_City resignFirstResponder];
    [_txt_zipC resignFirstResponder];
    [_txt_addr1 resignFirstResponder];
    [_txt_addr2 resignFirstResponder];
    [_txt_CPass resignFirstResponder];
    [_txt_email resignFirstResponder];
    [_txt_State resignFirstResponder];
    [_txt_LastN resignFirstResponder];
    [_txt_firstN resignFirstResponder];
    [_txt_password resignFirstResponder];
    [_txt_confirmEmail resignFirstResponder];
    [_txt_contactNumber resignFirstResponder];
    
    if(arrStates.count==0)
    {
        arrStates=[[NSMutableArray alloc]init];
        [self WebResponse:nil WebserviceName:kStatesUrl];
    }
    else{
        _tbl_States.hidden=false;

    }
}
- (IBAction)btn_continue_Action:(id)sender {
    
    if([self validateForm1]) {
        NSString* email = [_txt_email.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:email forKey:@"email"];
        [self WebResponse:dict WebserviceName:kCheckEmail];
    }
}

- (IBAction)btn_continue2_action:(id)sender {
    
    if([self validateForm2]) {
        
        NSString* email = [_txt_email.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* firstname = [_txt_firstN.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* lastname = [_txt_LastN.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* address1 = [_txt_addr1.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* address2 = [_txt_addr2.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* zipcode = [_txt_zipC.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* city = [_txt_City.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* compName = [_txt_CompName.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* contactNumber = [_txt_contactNumber.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

        NSString *baseString= [Pimagedata base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:email forKey:@"email"];
        [dict setObject:_txt_password.text forKey:@"password"];
        [dict setObject:@"2" forKey:@"user_type_id"];
        [dict setObject:firstname forKey:@"fname"];
        [dict setObject:lastname forKey:@"lname"];
        [dict setObject:@"0" forKey:@"payment_status"];
        [dict setObject:@"16/09/2016" forKey:@"payment_expdate"];
        [dict setObject:address1 forKey:@"address_1"];
        [dict setObject:address2 forKey:@"address_2"];
        [dict setObject:zipcode forKey:@"zipcode"];
        [dict setObject:city forKey:@"city"];
        [dict setObject:stateID forKey:@"state"];
        [dict setObject:compName forKey:@"company_name"];
        [dict setObject:contactNumber forKey:@"phone"];
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceToken"])
            [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceToken"] forKey:@"device_id"];
        
        
        
        
        if(baseString)
            [dict setObject:baseString forKey:@"image"];
        
        [self WebResponse:dict WebserviceName:kRegistrationUrl];

    }
}

-(BOOL)validateForm1 {
    NSString* email = [_txt_email.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* confimEmail = [_txt_confirmEmail.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* passwrod = _txt_password.text;
    NSString* confPassword = _txt_CPass.text;
    
    if(Pimagedata.length == 0) {
        [self showErrorAlert:@"Please choose a profile picture."];
        return  NO;
    }

    if(email.length > 0) {
        if ([self IsValidEmail:email]) {
            if(![email isEqualToString:confimEmail]) {
                [self showErrorAlert:@"Email and confirm email does not match."];
                return  NO;
            }
        } else {
            [self showErrorAlert:@"Please enter a valid email address."];
            return NO;
        }
    } else {
        [self showErrorAlert:@"Please enter your email address."];
        return  NO;
    }
    
    if(passwrod.length>0) {
        if(![self isValidPassword:passwrod]) {
            [self showErrorAlert:@"Your password must include at least 10 characters, one capital letter, one number, and one special character."];
            return NO;
        }
        if(![passwrod isEqualToString:confPassword]) {
            [self showErrorAlert:@"Password and confirm password does not match."];
            return NO;
        }
    } else {
        [self showErrorAlert:@"Please enter password."];
        return NO;
    }
    
    return  YES;
}

-(BOOL)validateForm2 {
    NSString* firstname = [_txt_firstN.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* lastname = [_txt_LastN.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* address1 = [_txt_addr1.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* address2 = [_txt_addr2.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* zipcode = [_txt_zipC.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* city = [_txt_City.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* compName = [_txt_CompName.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* contactNumber = [_txt_contactNumber.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* state = [_txt_State.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if(firstname.length==0) {
        [self showErrorAlert:@"Please enter your first name."];
        return  NO;
    }
    if(lastname.length==0) {
        [self showErrorAlert:@"Please enter your last name."];
        return  NO;
    }
    
    if(compName.length==0) {
        [self showErrorAlert:@"Please enter your company name."];
        return  NO;
        
    }

    if(contactNumber.length==0) {
        [self showErrorAlert:@"Please enter your contact number."];
        return  NO;
        
    } else {
        if(contactNumber.length != 10) {
            [self showErrorAlert:@"Please enter a valid contact number."];
            return  NO;
        }
    }

    if(address1.length==0) {
        [self showErrorAlert:@"Please enter your address."];
        return  NO;

    }
//    if(address2.length==0) {
//        [self showErrorAlert:@"Please enter your address."];
//        return  NO;
//    }
    
    if(city.length==0) {
        [self showErrorAlert:@"Please enter city name."];
        return  NO;
    }

    if(zipcode.length==0) {
        [self showErrorAlert:@"Please enter zip code."];
        return  NO;
    }


    if(state.length == 0){
        [self showErrorAlert:@"Please select your state."];
        return  NO;
    }
    
    return YES;
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

-(void)showAlert:(NSString*)message {
    UIAlertController *popup=[UIAlertController alertControllerWithTitle:@"TrakURep" message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* CancelButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {

                                   }];


    [popup addAction:CancelButton];
    [self presentViewController:popup animated:YES completion:nil];
}

-(BOOL)isValidContactNumber {
    NSString* contactNumber = [_txt_contactNumber.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if(contactNumber.length==0) {
        [self showErrorAlert:@"Please enter contact number."];
        return NO;
    } else if (contactNumber.length > 10) {
        [self showErrorAlert:@"Please enter valid contact number"];
        return NO;
    }
    return YES;
}

#pragma mark - table view delegate and data source methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrStates.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"StatesCell"];
    cell.textLabel.text=[[arrStates objectAtIndex:indexPath.row] valueForKey:@"name"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    stateID = [[arrStates objectAtIndex:indexPath.row] valueForKey:@"stateid"];
    _txt_State.text=[[arrStates objectAtIndex:indexPath.row] valueForKey:@"name"];
    _tbl_States.hidden=TRUE;
}

#pragma mark - image picker delegate


- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo{
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    UIImage* img = [image fixOrientation];
    Pimagedata = UIImageJPEGRepresentation(img, 0.3);
    
    
    [__btn_Profile setBackgroundImage:image forState:UIControlStateNormal];
    
    
}


#pragma mark -
#pragma mark -  email/password validation
-(BOOL)IsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSLog(@"%d",[emailTest evaluateWithObject:checkString]);

    return [emailTest evaluateWithObject:checkString];
}

-(BOOL)isValidPassword:(NSString *)passwordString
{
    NSString *stricterFilterString = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[A-Za-z\\d$@$!%#*?&]{10,}";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    NSLog(@"%d",[passwordTest evaluateWithObject:passwordString]);
    return [passwordTest evaluateWithObject:passwordString];
}
-(BOOL) validateAlphabets: (NSString *)alpha
{
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    NSString *output = [alpha stringByTrimmingCharactersInSet:[myCharSet invertedSet]];
    
    BOOL isValid = [alpha isEqualToString:output];
    return isValid;
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
    if(Params)
    {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:Params options:0 error:nil]; //[post dataUsingEncoding:NSASCIIStringEncoding];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
    }
    
    
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
             if([[dicYourResponse valueForKey:@"status"] isEqualToString:@"0"])
             {
                 [self showErrorAlert:[dicYourResponse valueForKey:@"message"]];

             } else {
                 if([WebserviceName isEqualToString:@"statelist"])
                 {
                     arrStates = [dicYourResponse valueForKey:@"data"];
                     [_tbl_States reloadData];
                     _tbl_States.hidden=false;
                 }
                 else if([WebserviceName isEqualToString:@"checksignupemail"])
                 {
                     __view_Form_1.hidden = TRUE;
                     __view_Form_2.hidden = FALSE;
                     
                 } else if([WebserviceName isEqualToString:kRegistrationUrl]) {
                     [[NSUserDefaults standardUserDefaults] setObject:[[dicYourResponse valueForKey:@"data"] valueForKey:@"access_token"] forKey:@"AccssToken"];

                     [[NSUserDefaults standardUserDefaults] setObject:[[dicYourResponse valueForKey:@"data"] valueForKey:@"userid"] forKey:@"UserId"];
                     [[NSUserDefaults standardUserDefaults] setObject:@"Rep" forKey:@"UserType"];
                     [[NSUserDefaults standardUserDefaults] setObject:@"inactive" forKey:@"user_status"];

                    [self performSegueWithIdentifier:@"ShowWaitScreen" sender:self];
//                     [self.navigationController popToRootViewControllerAnimated:YES];
                     //[self showAlert:@"Your account has been created successfully and it may take up to 48 hours for access to be reviewed. Please check your registered email address for access status."];
                 }
             }
         }
         else{
             [self showErrorAlert:[connectionError description]];
         }
     }];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowWaitScreen"]) {
        UserSubscriptionVC *vc = segue.destinationViewController;
        vc.isSingUp = YES;
    }
}

#pragma mark - textfeild delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return TRUE;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_txt_State resignFirstResponder];
    [_txt_CompName resignFirstResponder];
    [_txt_City resignFirstResponder];
    [_txt_zipC resignFirstResponder];
    [_txt_addr1 resignFirstResponder];
    [_txt_addr2 resignFirstResponder];
    [_txt_CPass resignFirstResponder];
    [_txt_email resignFirstResponder];
    [_txt_State resignFirstResponder];
    [_txt_LastN resignFirstResponder];
    [_txt_firstN resignFirstResponder];
    [_txt_password resignFirstResponder];
    [_txt_confirmEmail resignFirstResponder];

}
@end

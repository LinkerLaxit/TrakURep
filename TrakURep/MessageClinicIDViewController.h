//
//  UITableViewController+EditPhoneViewController.h
//  TrakURep
//
//  Created by Aidan Curtis on 1/1/18.
//  Copyright © 2018 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageClinicIDViewController:UITableViewController<UITextFieldDelegate>{
    BOOL ISUPdate;
}


- (IBAction)savePressed:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *phoneInput;


@end

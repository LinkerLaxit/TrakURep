//
//  UITableViewController+NewSettingsController.h
//  TrakURep
//
//  Created by Aidan Curtis on 12/31/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewSettingsController : UITableViewController{
    NSData *Pimagedata;
    NSString *Type;
    BOOL ISUPdate;
    NSString *newEmail;
    NSString *newPhone;
    NSString *newPassword;
    NSString *newName;
}
@end

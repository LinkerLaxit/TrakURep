//
//  UITableViewController+EditNameViewController.h
//  TrakURep
//
//  Created by Aidan Curtis on 1/1/18.
//  Copyright © 2018 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditNameViewController:UITableViewController{
    BOOL ISUPdate;
}


- (IBAction)savePressed:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *nameInput;


@end

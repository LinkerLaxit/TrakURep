//
//  EditAddressViewController.h
//  TrakURep
//
//  Created by Darshit Vadodaria on 22/02/18.
//  Copyright © 2018 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkEngine.h"
#import "common.h"

@interface EditAddressViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
     BOOL ISUPdate;
     NSMutableArray *arrStates;
     NSString* stateID;
    NSString* stateName;
}

- (IBAction)savePressed:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *addr2;
@property (strong, nonatomic) IBOutlet UITextField *addr1;
@property (strong, nonatomic) IBOutlet UITextField *zipCode;
@property (strong, nonatomic) IBOutlet UITextField *city;
@property (strong, nonatomic) IBOutlet UITextField *state;
@property (weak, nonatomic) IBOutlet UITableView *tbl_States;

@end

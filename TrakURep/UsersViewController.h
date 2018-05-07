//
//  UsersViewController.h
//  TrakURep
//
//  Created by MAC on 24/11/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
#import "UserTableViewCell.h"
@interface UsersViewController : UIViewController <UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tbl_USer;
@property (strong, nonatomic) IBOutlet UIView *view_ClinicBottom;
@property (strong, nonatomic) IBOutlet UIView *view_RepBottom;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)btn_HistAction:(id)sender;
- (IBAction)btn_message_Action:(id)sender;
- (IBAction)btn_Samples_Action:(id)sender;
- (IBAction)btn_Profile_Action:(id)sender;
- (IBAction)btn_inventory_action:(id)sender;

@end

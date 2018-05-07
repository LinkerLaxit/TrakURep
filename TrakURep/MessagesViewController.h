//
//  MessagesViewController.h
//  TrakURep
//
//  Created by osx on 15/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
#import "MessagesCell.h"
@interface MessagesViewController : UIViewController{
    NSMutableArray *arrUsers;
}
- (IBAction)btn_Plus_Action:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tbl_Messages;
@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;
@property (strong, nonatomic) IBOutlet UIView *view_bottom_clinic;
@property (strong, nonatomic) IBOutlet UIView *view_bottom_Rep;
@end

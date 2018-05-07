//
//  InventoryViewController.h
//  TrakURep
//
//  Created by OSX on 14/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InventoryViewController : UIViewController
{
    NSMutableArray *arrInventory;
    NSMutableArray *searchResult;
    BOOL searchEnabled;
}

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmnetcontrol;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tbl_History;


- (IBAction)Value_Changes_Segment:(id)sender;

@end

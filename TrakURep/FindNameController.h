//
//  UIViewController+FindNameController.h
//  TrakURep
//
//  Created by Aidan Curtis on 1/10/18.
//  Copyright © 2018 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindNameController:UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{
    NSMutableArray* nameArr;
    NSMutableArray* filteredArr;
    int currentPage, totalPage ;
    BOOL isSearching;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

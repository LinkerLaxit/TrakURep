//
//  UserTableViewCell.h
//  TrakURep
//
//  Created by MAC on 24/11/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbl_Name;
@property (strong, nonatomic) IBOutlet UIImageView *lbl_Image;
@property (strong, nonatomic) IBOutlet UILabel *lbl_ExpDate;
@property (strong, nonatomic) IBOutlet UILabel *lbl_subDetail;

@end

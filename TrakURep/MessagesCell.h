//
//  MessagesCell.h
//  TrakURep
//
//  Created by MAC on 18/11/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagesCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *img_profile;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Name;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Message;
@property (strong, nonatomic) IBOutlet UILabel *lbl;
@property (strong, nonatomic) IBOutlet UIImageView *img_BlueDot;

@end

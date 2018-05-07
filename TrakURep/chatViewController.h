//
//  chatViewController.h
//  TrakURep
//
//  Created by osx on 15/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"

@interface chatViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIImageView *img_TextBack;
@property (strong, nonatomic) IBOutlet UITableView *tbl_Chats;
@property (strong, nonatomic) IBOutlet UIButton *btn_Send;
@property (strong, nonatomic) IBOutlet UILabel *lbl_topName;
- (IBAction)btn_Back_Action:(id)sender;
- (IBAction)btn_Send_Action:(id)sender;
- (IBAction)btn_loadMore_Action:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *img_UserProfile;

@end

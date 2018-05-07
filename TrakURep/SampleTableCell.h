//
//  SampleTableCell.h
//  TrakURep
//
//  Created by Vikash Kumar on 13/03/18.
//  Copyright © 2018 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SampleTableCell : UITableViewCell
@property(nonatomic, weak)IBOutlet UILabel* lblLot;
@property(nonatomic, weak)IBOutlet UILabel* lblTransactionID;
@property(nonatomic, weak)IBOutlet UILabel* lblExpDate;
@property(nonatomic, weak)IBOutlet UILabel* lblCreatedDate;

@property(nonatomic, weak)IBOutlet UIImageView* imgPil;

@end

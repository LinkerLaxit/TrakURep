//
//  MessagesCell.m
//  TrakURep
//
//  Created by MAC on 18/11/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import "MessagesCell.h"

@implementation MessagesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSLog(@" Cell %@",_lbl_Name.text);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

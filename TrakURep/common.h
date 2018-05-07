//
//  common.h
//  TrakURep
//
//  Created by OSX on 07/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#ifndef common_h
#define common_h


//#define HostName @"http://52.43.180.120/api.php?function="    // Live   http://admin.trakurep.com
#define HostName @"http://admin.trakurep.com/api.php?function="    // Live   ipv6 configured

//#define HostName @"http://ec2-52-43-180-120.us-west-2.compute.amazonaws.com/api.php?function="    // Live
//#define HostName @"http://172.16.1.123:8888/trakurep-backend/api.php?function="      // Local

#define privacyPolicyUrl @"http://admin.trakurep.com/privacy_policy.pdf"
#define termsConditionUrl @"http://admin.trakurep.com/termsconditions_trakurep.pdf"


#define kGetLoginResponse @"login"
#define kRegistrationUrl @"signup"
#define kStatesUrl @"statelist"
#define kGetProfileUrl @"getprofile"
#define kGetHistoryUrl @"history"
#define kGetHistoryDetailUrl @"historydetail"
#define kSearchUserUrl @"searchusers"
#define kUpdatePayments @"updateprofile"
#define kInventoryURL @"inventory"
#define kGetUsers @"searchusers"
#define kGetchat @"message"
#define kDeleteMessages @"deleteMessages"
#define kSendMessage @"sendMessage"
#define kGetMainMessageList @"messageHistory"
#define kSaveSamples   @"addSample"
#define kDispenseSample @"sample_dispense"
#define kDownload @"downloadpdf"
#define kEditProfile @"editprofile"
#define kClearhistory @"clearHistory"
#define kClearsamples @"clearSamples"
#define kLogout @"logout"
#define kCheckEmail @"checksignupemail"
#define kCheckRepID @"checkrepid"
#define kForgotPassword @"forgotpassword"
#define kTradeList @"tradelist"
#define kExportInventory @"exportinventory"
#endif /* common_h */

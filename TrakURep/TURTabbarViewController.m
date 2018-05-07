//
//  TURTabbarViewController.m
//  TrakURep
//
//  Created by Vikash Kumar on 22/02/18.
//  Copyright © 2018 OSX. All rights reserved.
//

#import "TURTabbarViewController.h"
#import <UIColor-HexString/UIColor+HexString.h>
#import "common.h"

@interface TURTabbarViewController ()
{
    NSString* userType;
}
@end

@implementation TURTabbarViewController

-(instancetype)initWithUserType:(NSString*)type {
    self = [super init];
    userType = type;
    
    if ([userType isEqualToString:@"RepUser"])
        [self setTabItemsForRepUser];
    else
        [self setTabItemsForClinicUser];

    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#34495E"]];
    [[UITabBar appearance] setUnselectedItemTintColor:[UIColor colorWithWhite:255 alpha:0.7]];
//    [[UITabBar appearance] setSelectedImageTintColor: [UIColor whiteColor]];
    [[UITabBar appearance] setTintColor: [UIColor whiteColor]];

    //[[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateBagdeCount:)
                                                 name:@"MessageNotification"
                                               object:nil];
    [self loadUsersChatConversations];
}

- (void) updateBagdeCount:(NSNotification *) notification{
    if(![self.tabBar.selectedItem.title isEqualToString: @"Messages"]){
        NSDictionary *dict = (NSDictionary*)notification.userInfo;
        //NSDictionary *aps = [dict valueForKey:@"aps"];
        self.tabBar.items[1].badgeValue = [NSString stringWithFormat:@"%@",[dict valueForKey:@"totalUnreads"]];
    }
   
   
}


-(void)setTabItemsForRepUser {
  id historyNavVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavRepHistoryViewController"];
  id messageNavVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavActualMessagesViewController"];
   id profileNavVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavRepProfileViewController"];
    
    
//    tabBarController.selectedColor = [UIColor colorWithHexString:@"#FFFFFF"];
//    tabBarController.buttonsBackgroundColor = [UIColor colorWithHexString:@"#34495E"];
    [self setViewControllers:@[historyNavVC, messageNavVc, profileNavVC]];
    
    [self.tabBar.items[0] setTitle:@"History"];
    [self.tabBar.items[1] setTitle:@"Messages"];
    [self.tabBar.items[2] setTitle:@"Profile"];
    [self.tabBar.items[0] setImage:[[UIImage imageNamed:@"historyIcon1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.tabBar.items[1] setImage:[[UIImage imageNamed:@"messageIcon1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.tabBar.items[2] setImage:[[UIImage imageNamed:@"profileIcon1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
   
    self.selectedIndex = 2; //Profile tab selected by default.
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"badgeCount"]) {
        self.tabBar.items[1].badgeValue = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"badgeCount"]];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"badgeCount"];
    }
    
}

-(void)setTabItemsForClinicUser {
    id histNavVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavHistoryViewController"];
    
    id messageNavVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavMessagesViewController"];
    
    id sampleNavVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavSampleConfirmViewController"];
    
    id profileNavVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavClinicProfileViewController"];
    
    id inventoryNavVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavInventoryViewController"];
    
    [self setViewControllers:@[histNavVC, messageNavVC, sampleNavVC, profileNavVC, inventoryNavVC]];

    [self.tabBar.items[0] setTitle:@"History"];
    [self.tabBar.items[1] setTitle:@"Messages"];
    [self.tabBar.items[2] setTitle:@"Samples"];
    [self.tabBar.items[3] setTitle:@"Profile"];
    [self.tabBar.items[4] setTitle:@"Inventory"]; //inventoryIcon1  smaplesicons1

//    [self.tabBar.items[0] setImage:[UIImage imageNamed:@"historyIcon1"]];
//    [self.tabBar.items[1] setImage:[UIImage imageNamed:@"messageIcon1"]];
//    [self.tabBar.items[2] setImage:[UIImage imageNamed:@"smaplesicons1"]];
//    [self.tabBar.items[3] setImage:[UIImage imageNamed:@"profileIcon1"]];
//    [self.tabBar.items[4] setImage:[UIImage imageNamed:@"inventoryIcon1"]];
    [self.tabBar.items[0] setImage:[[UIImage imageNamed:@"historyIcon1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.tabBar.items[1] setImage:[[UIImage imageNamed:@"messageIcon1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.tabBar.items[2] setImage:[[UIImage imageNamed:@"smaplesicons1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.tabBar.items[3] setImage:[[UIImage imageNamed:@"profileIcon1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.tabBar.items[4] setImage:[[UIImage imageNamed:@"inventoryIcon1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];

    self.selectedIndex = 3; //Profile tab selected by default.
}


-(void)loadUsersChatConversations {
    NSMutableDictionary *dictHist=[[NSMutableDictionary alloc] init];
    [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
    [dictHist setObject:[NSString stringWithFormat:@"%d",0] forKey:@"limit"];
    
    [self WebResponse:dictHist WebserviceName:kGetMainMessageList];
}

#pragma mark - Webservice Call
-(void)WebResponse:(NSDictionary *)Params WebserviceName:(NSString *)WebserviceName
{
    
    NSString *stringUrl = [HostName stringByAppendingString:WebserviceName];
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    [request setHTTPMethod:@"POST"];
    if(Params)
    {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:Params options:0 error:nil];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"AccssToken"] forHTTPHeaderField:@"AuthToken"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
    }
    NSURLRequest *requestURL = [[NSURLRequest alloc] init];
    requestURL = request.copy;
    

    
   NSURLSessionDataTask* task = [session dataTaskWithRequest:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
       if (data.length > 0) {
           NSDictionary *dicYourResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
           if(![[dicYourResponse valueForKey:@"status"] isEqualToString:@"0"]) {
               if([[dicYourResponse valueForKey:@"data"]  count]>0) {
                   id arrUsers = [[NSMutableArray alloc] initWithArray:[dicYourResponse valueForKey:@"data"]];
                   id filterArray = [arrUsers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"is_read != 'Y'"]];
                   
                   dispatch_async(dispatch_get_main_queue(), ^{
                       NSString* unreadCount = [filterArray count] > 0 ? [NSString stringWithFormat:@"%lu", [filterArray count]] : nil ;
                       [self.tabBarController.tabBar.items[1] setBadgeValue: unreadCount];
                   });
               }
           }
       }

    }];
    [task resume];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"%@",tabBar);
    
    if (![userType isEqualToString:@"RepUser"]){
        if (![item.title isEqualToString:@"Messages"]){
            for(int i=0;i<self.viewControllers.count;i++){
                UINavigationController *nav = (UINavigationController*)self.viewControllers[i];
                if([nav.restorationIdentifier isEqualToString:@"NavMessagesViewController"]){
                    [nav popToRootViewControllerAnimated:NO];
                }
            }
        }
    }
    
}

@end

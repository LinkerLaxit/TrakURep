//
//  AppDelegate.m
//  TrakURep
//
//  Created by OSX on 05/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import "AppDelegate.h"
#import "PayPalMobile.h"
#import "CustomTabBar.h"
#import "CustomRepTabBar.h"
#import "TURTabbarViewController.h"
#import <IQKeyboardManager.h>
@interface AppDelegate ()

@end

@implementation AppDelegate
//NSString *const kGCMMessageIDKey = @"1:775338891880:ios:d6d033ef494630bc";
NSString *const kGCMMessageIDKey = @"1:200598665229:ios:d6d033ef494630bc";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Set clinic id
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"uniqueclinicid"]==nil || [[[NSUserDefaults standardUserDefaults] valueForKey:@"uniqueclinicid"]  isEqual: @""]){
        [[NSUserDefaults standardUserDefaults] setValue:@"1234" forKey:@"uniqueclinicid"];
    }
    if (launchOptions != nil) {
        NSDictionary *userInfo = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        NSDictionary *dict = [userInfo valueForKey:@"aps"];
        [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"badge"] forKey:@"badgeCount"];
    }
    
    [IQKeyboardManager sharedManager].enable = true;
    
//    if launchOptions != nil {
//        if let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
//            setNotificaitonType(userInfo: userInfo)
//        }
//    }

    
    
    // Override point for customization after application launch.
    

    application.statusBarStyle = UIStatusBarStyleLightContent;
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"",
                                                           PayPalEnvironmentSandbox : @"AY48W1kimWe6T-JxfzzNJiOOxQPZtiJIqedPQlD4GrZC7J-eiAdWM3-ssMambFHVhEm_E5leCD5GWnkx"}];
//    [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:@"pk_test_MRjfwA8WJOThiUcdc3ek2EbG"];
    UINavigationController *navController;
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"Last_Dispesed_UniqueID"];

    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"UserType"] isEqualToString:@"Clinic"] && [[[NSUserDefaults standardUserDefaults] valueForKey:@"user_status"] isEqualToString:@"active"]) {
        
        navController=[[UINavigationController alloc] initWithRootViewController: [[TURTabbarViewController alloc] initWithUserType:@"ClinicUser"]];
        
    } else if([[[NSUserDefaults standardUserDefaults] valueForKey:@"UserType"] isEqualToString:@"Rep"] && [[[NSUserDefaults standardUserDefaults] valueForKey:@"user_status"] isEqualToString:@"active"]) {
       
        navController=[[UINavigationController alloc] initWithRootViewController: [[TURTabbarViewController alloc] initWithUserType:@"RepUser"]];
        
    } else {
        navController=[[UINavigationController alloc] initWithRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"Login"]];
    }

    navController.navigationBarHidden = true;

    self.window.rootViewController = navController;
    
    
    [FIRApp configure];
    [FIRMessaging messaging].delegate = self;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions =UNAuthorizationOptionAlert| UNAuthorizationOptionSound| UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
#endif
    }
    
    [application registerForRemoteNotifications];
    
    return YES;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
//            BOOL stripeHandled = [Stripe handleStripeURLCallbackWithURL:url];
//            if (stripeHandled) {
//                return YES;
//            } else {
//                // This was not a stripe url – do whatever url handling your app
//                // normally does, if any.
//            }
    return YES;
}



// [START receive_message]
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
     [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    


    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"1%@", userInfo);
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"MessageNotification"
     object:nil userInfo:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
     [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"2%@", userInfo);
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"MessageNotification"
     object:nil userInfo:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}
// [END receive_message]

// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
     [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }

    // Print full message.
    NSLog(@"3%@", userInfo);
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"MessageNotification"
     object:nil userInfo:userInfo];
    // Change this to your preferred presentation option
    completionHandler(UNNotificationPresentationOptionAlert);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
#if defined(__IPHONE_11_0)
         withCompletionHandler:(void(^)(void))completionHandler {
#else
withCompletionHandler:(void(^)())completionHandler {
#endif
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"4%@", userInfo);
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"MessageNotification"
     object:nil userInfo:userInfo];
    
    completionHandler();
}
#endif
    // [END ios_10_message_handling]
    
    // [START refresh_token]
    - (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
        NSLog(@"FCM registration token: %@", fcmToken);
        if (fcmToken)
            [[NSUserDefaults standardUserDefaults] setValue:fcmToken forKey:@"DeviceToken"];
       // [[NSUserDefaults standardUserDefaults] setValue:fcmToken forKey:@"DeviceToken"];
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set [Messaging messaging].shouldEstablishDirectChannel to YES.
    - (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage {
        NSLog(@"Received data message: %@", remoteMessage.appData);
    }
    // [END ios_10_data_message]
    
    - (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
        NSLog(@"Unable to register for remote notifications: %@", error);
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs device token can be paired to
    // the FCM registration token.
    - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
        NSLog(@"APNs device token retrieved: %@", deviceToken);
        NSString *strtoken = [deviceToken description];
        strtoken = [strtoken stringByReplacingOccurrencesOfString:@"<" withString:@""];
        strtoken = [strtoken stringByReplacingOccurrencesOfString:@">" withString:@""];

        // With swizzling disabled you must set the APNs device token here.
        
        [[FIRMessaging messaging] setAPNSToken:deviceToken type:FIRMessagingAPNSTokenTypeProd];
        // [FIRMessaging messaging].APNSToken = deviceToken;
        //[[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeSandbox];
        NSString * refreshedToken = [[FIRInstanceID instanceID] token];
        NSLog(@" refreshedToken  %@", refreshedToken);
        if (refreshedToken) {
            [[NSUserDefaults standardUserDefaults] setValue:refreshedToken forKey:@"DeviceToken"];

            //print("InstanceID token: \(refreshedToken)")
        }
    }

- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

    
    - (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken {
        
    }
    
   
    
 
    
    @end

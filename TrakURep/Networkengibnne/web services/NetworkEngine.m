//
//  NetworkEngine.m
//  SonaFire
//
//  Created by karamjit.singh on 18/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NetworkEngine.h"
@implementation NetworkEngine
#define HostName @"52.43.180.120/"


+(void)LoginResponse:(NSDictionary *)Params WebserviceName:(NSString *)WebserviceName
{
    NSString *stringUrl = [HostName stringByAppendingString:WebserviceName];
 //   stringUrl = [stringUrl stringByAddingPercentEncodingWithAllowedCharacters:URLHostAllowedCharacterSet];
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:Params options:0 error:nil]; //[post dataUsingEncoding:NSASCIIStringEncoding];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];

   // NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *dicYourResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             NSLog(@"%@",dicYourResponse);
             if([[dicYourResponse valueForKey:@"status"] isEqualToString:@"failed"])
             {
                 
             }
             else
             {
                
             }
         }
     }];

}
@end

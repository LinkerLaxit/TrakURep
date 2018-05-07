//
//  NetworkEngine.h
//  SonaFire
//
//  Created by karamjit.singh on 18/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface NetworkEngine :NSObject
{
    
}

+(void)LoginResponse:(NSDictionary *)Params WebserviceName:(NSString *)WebserviceName;
@end

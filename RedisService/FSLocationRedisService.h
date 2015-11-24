//
//  FSOrderRedisService.h
//  CallPlaneFS
//
//  Created by Rafferty on 15/11/13.
//  Copyright © 2015年 PowerVision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSBaseRedisService.h"
#import <CoreLocation/CoreLocation.h>
@interface FSLocationRedisService : FSBaseRedisService




-(void)sendMyLocation:(CLLocation *)location userName:(NSString *)user;

-(CLLocation*)getUserLocation:(NSString*)userName;
-(void)closeRedis;

-(void)testPush;
@end

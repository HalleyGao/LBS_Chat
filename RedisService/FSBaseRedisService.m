//
//  FSBaseRedisService.m
//  CallPlaneFS
//
//  Created by Rafferty on 15/11/13.
//  Copyright © 2015年 PowerVision. All rights reserved.
//

#import "FSBaseRedisService.h"

@implementation FSBaseRedisService
-(id)init
{
    self=[super init];
    if(self)
    {
        _redis= [ObjCHiredis redis:@"100.0.0.67" on:[NSNumber numberWithInt:6379]];
    }
    return self;
}
@end

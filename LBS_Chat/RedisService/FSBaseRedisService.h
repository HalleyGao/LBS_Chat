//
//  FSBaseRedisService.h
//  CallPlaneFS
//
//  Created by Rafferty on 15/11/13.
//  Copyright © 2015年 PowerVision. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ObjCHiredis.h"



@interface FSBaseRedisService : NSObject

@property(nonatomic,strong)ObjCHiredis *redis;
@end

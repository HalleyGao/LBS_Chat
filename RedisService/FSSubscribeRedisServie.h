//
//  FSSubscribeRedisServie.h
//  LBS_Chat
//
//  Created by Rafferty on 15/11/20.
//  Copyright © 2015年 PowerVision. All rights reserved.
//

#import "FSBaseRedisService.h"

@interface FSSubscribeRedisServie : FSBaseRedisService
-(void)locationStatuslistener;



@property(nonatomic,weak)id locationStatuslistenerReturnValue;
@end

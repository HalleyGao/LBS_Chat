//
//  FSSubscribeRedisServie.m
//  LBS_Chat
//
//  Created by Rafferty on 15/11/20.
//  Copyright © 2015年 PowerVision. All rights reserved.
//

#import "FSSubscribeRedisServie.h"

@implementation FSSubscribeRedisServie
//order status listener
-(void)locationStatuslistener
{
    
    //[NSThread detachNewThreadSelector:@selector(publishOrderStatusListener) toTarget:self withObject:nil];
    
    dispatch_queue_t urls_queue = dispatch_queue_create("NewThreadOrderStatus", NULL);
    dispatch_async(urls_queue, ^{
        [self publishOrderStatusListener];
    });
    
    
    
}
-(void)unSubscribe
{
    [self.redis command:@"UNSUBSCRIBE jiaogefeiji"];
}
-(void)publishOrderStatusListener
{
    [self.redis command:@"SUBSCRIBE jiaogefeiji"];
    self.locationStatuslistenerReturnValue = [self.redis getReply];
}
@end

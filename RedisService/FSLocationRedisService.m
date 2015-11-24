//
//  FSOrderRedisService.m
//  CallPlaneFS
//
//  Created by Rafferty on 15/11/13.
//  Copyright © 2015年 PowerVision. All rights reserved.
//

#import "FSLocationRedisService.h"
#define FSRedisCommand_OrderStatusChanged @""

@implementation FSLocationRedisService





//close redis
-(void)closeRedis
{
    [self.redis command:@"FLUSHDB"];
    [self.redis close];
    
}

-(void)sendMyLocation:(CLLocation *)location userName:(NSString *)user
{

    [self.redis command:[NSString stringWithFormat:@"hset %@ x %lf ",user,location.coordinate.latitude]];
    [self.redis command:[NSString stringWithFormat:@"hset %@ y %lf ",user,location.coordinate.longitude]];
    [self.redis command:[NSString stringWithFormat:@"publish jiaogefeiji %@",user]];

}
-(CLLocation*)getUserLocation:(NSString *)userName
{
   
    id x=[self.redis command:[NSString stringWithFormat:@"hget %@ x",userName]];
    id y=[self.redis command:[NSString stringWithFormat:@"hget %@ y",userName]];
    double locationX=[(NSString*)x doubleValue];
    double locationY=[(NSString*)y doubleValue];
    CLLocation *location=[[CLLocation alloc] initWithLatitude:locationX longitude:locationY];
    return location;
    
    
}

-(void)testPush
{
//    UIImage *image=[UIImage imageNamed:@"touxiang1"];
//    NSData *photoData=UIImageJPEGRepresentation(image, 0.75);
//    NSString *str=[photoData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];;

    id test=[NSBundle mainBundle];
    NSString*filePath = [[NSBundle mainBundle] pathForResource:@"voice123" ofType:@"amr" ];
    NSData* data= [NSData dataWithContentsOfFile:filePath];
   // NSData *fileData=[NSData dataWithContentsOfFile:@"touxiang1.png"];
      NSString *str=[data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];;
    [self.redis command:[NSString stringWithFormat:@"PUBLISH jiaogefeiji %@",str]];
}

@end

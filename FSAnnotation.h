//
//  FSAnnotation.h
//  LBS_Chat
//
//  Created by Rafferty on 15/11/20.
//  Copyright © 2015年 PowerVision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface FSAnnotation : NSObject<MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@end

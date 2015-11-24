//
//  ViewController.m
//  LBS_Chat
//
//  Created by Rafferty on 15/11/20.
//  Copyright © 2015年 PowerVision. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "ObjCHiredis.h"
#import "FSLocationRedisService.h"
#import "FSAnnotation.h"
#import "FSSubscribeRedisServie.h"
#define CurrentUserName @"bingyao    "

@interface ViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>
{
    MKMapView *_mapView;
    
    FSLocationRedisService *_locationService;
    NSMutableDictionary         *userDictionary;
    NSMutableArray              *_annArray;
    FSSubscribeRedisServie    *_locationSubscribeService;
}

@property (nonatomic, strong) CLLocationManager* locationManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _mapView=[[MKMapView alloc] initWithFrame:self.view.frame];
    _mapView.delegate=self;
    [self.view addSubview:_mapView];
    
    _locationService=[[FSLocationRedisService alloc] init];
    _locationSubscribeService=[[FSSubscribeRedisServie alloc] init];
    
    [_locationSubscribeService locationStatuslistener];
    [_locationSubscribeService addObserver:self forKeyPath:@"locationStatuslistenerReturnValue" options:NSKeyValueObservingOptionNew context:nil];
    
    
  
    userDictionary=[NSMutableDictionary dictionary];
    _annArray=[NSMutableArray array];
    [self configureLocationManager];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"locationStatuslistenerReturnValue"]&& object==_locationSubscribeService)
    {
         if(![_locationSubscribeService.locationStatuslistenerReturnValue isKindOfClass:[NSArray class]])
         {
              [_locationSubscribeService locationStatuslistener];
             return;
         }
        NSArray *array=(NSArray*)_locationSubscribeService.locationStatuslistenerReturnValue;
       
        if(![[array lastObject] isKindOfClass:[NSString class]])
        {
             [_locationSubscribeService locationStatuslistener];
            return;
        }
        NSString *obje=[array lastObject];
        
        if(obje==nil||[obje isEqualToString:CurrentUserName])
        {
           [_locationSubscribeService locationStatuslistener];
            return;
        }
        
        CLLocation *location=[_locationService getUserLocation:obje];
        
        [userDictionary setObject:location forKey:obje];
        
        [self addAnnotations];
         [_locationSubscribeService locationStatuslistener];
       
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)configureLocationManager
{
    //定位管理器
    _locationManager=[[CLLocationManager alloc]init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestAlwaysAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways){
        //设置代理
        _locationManager.delegate=self;
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //_locationManager.distanceFilter=100;
       // _locationManager.distanceFilter=1;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
    else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        //设置代理
        _locationManager.delegate=self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        
        //_locationManager.distanceFilter=100;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
    
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location=[locations lastObject];
  
    [userDictionary setObject:location forKey:CurrentUserName];
      [_locationService sendMyLocation:location userName:CurrentUserName];
        //[_locationService locationStatuslistener];

    [self addAnnotations];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //由于当前位置的标注也是一个大头针，所以此时需要判断，此代理方法返回nil使用默认大头针视图
    if ([annotation isKindOfClass:[FSAnnotation class]]) {
        static NSString *key1=@"AnnotationKey1";
        MKAnnotationView *annotationView=[_mapView dequeueReusableAnnotationViewWithIdentifier:key1];
        
        //如果缓存池中不存在则新建
//        if (!annotationView) {
            annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:key1];
            annotationView.canShowCallout=true;//允许交互点击
            annotationView.calloutOffset=CGPointMake(0, 1);//定义详情视图偏移量
            annotationView.image=[UIImage imageNamed:@"beginRiding"];
//            annotationView.leftCalloutAccessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_classify_cafe.png"]];//定义详情左侧视图
//        
        
        //修改大头针视图
        //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
        annotationView.annotation=annotation;
        //annotationView.image=((FSAnnotation *)annotation).image;//设置大头针视图的图片
        
        return annotationView;
    }else {
        return nil;
    }
}
-(void)addAnnotations
{
    
    [_mapView removeAnnotations:_annArray];
    [_annArray removeAllObjects];
    
    for (NSString *key in userDictionary.allKeys) {
        CLLocation *object=[userDictionary objectForKey:key];
        CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(object.coordinate.latitude, object.coordinate.longitude);
        FSAnnotation *annotation1=[[FSAnnotation alloc]init];
        annotation1.title=key;
        annotation1.subtitle=[NSString stringWithFormat:@"latitude:%lf  longitude:%lf",object.coordinate.latitude,object.coordinate.longitude];
        annotation1.coordinate=location1;
        
        [_annArray addObject:annotation1];
        

    }
    
    [_mapView addAnnotations:_annArray];
  }
@end

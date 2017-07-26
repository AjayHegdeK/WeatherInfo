//
//  FirstViewController.h
//  WeatherReport
//
//  Created by K, Akshay on 7/25/17.
//  Copyright © 2017 Ajay Hegde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CityByLocationViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
}
@property(nonatomic,weak) IBOutlet UILabel *humidity;
@property(nonatomic,weak) IBOutlet UILabel *windSpeed;
@property(nonatomic,weak) IBOutlet UILabel *weatherDescription;
@property(nonatomic,weak) IBOutlet UILabel *temp;

@property(nonatomic,weak) IBOutlet UIButton *getForecast;

@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) CLLocation *currentLocation;

@end


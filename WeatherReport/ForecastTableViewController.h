//
//  ForecastTableViewController.h
//  WeatherReport
//
//  Created by K, Akshay on 7/26/17.
//  Copyright © 2017 Ajay Hegde. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForecastTableViewController : UITableViewController
@property(nonatomic, assign) float latitude;
@property(nonatomic, assign) float longitude;
@property(nonatomic, strong) NSString *cityName;

@property(nonatomic, strong) NSArray *forecastList;

@end

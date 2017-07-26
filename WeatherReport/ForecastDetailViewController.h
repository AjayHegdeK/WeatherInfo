//
//  ForecastDetailViewController.h
//  WeatherReport
//
//  Created by K, Akshay on 7/26/17.
//  Copyright © 2017 Ajay Hegde. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForecastDetailViewController : UIViewController

@property(nonatomic, strong) NSDictionary *forecastDetails;
@property(nonatomic,weak) IBOutlet UILabel *humidity;
@property(nonatomic,weak) IBOutlet UILabel *windSpeed;
@property(nonatomic,weak) IBOutlet UILabel *weatherDescription;
@property(nonatomic,weak) IBOutlet UILabel *temp;
@end

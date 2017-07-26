//
//  ForecastDetailViewController.m
//  WeatherReport
//
//  Created by K, Akshay on 7/26/17.
//  Copyright © 2017 Ajay Hegde. All rights reserved.
//

#import "ForecastDetailViewController.h"

@interface ForecastDetailViewController ()

@end

@implementation ForecastDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Forecast";
    // Do any additional setup after loading the view.
    //set all values for weather info
    [self.weatherDescription setText:[[[self.forecastDetails valueForKey:@"weather"] objectAtIndex:0] valueForKey:@"description"]];
    //roundup float value
    float windSpeedRounded = ceilf([[[self.forecastDetails valueForKey:@"wind"] valueForKey:@"speed"] floatValue]);
    [self.windSpeed setText:[NSString stringWithFormat:@"%@ meter/sec",[[NSNumber numberWithFloat:windSpeedRounded] stringValue]]];
    [self.humidity setText:[NSString stringWithFormat:@"%@ %@",[[[self.forecastDetails valueForKey:@"main"]  valueForKey:@"humidity"] stringValue],@"%"]];
    [self.temp setText:[NSString stringWithFormat:@"%@ °C",[[[self.forecastDetails valueForKey:@"main"]  valueForKey:@"temp"] stringValue]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

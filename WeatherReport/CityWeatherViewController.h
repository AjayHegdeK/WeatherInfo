//
//  SecondViewController.h
//  WeatherReport
//
//  Created by K, Akshay on 7/25/17.
//  Copyright © 2017 Ajay Hegde. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityWeatherViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic,weak) IBOutlet UITextField *cityName;

@property(nonatomic,weak) IBOutlet UILabel *humidity;
@property(nonatomic,weak) IBOutlet UILabel *windSpeed;
@property(nonatomic,weak) IBOutlet UILabel *weatherDescription;
@property(nonatomic,weak) IBOutlet UILabel *temp;

-(IBAction)downloadWeatherInfo:(id)sender;


@end


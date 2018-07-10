//
//  SecondViewController.m
//  WeatherReport
//
//  Created by K, Akshay on 7/25/17.
//  Copyright © 2017 Ajay Hegde. All rights reserved.
//

#import "CityWeatherViewController.h"
#import "Constant.h"
#import "ForecastTableViewController.h"
#import "Reachability.h"

@interface CityWeatherViewController ()

@end

@implementation CityWeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.temp setText:@""];
    [self.humidity setText:@""];
    [self.windSpeed setText:@""];
    [self.weatherDescription setText:@""];
    
    //register textfield delegate
    self.cityName.delegate=self;
    
    // set header title and child view controllers back button title
    self.navigationItem.title = @"City Weather";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    //resign responder keyboard on viewdidappear if keyboard is open
    [self.cityName resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//API call to openweathermap.org to fetch weather info based on city name entered in textbox
-(IBAction)downloadWeatherInfo:(id)sender  {
    //resign text field on click of weather info button
    [self.cityName resignFirstResponder];
    //handle offline
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        [self showAlert:@"Server communication error. Please check your internet connection" AndTitle:@"Network error!"];
    } else {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        if (self.cityName.text.length > 0) {
            // string url with city name and specified units for weather info as metric using constant file
            // these data are loaded using constant file
            NSString *urlString  = [NSString stringWithFormat:@"%@%@%@&APPID=%@",KCityName,self.cityName.text,kUnits,kAPIKey];
            [request setURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"GET"];
            //NSURLSession APi to fetch json data
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (!error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // do work here
                        NSError *jsonError = nil;
                        //json serialization
                        NSDictionary  *cityNames = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                        if (!jsonError) {
                            NSLog(@"cod %@",[cityNames objectForKey:@"weather"]);
                            if ([cityNames objectForKey:@"weather"]) {
                                //set all values
                                [self.weatherDescription setText:[[[cityNames valueForKey:@"weather"] objectAtIndex:0] valueForKey:@"description"]];
                                //round up floating pont value
                                float windSpeedRounded = ceilf([[[cityNames valueForKey:@"wind"] valueForKey:@"speed"] floatValue]);
                                [self.windSpeed setText:[NSString stringWithFormat:@"%@ meter/sec",[[NSNumber numberWithFloat:windSpeedRounded] stringValue]]];
                                [self.humidity setText:[NSString stringWithFormat:@"%@ %@",[[[cityNames valueForKey:@"main"]  valueForKey:@"humidity"] stringValue],@"%"]];
                                [self.temp setText:[NSString stringWithFormat:@"%@ °C",[[[cityNames valueForKey:@"main"]  valueForKey:@"temp"] stringValue]]];
                            } else {
                                 [self showAlert:@"Please enter valid city name" AndTitle:@"Invalid input!"];
                            }
                            
                        } else {
                            NSLog(@"Error parsing JSON: %@", jsonError);
                        }
                    });
                } else {
                    NSLog(@"Error in downloading JSON: %@", error);
                }
                
            }] resume];
        } else {
            [self showAlert:@"Please enter valid city name" AndTitle:@"Invalid input!"];
        }
    }
   
}

//prepare segue for forward declaration pass values needed
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //resign responder when navigate to next view
    [self.cityName resignFirstResponder];
    ForecastTableViewController *vc = [segue destinationViewController];
    if (self.cityName.text.length > 0) {
        vc.cityName = self.cityName.text;
    }
}

#pragma mark - Alert Controller
//alert  here used for invalid input
- (void)showAlert:(NSString *)msg AndTitle:(NSString*)title {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end

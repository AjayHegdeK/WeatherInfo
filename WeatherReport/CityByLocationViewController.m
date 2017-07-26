//
//  FirstViewController.m
//  WeatherReport
//
//  Created by K, Akshay on 7/25/17.
//  Copyright © 2017 Ajay Hegde. All rights reserved.
//

#import "CityByLocationViewController.h"
#import "Constant.h"
#import "ForecastTableViewController.h"
#import "Reachability.h"

@interface CityByLocationViewController ()

@end

@implementation CityByLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // set header title and child view controllers back button title
    self.navigationItem.title = @"Weather Info";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    //show button on load
    [self.getForecast setEnabled:YES];
    [self.getForecast setAlpha:1.0];
}

-(void)viewDidAppear:(BOOL)animated {
    //set empty intial value for weather info
    [self.temp setText:@""];
    [self.humidity setText:@""];
    [self.windSpeed setText:@""];
    [self.weatherDescription setText:@""];
    
    //Use corelocation framework to get GPS location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    //button: hide if corredinates are not fetched
    [self.getForecast setAlpha:0.5];
    [self.getForecast setEnabled:NO];
    [self showAlert:@"Failed to Get Your Location" AndTitle:@"Network error!"];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //get current location coordinates
    self.currentLocation = newLocation;
    
    if (self.currentLocation != nil) {
        [self.getForecast setAlpha:1.0];
        [self.getForecast setEnabled:YES];
        [self performSelector:@selector(getCurrentWeatherInfo:) withObject:self.currentLocation];
    } else {
        [self showAlert:@"Failed to Get Your Location" AndTitle:@"Network error!"];
    }
    [self.locationManager stopUpdatingLocation];
}

//API call to openweathermap.org to fetch weather info based on current location
-(void)getCurrentWeatherInfo:(CLLocation *) currentLocation {
    //handle offline
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        [self showAlert:@"Server communication error. Please check your internet connection" AndTitle:@"Network error!"];
    } else {
        if (currentLocation) {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            // string url with city by location and specified units for weather info as metric using constant file
            // these data are loaded using constant file
            NSString *urlString  = [NSString stringWithFormat:@"%@lat=%lf&lon=%lf%@&APPID=%@",KCurrentCity,currentLocation.coordinate.latitude,currentLocation.coordinate.longitude,kUnits,kAPIKey];
            [request setURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"GET"];
            
            //NSURLsession usage to fetch json data
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (!error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSError *jsonError = nil;
                        //Json serialization
                        NSDictionary  *cityNames = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                        if (!jsonError) {
                            //set all values after data is fetched in main queue
                            [self.weatherDescription setText:[[[cityNames valueForKey:@"weather"] objectAtIndex:0] valueForKey:@"description"]];
                            //round up floating pont value
                            float windSpeedRounded = ceilf([[[cityNames valueForKey:@"wind"] valueForKey:@"speed"] floatValue]);
                            [self.windSpeed setText:[NSString stringWithFormat:@"%@ meter/sec",[[NSNumber numberWithFloat:windSpeedRounded] stringValue]]];
                            [self.humidity setText:[NSString stringWithFormat:@"%@ %@",[[[cityNames valueForKey:@"main"]  valueForKey:@"humidity"] stringValue],@"%"]];
                            [self.temp setText:[NSString stringWithFormat:@"%@ °C",[[[cityNames valueForKey:@"main"]  valueForKey:@"temp"] stringValue]]];
                        } else {
                            NSLog(@"Error parsing JSON: %@", jsonError);
                        }
                    });
                } else {
                    NSLog(@"Error in downloading JSON: %@", error);
                }
                
            }] resume];
            
        } else {
            [self showAlert:@"Failed to Get Your Location" AndTitle:@"Network error!"];
        }

    }
    
}

//prepare segue for forward declaration pass values needed
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ForecastTableViewController *vc = [segue destinationViewController];
    vc.latitude = self.currentLocation.coordinate.latitude;
    vc.longitude = self.currentLocation.coordinate.longitude;
}

#pragma mark - Alert Controller
//alert  here used for network failure
- (void)showAlert:(NSString *)msg AndTitle:(NSString*)title {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end

//
//  ForecastTableViewController.m
//  WeatherReport
//
//  Created by K, Akshay on 7/26/17.
//  Copyright © 2017 Ajay Hegde. All rights reserved.
//

#import "ForecastTableViewController.h"
#import "Constant.h"
#import "ForecastDetailViewController.h"
#import "Reachability.h"

@interface ForecastTableViewController ()

@end

@implementation ForecastTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set header title and child view controllers back button title
    self.navigationItem.title = @"Forecast for 5 days";
    [self downloadForecastInfo];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
}
//API call to openweathermap.org to fetch weather forecast for 5 days with every 3 hour info
-(void)downloadForecastInfo {
    //handle offline
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        [self showAlert:@"Server communication error. Please check your internet connection" AndTitle:@"Network error!"];
    } else {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSString *urlString;
        
        // set string based on city name or currentlocation coordinates
        if (self.cityName.length > 0) {
            urlString = [NSString stringWithFormat:@"%@%@%@&APPID=%@",KCityForecast,self.cityName,kUnits,kAPIKey];
        } else {
            urlString  = [NSString stringWithFormat:@"%@lat=%lf&lon=%lf%@&APPID=%@",KCurrentForecast,self.latitude,self.longitude,kUnits,kAPIKey];
        }
        
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"GET"];
        
        //NSURLSession to fetch json data
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // do work here
                    NSError *jsonError = nil;
                    //json serialization
                    NSDictionary  *cityNames = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                    if (!jsonError) {
                        self.forecastList = [cityNames valueForKey:@"list"];
                        //set all values
                        [self.tableView reloadData];
                        
                    } else {
                        NSLog(@"Error parsing JSON: %@", jsonError);
                    }
                });
            } else {
                NSLog(@"Error in downloading JSON: %@", error);
            }
            
        }] resume];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.forecastList.count;
}

//load the table view with every 3 hour info by using date and time
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"forecastCell" forIndexPath:indexPath];
    
    // Configure the cell...
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.textLabel.text = [[self.forecastList objectAtIndex:indexPath.row] valueForKey:@"dt_txt"];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

//prepare segue for forward declaration pass values needed
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ForecastDetailViewController *controller = [segue destinationViewController];
        if (self.forecastList.count > 0) {
            [controller setForecastDetails:[self.forecastList objectAtIndex:indexPath.row]];
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

@end

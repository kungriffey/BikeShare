//
//  BikeShareLocations.m
//  BMBikeShareApplication
//
//  Created by Kunwardeep Gill on 2015-05-05.
//  Copyright (c) 2015 ProjectDGW. All rights reserved.
//

#import "BikeShareLocationsManager.h"

@implementation BikeShareLocationsManager
{
  NSMutableArray *stationData;
}

- (instancetype)init
{
  self = [super init];
  if (self)
  {
    self.http = [[HTTPCommunication alloc] init];
    
  }
  return self;
}

- (void)listOfLocationsSucess:(void (^)(NSArray *results))sucess
{
  
    //Retrieve the Jokes using the HTTP Communication
  NSURL *url = [NSURL URLWithString:@"http://www.bikesharetoronto.com/stations/json"];
  [self.http retreiveURL:url sucessBlock:^(NSData *response) {
    NSError *error = nil;
    
    //De-serialize the information from the API
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
    
    if(!error){
      NSArray *results = [data valueForKey:@"stationBeanList"];
      
      stationData = [[NSMutableArray alloc]init];
      for (NSDictionary *resultsDictionary in results) {
        
        BikeShareLocation *station = [[BikeShareLocation alloc] init];
        
        station.stationID = [resultsDictionary objectForKey:@"id"];
        station.stationName = [resultsDictionary objectForKey:@"stationName"];
        station.stationAvailableBikes = [resultsDictionary objectForKey:@"availableBikes"];
        //station.subtitle = [resultsDictionary objectForKey:@"availableBikes"];
        station.stationAvailableDocks = [resultsDictionary objectForKey:@"availableDocks"];
        
        station.stationLatitude = [resultsDictionary objectForKey:@"latitude"];
        station.stationLongtitude = [resultsDictionary objectForKey:@"longitude"];
        station.coordinate = CLLocationCoordinate2DMake([station.stationLatitude doubleValue], [station.stationLongtitude doubleValue]);
        
        station.title = [resultsDictionary objectForKey:@"stationName"];
        station.subtitle = [NSString stringWithFormat:@"Bikes Avail. %@  Empty Docks: %@",[station.stationAvailableBikes stringValue], [station.stationAvailableDocks stringValue]];
        
        [stationData addObject:station];
      }

        sucess(stationData);

    }
  }];
}

@end

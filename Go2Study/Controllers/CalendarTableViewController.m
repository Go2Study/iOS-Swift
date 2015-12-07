//
//  CalendarTableViewController.m
//  Go2Study
//
//  Created by Ashish Kumar on 07/12/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

#import "CalendarTableViewController.h"
#import "Go2Study-Swift.h"

@interface Event : NSObject 
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@end
@implementation Event
@end

@interface CalendarTableViewController() <FontysClientDelegate>

@property (nonatomic, strong) FontysClient *fontysClient;
@property (nonatomic, strong) NSMutableArray *events;
@property (strong, nonatomic) NSMutableDictionary *sections;
@property (strong, nonatomic) NSArray *sortedDays;
@property (strong, nonatomic) NSDateFormatter *sectionDateFormatter;
@property (strong, nonatomic) NSDateFormatter *cellDateFormatter;

@end

@implementation CalendarTableViewController


- (FontysClient *)fontysClient {
    _fontysClient = [[FontysClient alloc] init];
    _fontysClient.delegate = self;
    return _fontysClient;
}

- (NSMutableArray *)events {
    if (!_events) {
        _events = [[NSMutableArray alloc] init];
    }
    return _events;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.fontysClient getSchedule:@"Teacher" query:self.personalTitle];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    return [eventsOnThisDay count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    return [self.sectionDateFormatter stringFromDate:dateRepresentingThisDay];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CalendarEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CalendarEventCell"];
    
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    Event *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    
    cell.name.text = event.name;
    cell.location.text = event.location;
    cell.time.text = [self.cellDateFormatter stringFromDate:event.startDate];
    
    return cell;
}


#pragma mark - FontysClientDelegate

- (void)fontysClient:(FontysClient *)client didFailWithOAuthError:(NSInteger)errorCode {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate refreshFontysAccessToken];
}

- (void)fontysClient:(FontysClient *)client didGetSchedule:(NSData *)schedule forKind:(NSString *)kind query:(NSString *)query {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:schedule options:NSJSONReadingAllowFragments error:&error];
    
    if (error) {
        NSLog(@"%@", error);
    }
    
    NSArray *jsonArray = [json objectForKey:@"data"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    
    for (NSDictionary *eventDictionary in jsonArray) {
        Event *event = [[Event alloc] init];
        event.name      = [eventDictionary objectForKey:@"subject"];
        event.location  = [eventDictionary objectForKey:@"room"];
        event.startDate = [dateFormatter dateFromString:[eventDictionary objectForKey:@"start"]];
        event.endDate   = [dateFormatter dateFromString:[eventDictionary objectForKey:@"end"]];
        
        [self.events addObject:event];
    }
    
    [self processEvents];
}

#pragma mark - Private

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate {
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    calendar.timeZone = timeZone;
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:inputDate];
    
    // Set the time components manually
    dateComps.hour   = 0;
    dateComps.minute = 0;
    dateComps.second = 0;
    
    // Convert back
    return [calendar dateFromComponents:dateComps];;
}

- (void)processEvents {
    self.sections = [NSMutableDictionary dictionary];
    for (Event *event in self.events) {
        // Reduce event start date to date components (year, month, day)
        NSDate *dateRepresentingThisDay = [self dateAtBeginningOfDayForDate:event.startDate];
        
        // If we don't yet have an array to hold the events for this day, create one
        NSMutableArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
        if (eventsOnThisDay == nil) {
            eventsOnThisDay = [NSMutableArray array];
            
            // Use the reduced date as dictionary key to later retrieve the event list this day
            [self.sections setObject:eventsOnThisDay forKey:dateRepresentingThisDay];
        }
        
        // Add the event to the list for this day
        [eventsOnThisDay addObject:event];
    }
    
    NSArray *unsortedDays = [self.sections allKeys];
    self.sortedDays = [unsortedDays sortedArrayUsingSelector:@selector(compare:)];
    
    self.sectionDateFormatter = [[NSDateFormatter alloc] init];
    [self.sectionDateFormatter setDateStyle:NSDateFormatterLongStyle];
    [self.sectionDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.cellDateFormatter = [[NSDateFormatter alloc] init];
    [self.cellDateFormatter setDateStyle:NSDateFormatterNoStyle];
    [self.cellDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    [self.tableView reloadData];
}

@end

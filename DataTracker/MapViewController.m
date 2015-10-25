//
//  MapViewController.m
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-05-04.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import "MapViewController.h"
#import "DataManagement.h"
#import <CCHMapClusterController.h>

@interface MapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) CCHMapClusterController *mapClusterController;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.map.showsUserLocation=YES;
    self.map.delegate = self;
    
    self.navigationItem.title=@"MAP";
    
    NSArray *locations = [[NSArray alloc] initWithArray:[[DataManagement sharedInstance] locations]];
    self.mapClusterController = [[CCHMapClusterController alloc] initWithMapView:self.map];
    [self.mapClusterController addAnnotations:locations withCompletionHandler:NULL];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    NSInteger hour = [components hour];
    self.slider.minimumValue = 0;
    //self.slider.maximumValue = hour;
    self.slider.maximumValue = 24;
    self.dataDate = [NSDate date];
    self.dataDateFormatter=[[NSDateFormatter alloc] init];
    [self.dataDateFormatter setDateFormat:@"EEEE, MMM dd, yyyy"];
    NSLog(@"Date is: %@",[self.dataDateFormatter stringFromDate:self.dataDate]);
    self.dateLabel.text = [NSString stringWithFormat:@"%@",[self.dataDateFormatter stringFromDate:self.dataDate]];
    
    /*
    NSArray *addAnnotationArray = [self CDgetAnnotationArray:self.dataDate];
    [self.map addAnnotations:addAnnotationArray];
     */
    
    /*
    MKMapPoint annotationPoint = MKMapPointForCoordinate(self.map.userLocation.coordinate);
    MKMapRect zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
    [self.map setVisibleMapRect:zoomRect animated:YES];
    */
    //[self updateMapAnnotations];
    
    NSArray *addAnnotationArray = [self CDgetAnnotationArray:self.dataDate];
    [self.map showAnnotations:addAnnotationArray animated:NO];
    
    #pragma mark -TEST
    CLLocationManager *locationManager;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
    //float latitude = locationManager.location.coordinate.latitude;
    //float longitude = locationManager.location.coordinate.longitude;
    float latitude = 60.0f;
    float longitude = -110.0f;
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    annotation.title = [NSString stringWithFormat:@"%.1f MB", 32.1];
    
    [self.map addAnnotation:annotation];
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    
    for (int i=0;i< [mapView.annotations count];i++)
    {
        id annotation = [mapView.annotations objectAtIndex:i];
        
        MKAnnotationView* annView =[mapView viewForAnnotation: annotation];
        if (annView != nil)
        {
            
            CALayer* layer = annView.layer;
            [layer removeAllAnimations];
        }
        
    }
}

-(void)viewDidAppear:(BOOL)animated{
    NSArray *addAnnotationArray = [self CDgetAnnotationArray:self.dataDate];
    [self.map showAnnotations:addAnnotationArray animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {

    NSArray *addAnnotationArray = [self CDgetAnnotationArray:self.dataDate];
    [self.map showAnnotations:addAnnotationArray animated:NO];
    
    
    
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    /*
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.map.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.01f;
    mapRegion.span.longitudeDelta = 0.01f;
    [self.map regionThatFits:mapRegion];
    [self.map setRegion:mapRegion animated:NO];
    */
    //[self updateMapAnnotations];

}

-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)accuracyChanged:(id)sender
{
    NSLog(@"segmentcontrol changed");
}

- (IBAction)enabledStateChanged:(id)sender {

}

- (IBAction)testButtonAction:(id)sender {
    /*
    NSLog(@"TEST BUTTON PRESSED");
    NSMutableArray *locations = [[NSMutableArray alloc] initWithArray:[[DataManagement sharedInstance] locations]];
    NSMutableArray *locations2 = [[NSMutableArray alloc] initWithArray:[[DataManagement sharedInstance] locations2]];
    
    for (MKPointAnnotation *annotation in locations) {
        NSLog(@"Location is: %@", annotation);
        //[self.map addAnnotation:annotation];
    }
    for (NSNumber *num in locations2) {
        NSLog(@"%@", num);
    }
    [self.mapClusterController addAnnotations:locations withCompletionHandler:NULL];
    */
    [self.map removeAnnotations:[self.map annotations]];

    
}


-(void)updateMapAnnotations{
    [self.map removeAnnotations:[self.map annotations]];
    NSArray *addAnnotationArray = [self CDgetAnnotationArray:self.dataDate];
    [self.map addAnnotations:addAnnotationArray];
    
    /*
    //Zoom to fit annotations
    MKMapPoint annotationPoint = MKMapPointForCoordinate(self.map.userLocation.coordinate);
    MKMapRect zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
    for (id <MKAnnotation> annotation in self.map.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [self.map setVisibleMapRect:zoomRect animated:YES];
     */
    [self.map showAnnotations:addAnnotationArray animated:NO];
}


- (IBAction)sliderValueChanged:(ASValueTrackingSlider *)sender {
    /*
    NSLog(@"Slider value is %f", self.slider.value);
    NSMutableArray *CDAnnotationArray = [[DataManagement sharedInstance] CDSearchAnnotation:self.dataDate];
    
    
    NSArray *oldAnnotations=[self.map annotations];
    //NSLog(@"oldannotations is: %lu and addannotationsis: %lu", (unsigned long)oldAnnotations.count, (unsigned long)addAnnotationArray.count);
    
    int hours = (int)self.slider.value;
    int minutes = (int)((self.slider.value - hours) * 60);
    
    NSDate* result;
    NSDate* today = self.dataDate;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components: NSUIntegerMax fromDate: today];
    [comps setMinute:minutes];
    [comps setHour:hours];
    result = [gregorian dateFromComponents:comps];
    NSLog(@"Slider date is: %@", result);
    NSMutableArray *addAnnotationArray = [[NSMutableArray alloc] init];
    
    for (NSManagedObject *obj in CDAnnotationArray) {
        
        NSDate *date = [obj valueForKey:@"date"];
        double latitude = [[obj valueForKey:@"latitude"] doubleValue];
        double longitude = [[obj valueForKey:@"longitude"] doubleValue];
        float wan = [[obj valueForKey:@"wan"] floatValue];
        float wifi = [[obj valueForKey:@"wifi"] floatValue];
        NSLog(@"Annotation object in core data with: date %@, lat %f, long %f, wan %f, wifi %f", date, latitude, longitude, wan, wifi);
        
        
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        annotation.title = [NSString stringWithFormat:@"%.1f MB", wan/100000];
        
        if([result timeIntervalSinceDate:date] > 0){
            NSLog(@"result timeIntervalSinceDate:date in core data with: date %@, lat %f, long %f, wan %f, wifi %f", date, latitude, longitude, wan, wifi);
            //[self.map addAnnotation:annotation];
            [addAnnotationArray addObject:annotation];
        }
    }
    
    NSLog(@"oldAnnotation count is: %lu and addAnotationArray count is: %lu", (unsigned long)[self.map annotations].count-1, (unsigned long)addAnnotationArray.count);
    if (([self.map annotations].count - 1) > addAnnotationArray.count) {
        for (int i = 0; i < ([self.map annotations].count - 1) - addAnnotationArray.count; i++) {
            [self.map removeAnnotation:[self.map annotations].lastObject];
        }
    }
    else if(addAnnotationArray.count > ([self.map annotations].count - 1)){
        NSLog(@"2 oldAnnotation count is: %lu and addAnotationArray count is: %lu", (unsigned long)[self.map annotations].count-1, (unsigned long)addAnnotationArray.count);
        //for (int i = 0; i < addAnnotationArray.count - ([self.map annotations].count - 1); i++) {
        [addAnnotationArray removeObjectsInRange:NSMakeRange(0, ([self.map annotations].count - 1))];
        //}
        [self.map addAnnotations:addAnnotationArray];
    }
    */
}

-(NSArray *)CDgetAnnotationArray:(NSDate *)dataDate{
    NSMutableArray *annotationArray = [[DataManagement sharedInstance] CDSearchAnnotation:dataDate];
    NSMutableArray *addAnnotationArray = [[NSMutableArray alloc] init];
    for (NSManagedObject *obj in annotationArray) {
        NSDate *date = [obj valueForKey:@"date"];
        double latitude = [[obj valueForKey:@"latitude"] doubleValue];
        double longitude = [[obj valueForKey:@"longitude"] doubleValue];
        float wan = [[obj valueForKey:@"wan"] floatValue];
        float wifi = [[obj valueForKey:@"wifi"] floatValue];
        //NSLog(@"Annotation object in core data with: date %@, lat %f, long %f, wan %f, wifi %f", date, latitude, longitude, wan, wifi);
        
        
        
        //NSLog(@"Date corresponding to slider is: %@", result);
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        annotation.title = [NSString stringWithFormat:@"%.1f MB", wan/100000];
        [addAnnotationArray addObject:annotation];
        
        /*
        if([result timeIntervalSinceDate:date] > 0){
            NSLog(@"result timeIntervalSinceDate:date in core data with: date %@, lat %f, long %f, wan %f, wifi %f", date, latitude, longitude, wan, wifi);
            [addAnnotationArray addObject:annotation];
        }
         */
        
    }
    return addAnnotationArray;
}

-(void)displayFull{
    NSLog(@"Free date exceeded");
    self.fullView.hidden = NO;
    self.map.hidden = YES;
}

-(void)dismissFull{
    NSLog(@"Dismiss full and show map");
    self.map.hidden = NO;
    self.fullView.hidden = YES;
}

- (IBAction)prevButton:(id)sender {
    
#ifdef FREE
    NSLog(@"Free version!");
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    NSLog(@"Days between date are %d.",[[DataManagement sharedInstance] daysBetweenDate:self.dataDate andDate:[NSDate date]]);
    if ([[DataManagement sharedInstance] daysBetweenDate:self.dataDate andDate:[NSDate date]] == 3){
        NSLog(@"Days between date are 3");
        [dateComponents setDay:-1];
        self.dataDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self.dataDate options:0];
        self.dateLabel.text = [NSString stringWithFormat:@"%@",[self.dataDateFormatter stringFromDate:self.dataDate]];
        [self displayFull];
    }
    else if ([[DataManagement sharedInstance] daysBetweenDate:self.dataDate andDate:[NSDate date]] > 2) {
        [self displayFull];
    }
    else{
        [self dismissFull];
        [dateComponents setDay:-1];
        self.dataDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self.dataDate options:0];
        self.dateLabel.text = [NSString stringWithFormat:@"%@",[self.dataDateFormatter stringFromDate:self.dataDate]];
        [self updateMapAnnotations];
    }
#else
    NSLog(@"Paid version!");
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-1];
    self.dataDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self.dataDate options:0];
    self.dateLabel.text = [NSString stringWithFormat:@"%@",[self.dataDateFormatter stringFromDate:self.dataDate]];
    [self updateMapAnnotations];
#endif
}

- (IBAction)nextButton:(id)sender {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:+1];
    if ([[DataManagement sharedInstance] daysBetweenDate:self.dataDate andDate:[NSDate date]] <= 0) {
        NSLog(@"No point looking into the future!");
    }
    else{
        [self dismissFull];
        self.dataDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self.dataDate options:0];
        self.dateLabel.text = [NSString stringWithFormat:@"%@",[self.dataDateFormatter stringFromDate:self.dataDate]];
        [self updateMapAnnotations];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

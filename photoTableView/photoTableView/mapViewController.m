//
//  mapViewController.m
//  photoTableView
//
//  Created by lovocas on 13-6-9.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "mapViewController.h"
#import "mapkit/mapkit.h"

@interface mapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation mapViewController
@synthesize mapView = _mapView;
@synthesize annotationArray = _annotationArray;
@synthesize imagedelegate = _imagedelegate;
-(void)updateMapView
{
    if(self.mapView.annotations)
        [self.mapView removeAnnotations:self.mapView.annotations];
    if(self.annotationArray)
        [self.mapView addAnnotations:self.annotationArray];
 }

-(void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
}
-(void)setAnnotationArray:(NSArray *)annotationArray
{
    _annotationArray = annotationArray;
    [self updateMapView];
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView * aview = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVc"];
    if(!aview)
    {
        aview = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"MapVc"];
        aview.canShowCallout = YES;
        aview.leftCalloutAccessoryView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    }
    aview.annotation = annotation;
    [(UIImageView *)aview.leftCalloutAccessoryView  setImage:nil];
    return aview;
}
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    UIImage * image = [self.imagedelegate mapViewController:self imageforAnnotation:view.annotation];
    [(UIImageView *)view.leftCalloutAccessoryView  setImage:image];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

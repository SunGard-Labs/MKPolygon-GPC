//
// SCSViewController.m
// MKPolygon-GPC-Example
//
// Created by Justin Leger on 1/31/14.
// Copyright (c) 2014 SunGard Consulting Services
// 		  ___           ___           ___
// 		 /  /\         /  /\         /  /\
// 		/  /::\       /  /::\       /  /::\
// 	   /__/:/\:\     /  /:/\:\     /__/:/\:\
// 	  _\_ \:\ \:\   /  /:/  \:\   _\_ \:\ \:\
// 	 /__/\ \:\ \:\ /__/:/ \  \:\ /__/\ \:\ \:\
// 	 \  \:\ \:\_\/ \  \:\  \__\/ \  \:\ \:\_\/
// 	  \  \:\_\:\    \  \:\        \  \:\_\:\
// 	   \  \:\/:/     \  \:\        \  \:\/:/
// 		\  \::/       \  \:\        \  \::/
// 		 \__\/         \__\/         \__\/
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "SCSViewController.h"
#import "MKPolygon+GPC.h"

@interface SCSViewController ()

@property (nonatomic, retain) MKPolygon * smallPolygon;
@property (nonatomic, retain) MKPolygon * largePolygon;

- (IBAction) doResetAction;
- (IBAction) doUnionAction;
- (IBAction) doIntersectAction;

@end

@implementation SCSViewController

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CLLocationCoordinate2D smallCoords[5]={
        CLLocationCoordinate2DMake(32.90326286667526, -96.95913076400757),
        CLLocationCoordinate2DMake(32.89758776328932, -96.9676923751831),
        CLLocationCoordinate2DMake(32.89659683493188, -96.96674823760986),
        CLLocationCoordinate2DMake(32.89623649459879, -96.96541786193848),
        CLLocationCoordinate2DMake(32.896200460484856, -96.95921659469604)
	};
    
    self.smallPolygon = [MKPolygon polygonWithCoordinates:smallCoords count:5];
    self.smallPolygon.title = @"Small";
    
    CLLocationCoordinate2D largeCoords[16]={
        CLLocationCoordinate2DMake(32.907550481378806, -96.95262908935547),
        CLLocationCoordinate2DMake(32.899983962409, -96.96419477462769),
        CLLocationCoordinate2DMake(32.897533712937495, -96.96228504180908),
        CLLocationCoordinate2DMake(32.896200460484856, -96.96215629577637),
        CLLocationCoordinate2DMake(32.89621847754366, -96.95247888565063),
        CLLocationCoordinate2DMake(32.89742561213491, -96.95273637771606),
        CLLocationCoordinate2DMake(32.898020164916566, -96.95329427719116),
        CLLocationCoordinate2DMake(32.89892099486004, -96.95413112640381),
        CLLocationCoordinate2DMake(32.9001280926199, -96.9544529914856),
        CLLocationCoordinate2DMake(32.901299141888245, -96.95417404174805),
        CLLocationCoordinate2DMake(32.902145890943714, -96.95361614227295),
        CLLocationCoordinate2DMake(32.902812474930236, -96.95275783538818),
        CLLocationCoordinate2DMake(32.90353310062274, -96.95189952850342),
        CLLocationCoordinate2DMake(32.904614028166144, -96.95136308670044),
        CLLocationCoordinate2DMake(32.90567692738386, -96.95134162902832),
        CLLocationCoordinate2DMake(32.90679385857614, -96.95181369781494)
	};
    
    self.largePolygon = [MKPolygon polygonWithCoordinates:largeCoords count:16];
    self.largePolygon.title = @"Large";
    
    //Define map view region
    MKCoordinateSpan span;
	span.latitudeDelta=.02;
	span.longitudeDelta=.02;
    
	MKCoordinateRegion region;
	region.span=span;
	region.center=CLLocationCoordinate2DMake(32.898507, -96.960268);
    
    [_myMapView setRegion:region animated:YES];
	[_myMapView regionThatFits:region];
    
    [self doResetAction];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.myMapView = nil;
    self.resetButton = nil;
    self.unionButton = nil;
    self.subtractButton = nil;
}

// Dispose of any resources that can be recreated.
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - MKMapView Delegate Handlers

-(MKOverlayRenderer *) mapView:(MKMapView *) mapView rendererForOverlay:(id<MKOverlay>) overlay
{
    if( [overlay isKindOfClass:[MKPolygon class]] )
    {
        MKPolygon * polygon = (MKPolygon *) overlay;
        MKPolygonRenderer * overlayRenderer = [[MKPolygonRenderer alloc] initWithPolygon:polygon];
        overlayRenderer.lineWidth = 1;
        
        if ([polygon.title isEqualToString:@"Small"]) {
            overlayRenderer.strokeColor = [UIColor blueColor];
        } else if ([polygon.title isEqualToString:@"Large"]) {
            overlayRenderer.strokeColor = [UIColor redColor];
        } else {
            overlayRenderer.strokeColor = [UIColor greenColor];
        }
        
        overlayRenderer.fillColor = [overlayRenderer.strokeColor colorWithAlphaComponent:0.5];
        return overlayRenderer;
    }
    
    return nil;
}


#pragma mark - Button Action Handlers

- (IBAction) doResetAction
{
    [self.myMapView removeOverlays:[self.myMapView overlays]];
    [self.myMapView addOverlay:self.smallPolygon];
    [self.myMapView addOverlay:self.largePolygon];
}

- (IBAction) doUnionAction
{
    [self.myMapView removeOverlays:[self.myMapView overlays]];
    MKPolygon * newPolygon = [self.smallPolygon polygonFromUnionWithPolygon:self.largePolygon];
    [self.myMapView addOverlay:newPolygon];
}

- (IBAction) doIntersectAction
{
    [self.myMapView removeOverlays:[self.myMapView overlays]];
    MKPolygon * newPolygon = [self.smallPolygon polygonFromIntersectionWithPolygon:self.largePolygon];
    [self.myMapView addOverlay:newPolygon];
    
}

@end

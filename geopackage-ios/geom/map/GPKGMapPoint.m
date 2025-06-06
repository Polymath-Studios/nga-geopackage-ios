//
//  GPKGMapPoint.m
//  geopackage-ios
//
//  Created by Brian Osborn on 6/22/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGMapPoint.h>

@implementation GPKGMapPoint

static NSUInteger idCounter = 0;

- (id)initWithLocation: (CLLocationCoordinate2D) coord {
    self = [super init];
    if (self) {
        self.coordinate = coord;
        self.id = idCounter++;
        self.options = [[GPKGMapPointOptions alloc] init];
    }
    return self;
}

- (id)initWithLatitude: (double) latitude andLongitude: (double) longitude {
    CLLocationCoordinate2D theCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    return [self initWithLocation:theCoordinate];
}

- (id)initWithPoint: (SFPoint *) point {
    return [self initWithLatitude:[point.y doubleValue] andLongitude:[point.x doubleValue]];
}

- (id)initWithMKMapPoint: (MKMapPoint) point {
    CLLocationCoordinate2D coord = MKCoordinateForMapPoint(point);
    return [self initWithLocation:coord];
}

-(NSNumber *) idAsNumber{
    return [NSNumber numberWithInteger:self.id];
}

-(void) hidden: (BOOL) hidden{
    if(self.view != nil){
        self.view.hidden = hidden;
    }
}

@end

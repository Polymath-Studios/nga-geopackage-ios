//
//  GPKGMultiPolylinePoints.m
//  geopackage-ios
//
//  Created by Brian Osborn on 6/19/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGMultiPolylinePoints.h>
#import <GeoPackage/GPKGUtils.h>

@implementation GPKGMultiPolylinePoints

-(instancetype) init{
    self = [super init];
    if(self != nil){
        self.polylinePoints = [NSMutableArray array];
    }
    return self;
}

-(void) addPolylinePoints: (GPKGPolylinePoints *) polylinePoint{
    [GPKGUtils addObject:polylinePoint toArray:self.polylinePoints];
}

-(void) updateWithMapView: (MKMapView *) mapView{
    for(GPKGPolylinePoints *polylinePoint in self.polylinePoints){
        [polylinePoint updateWithMapView:mapView];
    }
}

-(void) removeFromMapView: (MKMapView *) mapView{
    for(GPKGPolylinePoints *polylinePoint in self.polylinePoints){
        [polylinePoint removeFromMapView:mapView];
    }
}

-(void) hidden: (BOOL) hidden fromMapView: (MKMapView *) mapView{
    for(GPKGPolylinePoints *polylinePoint in self.polylinePoints){
        [polylinePoint hidden:hidden fromMapView:mapView];
    }
}

-(BOOL) isValid{
    BOOL valid = YES;
    for(GPKGPolylinePoints *polylinePoint in self.polylinePoints){
        valid = [polylinePoint isValid];
        if(!valid){
            break;
        }
    }
    return valid;
}

-(BOOL) isDeleted{
    BOOL deleted = YES;
    for(GPKGPolylinePoints *polylinePoint in self.polylinePoints){
        deleted = [polylinePoint isDeleted];
        if(!deleted){
            break;
        }
    }
    return deleted;
}

@end

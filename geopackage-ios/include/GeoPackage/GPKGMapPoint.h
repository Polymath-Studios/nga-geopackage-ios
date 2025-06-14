//
//  GPKGMapPoint.h
//  geopackage-ios
//
//  Created by Brian Osborn on 6/22/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGMapPointOptions.h>
#import <SimpleFeatures/SimpleFeatures.h>

/**
 *  Map point annotation
 */
@interface GPKGMapPoint : NSObject<MKAnnotation>

/**
 *  Coordinate location
 */
@property (nonatomic) CLLocationCoordinate2D coordinate;

/**
 *  Title and subtitle
 */
@property (nonatomic, copy) NSString *title, *subtitle;

/**
 *  Map Point unique id
 */
@property (nonatomic) NSUInteger id;

/**
 *  Map point options
 */
@property (nonatomic, strong) GPKGMapPointOptions *options;

/**
 *  Additional map point data stored with the point, any type of object may be stored
 */
@property (nonatomic, strong) NSObject *data;

/**
 *  Map annotation view
 */
@property (nonatomic, strong) MKAnnotationView *view;

/**
 *  Initialize with coordinate
 *
 *  @param coord coordinate
 *
 *  @return new map point
 */
- (id)initWithLocation:(CLLocationCoordinate2D)coord;

/**
 *  Initialize with lat and lon
 *
 *  @param latitude  latitude
 *  @param longitude longitude
 *
 *  @return new map point
 */
- (id)initWithLatitude: (double) latitude andLongitude: (double) longitude;

/**
 *  Initialize with well-known binary point
 *
 *  @param point wkb point
 *
 *  @return new map point
 */
- (id)initWithPoint: (SFPoint *) point;

/**
 *  Initialize with MapKit map point
 *
 *  @param point MK map point
 *
 *  @return new map point
 */
- (id)initWithMKMapPoint: (MKMapPoint) point;

/**
 *  Get the id as a number
 *
 *  @return number id
 */
-(NSNumber *) idAsNumber;

/**
 *  If the view has been set, change the hidden state
 *
 *  @param hidden true to make hidden, false to make visible
 */
-(void) hidden: (BOOL) hidden;

@end

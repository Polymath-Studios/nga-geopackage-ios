//
//  GPKGPolygon.h
//  geopackage-ios
//
//  Created by Brian Osborn on 2/19/19.
//  Copyright © 2019 NGA. All rights reserved.
//

#import <GeoPackage/GPKGPolygonOptions.h>

/**
 * MapKit Polygon with Style Options
 */
@interface GPKGPolygon : MKPolygon

/**
 * Polygon Style Options
 */
@property (nonatomic, strong) GPKGPolygonOptions *options;

@end

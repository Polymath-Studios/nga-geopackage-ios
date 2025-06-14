//
//  GPKGGeoPackageFactory.h
//  geopackage-ios
//
//  Created by Brian Osborn on 5/8/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGGeoPackageManager.h>

/**
 *  GeoPackage Factory to get a GeoPackage Manager
 */
@interface GPKGGeoPackageFactory : NSObject

/**
 *  Get a GeoPackage Manager
 *
 *  @return GeoPackage Manager
 */
+(GPKGGeoPackageManager *) manager;

@end

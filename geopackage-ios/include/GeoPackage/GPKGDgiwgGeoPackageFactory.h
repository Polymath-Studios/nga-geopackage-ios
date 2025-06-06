//
//  GPKGDgiwgGeoPackageFactory.h
//  geopackage-ios
//
//  Created by Brian Osborn on 11/18/22.
//  Copyright © 2022 NGA. All rights reserved.
//

#import <GeoPackage/GPKGDgiwgGeoPackageManager.h>

/**
 * DGIWG GeoPackage Factory to get a DGIWG GeoPackage Manager
 */
@interface GPKGDgiwgGeoPackageFactory : NSObject

/**
 * Get a GeoPackage Manager
 *
 * @return GeoPackage manager
 */
+(GPKGDgiwgGeoPackageManager *) manager;

@end

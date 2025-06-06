//
//  GPKGFeaturePreviewTestUtils.h
//  geopackage-iosTests
//
//  Created by Brian Osborn on 3/6/20.
//  Copyright © 2020 NGA. All rights reserved.
//

#import <GeoPackage/GeoPackage.h>

@interface GPKGFeaturePreviewTestUtils : NSObject

/**
 * Test Feature Preview from a created database
 *
 * @param geoPackage
 */
+(void) testDrawWithGeoPackage: (GPKGGeoPackage *) geoPackage;

@end

//
//  GPKGContentsUtils.h
//  geopackage-ios
//
//  Created by Brian Osborn on 7/25/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPKGGeoPackage.h"

@interface GPKGContentsUtils : NSObject

/**
 * Test read
 *
 * @param geoPackage
 */
+(void) testReadWithGeoPackage: (GPKGGeoPackage *) geoPackage andExpectedResults: (NSNumber *) expectedResults;

/**
 * Test update
 *
 * @param geoPackage
 */
+(void) testUpdateWithGeoPackage: (GPKGGeoPackage *) geoPackage;

/**
 * Test create
 *
 * @param geoPackage
 */
+(void) testCreateWithGeoPackage: (GPKGGeoPackage *) geoPackage;

/**
 * Test delete
 *
 * @param geoPackage
 */
+(void) testDeleteWithGeoPackage: (GPKGGeoPackage *) geoPackage;

/**
 * Test cascade delete
 *
 * @param geoPackage
 */
+(void) testDeleteCascadeWithGeoPackage: (GPKGGeoPackage *) geoPackage;

@end

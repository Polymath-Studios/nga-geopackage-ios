//
//  GPKGFeatureTileUtils.h
//  geopackage-ios
//
//  Created by Brian Osborn on 6/30/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "GPKGCreateGeoPackageTestCase.h"
#import <GeoPackage/GeoPackage.h>

@interface GPKGFeatureTileUtils : GPKGCreateGeoPackageTestCase

+(GPKGFeatureDao *) createFeatureDaoWithGeoPackage: (GPKGGeoPackage *) geoPackage;

+(int) insertFeaturesWithGeoPackage: (GPKGGeoPackage *) geoPackage andFeatureDao: (GPKGFeatureDao *) featureDao;

+(GPKGFeatureTiles *) createFeatureTilesWithGeoPackage: (GPKGGeoPackage *) geoPackage andFeatureDao: (GPKGFeatureDao *) featureDao andUseIcon: (BOOL) useIcon andGeodesic: (BOOL) geodesic;

+(void) insertFourPointsWithFeatureDao: (GPKGFeatureDao *) featureDao andX: (double) x andY: (double) y;

+(void) insertFourLinesWithFeatureDao: (GPKGFeatureDao *) featureDao andPoints: (NSArray *) points;

+(void) insertFourPolygonsWithFeatureDao: (GPKGFeatureDao *) featureDao andLines: (NSArray *) lines;

+(NSArray *) convertPoints: (NSArray *) points withNegativeY: (BOOL) negativeY andNegativeX: (BOOL) negativeX;

+(NSArray *) convertLines: (NSArray *) lines withNegativeY: (BOOL) negativeY andNegativeX: (BOOL) negativeX;

+(long long) insertPointWithFeatureDao: (GPKGFeatureDao *) featureDao andX: (double) x andY: (double) y;

+(void) setPointWithFeatureRow: (GPKGFeatureRow *) featureRow andX: (double) x andY: (double) y;

+(long long) insertLineWithFeatureDao: (GPKGFeatureDao *) featureDao andPoints: (NSArray *) points;

+(SFLineString *) lineStringWithPoints: (NSArray *) points;

+(long long) insertPolygonWithFeatureDao: (GPKGFeatureDao *) featureDao andLines: (NSArray *) lines;

+(void) updateLastChangeWithGeoPackage: (GPKGGeoPackage *) geoPackage andFeatureDao: (GPKGFeatureDao *) featureDao;


@end

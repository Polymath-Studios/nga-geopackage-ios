//
//  GPKGGeoPackageTestUtils.h
//  geopackage-ios
//
//  Created by Brian Osborn on 11/16/15.
//  Copyright © 2015 NGA. All rights reserved.
//

#import <GeoPackage/GeoPackage.h>

@interface GPKGGeoPackageTestUtils : NSObject

+(void)testCreateFeatureTableWithMetadata: (GPKGGeoPackage *) geoPackage;

+(void)testCreateFeatureTableWithMetadataIdColumn: (GPKGGeoPackage *) geoPackage;

+(void)testCreateFeatureTableWithMetadataAdditionalColumns: (GPKGGeoPackage *) geoPackage;

+(void)testCreateFeatureTableWithMetadataIdColumnAdditionalColumns: (GPKGGeoPackage *) geoPackage;

+(NSArray<GPKGFeatureColumn *> *) featureColumns;

+(void)testDeleteTables: (GPKGGeoPackage *) geoPackage;

+(void)testBounds: (GPKGGeoPackage *) geoPackage;

+(void)testVacuum: (GPKGGeoPackage *) geoPackage;

+(void) testTableTypes: (GPKGGeoPackage *) geoPackage;

+(void) testUserDao: (GPKGGeoPackage *) geoPackage;

@end

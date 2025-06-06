//
//  GPKGGeoPackageGeometryDataUtils.h
//  geopackage-ios
//
//  Created by Brian Osborn on 6/9/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <GeoPackage/GeoPackage.h>

@interface GPKGGeoPackageGeometryDataUtils : NSObject

+(void) testReadWriteBytesWithGeoPackage: (GPKGGeoPackage *) geoPackage andCompareGeometryBytes: (BOOL) compareGeometryBytes;

+(void) testGeometryProjectionTransform: (GPKGGeoPackage *) geoPackage;

+(void) compareGeometryDataWithExpected: (GPKGGeometryData *) expected andActual: (GPKGGeometryData *) actual;

+(void) compareGeometryDataWithExpected: (GPKGGeometryData *) expected andActual: (GPKGGeometryData *) actual andCompareGeometryBytes: (BOOL) compareGeometryBytes;

+(void) compareByteArrayWithExpected: (NSData *) expected andActual: (NSData *) actual;

+(void) testInsertGeometryBytesWithGeoPackage: (GPKGGeoPackage *) geoPackage;

+(void) testInsertHeaderBytesWithGeoPackage: (GPKGGeoPackage *) geoPackage;

+(void) testInsertHeaderAndGeometryBytesWithGeoPackage: (GPKGGeoPackage *) geoPackage;

+(void) testInsertBytesWithGeoPackage: (GPKGGeoPackage *) geoPackage;

@end

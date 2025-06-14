//
//  GPKGGeoPackageValidate.m
//  geopackage-ios
//
//  Created by Brian Osborn on 6/9/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGGeoPackageValidate.h>
#import <GeoPackage/GPKGGeoPackageConstants.h>

@implementation GPKGGeoPackageValidate

+(BOOL) hasGeoPackageExtension: (NSString *) file{
    NSString *extension = [file pathExtension];
    return [self isGeoPackageExtension:extension];
}

+(BOOL) isGeoPackageExtension: (NSString *) extension{
    return extension != nil
        && ([extension caseInsensitiveCompare:GPKG_EXTENSION] == NSOrderedSame
        || [extension caseInsensitiveCompare:GPKG_EXTENDED_EXTENSION] == NSOrderedSame);
}

+(void) validateGeoPackageExtension: (NSString *) file{
    if(![self hasGeoPackageExtension:file]){
        [NSException raise:@"Invalid Extension" format:@"GeoPackage database file '%@' does not have a valid extension of '%@' or '%@'", file, GPKG_EXTENSION, GPKG_EXTENDED_EXTENSION];
    }
}

+(NSString *) addGeoPackageExtension: (NSString *) name{
    return [NSString stringWithFormat:@"%@.%@", name, GPKG_EXTENSION];
}

+(BOOL) hasMinimumTables: (GPKGGeoPackage *) geoPackage{
    BOOL hasMinimum = [[geoPackage spatialReferenceSystemDao] tableExists] && [[geoPackage contentsDao] tableExists];
    return hasMinimum;
}

+(void) validateMinimumTables: (GPKGGeoPackage *) geoPackage{
    if(![self hasMinimumTables:geoPackage]){
        [NSException raise:@"Minimum Tables" format:@"Invalid GeoPackage. Does not contain required tables: %@ & %@, GeoPackage Name: %@", GPKG_SRS_TABLE_NAME, GPKG_CON_TABLE_NAME, geoPackage.name];
    }
}

@end

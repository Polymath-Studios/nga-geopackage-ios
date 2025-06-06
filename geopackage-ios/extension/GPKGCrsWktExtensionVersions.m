//
//  GPKGCrsWktExtensionVersions.m
//  geopackage-ios
//
//  Created by Brian Osborn on 11/8/22.
//  Copyright © 2022 NGA. All rights reserved.
//

#import <GeoPackage/GPKGCrsWktExtensionVersions.h>

@implementation GPKGCrsWktExtensionVersions

+(GPKGCrsWktExtensionVersion) first{
    return GPKG_CRS_WKT_V_1;
}

+(GPKGCrsWktExtensionVersion) latest{
    return GPKG_CRS_WKT_V_1_1;
}

+(NSString *) version: (GPKGCrsWktExtensionVersion) version{
    NSString *ver = nil;
    
    switch(version){
        case GPKG_CRS_WKT_V_1:
            ver = @"1.0";
            break;
        case GPKG_CRS_WKT_V_1_1:
            ver = @"1.1";
            break;
    }
    
    return ver;
}

+(NSString *) suffix: (GPKGCrsWktExtensionVersion) version{
    NSString *suffix = nil;
    
    switch(version){
        case GPKG_CRS_WKT_V_1:
            suffix = @"";
            break;
        case GPKG_CRS_WKT_V_1_1:
            suffix = @"_1_1";
            break;
    }
    
    return suffix;
}

+(BOOL) isVersion: (GPKGCrsWktExtensionVersion) version atMinimum: (GPKGCrsWktExtensionVersion) minimum{
    return version >= minimum;
}

+(NSArray<NSNumber *> *) atMinimum: (GPKGCrsWktExtensionVersion) version{
    NSMutableArray<NSNumber *> *versions = [NSMutableArray array];
    
    switch(version){
        case GPKG_CRS_WKT_V_1:
            [versions addObject:[NSNumber numberWithInteger:GPKG_CRS_WKT_V_1]];
        case GPKG_CRS_WKT_V_1_1:
            [versions addObject:[NSNumber numberWithInteger:GPKG_CRS_WKT_V_1_1]];
    }
    
    return versions;
}

@end

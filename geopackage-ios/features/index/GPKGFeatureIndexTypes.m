//
//  FeatureIndexTypes.m
//  geopackage-ios
//
//  Created by Brian Osborn on 10/12/15.
//  Copyright © 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGFeatureIndexTypes.h>
#import <GeoPackage/GPKGUtils.h>

NSString * const GPKG_FIT_METADATA_NAME = @"METADATA";
NSString * const GPKG_FIT_GEOPACKAGE_NAME = @"GEOPACKAGE";
NSString * const GPKG_FIT_RTREE_NAME = @"RTREE";
NSString * const GPKG_FIT_NONE_NAME = @"NONE";

@implementation GPKGFeatureIndexTypes

+(NSString *) name: (GPKGFeatureIndexType) featureIndexType{
    NSString *name = nil;
    
    switch(featureIndexType){
        case GPKG_FIT_METADATA:
            name = GPKG_FIT_METADATA_NAME;
            break;
        case GPKG_FIT_GEOPACKAGE:
            name = GPKG_FIT_GEOPACKAGE_NAME;
            break;
        case GPKG_FIT_RTREE:
            name = GPKG_FIT_RTREE_NAME;
            break;
        case GPKG_FIT_NONE:
            name = GPKG_FIT_NONE_NAME;
            break;
    }
    
    return name;
}

+(GPKGFeatureIndexType) fromName: (NSString *) name{
    GPKGFeatureIndexType value = -1;
    
    if(name != nil){
        name = [name uppercaseString];
        NSDictionary *types = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInteger:GPKG_FIT_METADATA], GPKG_FIT_METADATA_NAME,
                               [NSNumber numberWithInteger:GPKG_FIT_GEOPACKAGE], GPKG_FIT_GEOPACKAGE_NAME,
                               [NSNumber numberWithInteger:GPKG_FIT_RTREE], GPKG_FIT_RTREE_NAME,
                               [NSNumber numberWithInteger:GPKG_FIT_NONE], GPKG_FIT_NONE_NAME,
                               nil
                               ];
        NSNumber *enumValue = [GPKGUtils objectForKey:name inDictionary:types];
        if(enumValue != nil){
            value = (GPKGFeatureIndexType)[enumValue intValue];
        }
    }
    
    return value;
}

@end

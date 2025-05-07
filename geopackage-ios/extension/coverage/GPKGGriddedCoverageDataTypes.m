//
//  GPKGGriddedCoverageDataTypes.m
//  geopackage-ios
//
//  Created by Brian Osborn on 11/10/16.
//  Copyright © 2016 NGA. All rights reserved.
//

#import <GeoPackage/GPKGGriddedCoverageDataTypes.h>
#import <GeoPackage/GPKGUtils.h>

NSString * const GPKG_GCDT_INTEGER_NAME = @"integer";
NSString * const GPKG_GCDT_FLOAT_NAME = @"float";

@implementation GPKGGriddedCoverageDataTypes

+(NSString *) name: (GPKGGriddedCoverageDataType) griddedCoverageDataType{
    NSString *name = nil;
    
    switch(griddedCoverageDataType){
        case GPKG_GCDT_INTEGER:
            name = GPKG_GCDT_INTEGER_NAME;
            break;
        case GPKG_GCDT_FLOAT:
            name = GPKG_GCDT_FLOAT_NAME;
            break;
    }
    
    return name;
}

+(GPKGGriddedCoverageDataType) fromName: (NSString *) name{
    GPKGGriddedCoverageDataType value = -1;
    
    if(name != nil){
        name = [name lowercaseString];
        NSDictionary *types = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInteger:GPKG_GCDT_INTEGER], GPKG_GCDT_INTEGER_NAME,
                               [NSNumber numberWithInteger:GPKG_GCDT_FLOAT], GPKG_GCDT_FLOAT_NAME,
                               nil
                               ];
        NSNumber *enumValue = [GPKGUtils objectForKey:name inDictionary:types];
        if(enumValue != nil){
            value = (GPKGGriddedCoverageDataType)[enumValue intValue];
        }
    }
    
    return value;
}

@end

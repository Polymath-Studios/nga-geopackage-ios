//
//  GPKGCoverageDataAlgorithms.m
//  geopackage-ios
//
//  Created by Brian Osborn on 11/10/16.
//  Copyright © 2016 NGA. All rights reserved.
//

#import <GeoPackage/GPKGCoverageDataAlgorithms.h>
#import <GeoPackage/GPKGUtils.h>

NSString * const GPKG_CDA_NEAREST_NEIGHBOR_NAME = @"Nearest Neighbor";
NSString * const GPKG_CDA_BILINEAR_NAME = @"Bilinear";
NSString * const GPKG_CDA_BICUBIC_NAME = @"Bicubic";

@implementation GPKGCoverageDataAlgorithms

+(NSString *) name: (GPKGCoverageDataAlgorithm) algorithm{
    NSString *name = nil;
    
    switch(algorithm){
        case GPKG_CDA_NEAREST_NEIGHBOR:
            name = GPKG_CDA_NEAREST_NEIGHBOR_NAME;
            break;
        case GPKG_CDA_BILINEAR:
            name = GPKG_CDA_BILINEAR_NAME;
            break;
        case GPKG_CDA_BICUBIC:
            name = GPKG_CDA_BICUBIC_NAME;
            break;
    }
    
    return name;
}

+(GPKGCoverageDataAlgorithm) fromName: (NSString *) name{
    GPKGCoverageDataAlgorithm value = -1;
    
    if(name != nil){
        name = [name uppercaseString];
        NSDictionary *types = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInteger:GPKG_CDA_NEAREST_NEIGHBOR], [GPKG_CDA_NEAREST_NEIGHBOR_NAME uppercaseString],
                               [NSNumber numberWithInteger:GPKG_CDA_BILINEAR], [GPKG_CDA_BILINEAR_NAME uppercaseString],
                               [NSNumber numberWithInteger:GPKG_CDA_BICUBIC], [GPKG_CDA_BICUBIC_NAME uppercaseString],
                               nil
                               ];
        NSNumber *enumValue = [GPKGUtils objectForKey:name inDictionary:types];
        if(enumValue != nil){
            value = (GPKGCoverageDataAlgorithm)[enumValue intValue];
        }
    }
    
    return value;
}

@end

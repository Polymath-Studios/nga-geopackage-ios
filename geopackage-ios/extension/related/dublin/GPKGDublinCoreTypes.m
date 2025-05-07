//
//  GPKGDublinCoreTypes.m
//  geopackage-ios
//
//  Created by Brian Osborn on 6/14/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import <GeoPackage/GPKGDublinCoreTypes.h>
#import <GeoPackage/GPKGUtils.h>

/**
 *  Dublin Core Metadata Type names
 */
NSString * const GPKG_DCM_DATE_NAME = @"date";
NSString * const GPKG_DCM_DESCRIPTION_NAME = @"description";
NSString * const GPKG_DCM_FORMAT_NAME = @"format";
NSString * const GPKG_DCM_IDENTIFIER_NAME = @"identifier";
NSString * const GPKG_DCM_SOURCE_NAME = @"source";
NSString * const GPKG_DCM_TITLE_NAME = @"title";

/**
 *  Dublin Core Metadata Synonym names
 */
NSString * const GPKG_DCM_CONTENT_TYPE_NAME = @"content_type";
NSString * const GPKG_DCM_ID_NAME = @"id";

@implementation GPKGDublinCoreTypes

+(NSString *) name: (GPKGDublinCoreType) dublinCoreType{
    NSString *name = nil;
    
    switch(dublinCoreType){
        case GPKG_DCM_DATE:
            name = GPKG_DCM_DATE_NAME;
            break;
        case GPKG_DCM_DESCRIPTION:
            name = GPKG_DCM_DESCRIPTION_NAME;
            break;
        case GPKG_DCM_FORMAT:
            name = GPKG_DCM_FORMAT_NAME;
            break;
        case GPKG_DCM_IDENTIFIER:
            name = GPKG_DCM_IDENTIFIER_NAME;
            break;
        case GPKG_DCM_SOURCE:
            name = GPKG_DCM_SOURCE_NAME;
            break;
        case GPKG_DCM_TITLE:
            name = GPKG_DCM_TITLE_NAME;
            break;
    }
    
    return name;
}

+(GPKGDublinCoreType) fromName: (NSString *) name{
    GPKGDublinCoreType value = -1;
    
    if(name != nil){
        name = [name lowercaseString];
        NSDictionary *types = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInteger:GPKG_DCM_DATE], GPKG_DCM_DATE_NAME,
                               [NSNumber numberWithInteger:GPKG_DCM_DESCRIPTION], GPKG_DCM_DESCRIPTION_NAME,
                               [NSNumber numberWithInteger:GPKG_DCM_FORMAT], GPKG_DCM_FORMAT_NAME,
                               [NSNumber numberWithInteger:GPKG_DCM_IDENTIFIER], GPKG_DCM_IDENTIFIER_NAME,
                               [NSNumber numberWithInteger:GPKG_DCM_SOURCE], GPKG_DCM_SOURCE_NAME,
                               [NSNumber numberWithInteger:GPKG_DCM_TITLE], GPKG_DCM_TITLE_NAME,
                               nil
                               ];
        NSNumber *enumValue = [GPKGUtils objectForKey:name inDictionary:types];
        if(enumValue != nil){
            value = (GPKGDublinCoreType)[enumValue intValue];
        }
    }
    
    return value;
}

+(NSArray<NSString *> *) synonyms: (GPKGDublinCoreType) dublinCoreType{
    NSMutableArray<NSString *> *synonyms = [NSMutableArray array];
    
    switch(dublinCoreType){
        case GPKG_DCM_FORMAT:
            [synonyms addObject:GPKG_DCM_CONTENT_TYPE_NAME];
            break;
        case GPKG_DCM_IDENTIFIER:
            [synonyms addObject:GPKG_DCM_ID_NAME];
            break;
        default:
            break;
    }
    
    return synonyms;
}

@end

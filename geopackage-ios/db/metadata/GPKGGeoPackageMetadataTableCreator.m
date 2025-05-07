//
//  GPKGGeoPackageMetadataTableCreator.m
//  geopackage-ios
//
//  Created by Brian Osborn on 6/25/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGGeoPackageMetadataTableCreator.h>
#import <GeoPackage/GPKGGeoPackageMetadata.h>
#import <GeoPackage/GPKGTableMetadata.h>
#import <GeoPackage/GPKGGeometryMetadata.h>

NSString * const GPKG_METADATA_TABLES = @"metadata";

@implementation GPKGGeoPackageMetadataTableCreator

-(instancetype)initWithDatabase:(GPKGConnection *) db{
    self = [super initWithDatabase:db];
    return self;
}

-(NSString *) properties{
    return GPKG_METADATA_TABLES;
}

-(int) createGeoPackageMetadata{
    return [self createTable:GPKG_GPM_TABLE_NAME];
}

-(int) createTableMetadata{
    return [self createTable:GPKG_GPTM_TABLE_NAME];
}

-(int) createGeometryMetadata{
    return [self createTable:GPKG_GPGM_TABLE_NAME];
}

-(void) createAll{
    [self createGeoPackageMetadata];
    [self createTableMetadata];
    [self createGeometryMetadata];
}

@end

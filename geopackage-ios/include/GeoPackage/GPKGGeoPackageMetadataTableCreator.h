//
//  GPKGGeoPackageMetadataTableCreator.h
//  geopackage-ios
//
//  Created by Brian Osborn on 6/25/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGTableCreator.h>

extern NSString * const GPKG_METADATA_TABLES;

/**
 * GeoPackage Metadata Table Creator
 */
@interface GPKGGeoPackageMetadataTableCreator : GPKGTableCreator

/**
 *  Initialize
 *
 *  @param db database conneciton
 *
 *  @return new metadata table creator
 */
-(instancetype)initWithDatabase:(GPKGConnection *) db;

/**
 *  Create GeoPackage metadata table
 *
 *  @return tables created
 */
-(int) createGeoPackageMetadata;

/**
 *  Create Table metadata table
 *
 *  @return tables created
 */
-(int) createTableMetadata;

/**
 *  Create Geometry metadata table
 *
 *  @return tables created
 */
-(int) createGeometryMetadata;

/**
 *  Create all GeoPackage Metadata tables
 */
-(void) createAll;

@end

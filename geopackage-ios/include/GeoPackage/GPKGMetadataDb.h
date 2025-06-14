//
//  GPKGMetadataDb.h
//  geopackage-ios
//
//  Created by Brian Osborn on 6/29/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGGeoPackageMetadataDao.h>
#import <GeoPackage/GPKGTableMetadataDao.h>
#import <GeoPackage/GPKGGeometryMetadataDao.h>

/**
 * GeoPackage Metadata Database
 */
@interface GPKGMetadataDb : NSObject

/**
 *  Connection
 */
@property (nonatomic, strong) GPKGConnection *connection;

/**
 *  Initialize
 *
 *  @return new metadata database
 */
-(instancetype) init;

/**
 *  Close the database
 */
-(void) close;

/**
 *  Get a GeoPackage Metadata DAO
 *
 *  @return GeoPackage Metadata DAO
 */
-(GPKGGeoPackageMetadataDao *) geoPackageMetadataDao;

/**
 *  Get a Table Metadata DAO
 *
 *  @return Table Metadata DAO
 */
-(GPKGTableMetadataDao *) tableMetadataDao;

/**
 *  Get a Geometry Metadata DAO
 *
 *  @return Geometry Metadata DAO
 */
-(GPKGGeometryMetadataDao *) geometryMetadataDao;

/**
 *  Get a Geometry Metadata DAO
 *
 *  @param geodesic index geodesic geometries flag
 *  @param projection feature projection
 *
 *  @return Geometry Metadata DAO
 */
-(GPKGGeometryMetadataDao *) geometryMetadataDaoWithGeodesic: (BOOL) geodesic andProjection: (PROJProjection *) projection;

/**
 *  Delete the metadata database file
 *
 *  @return true if deleted
 */
+(BOOL) deleteMetadataFile;

@end

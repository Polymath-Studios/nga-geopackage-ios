//
//  GPKGContents.h
//  geopackage-ios
//
//  Created by Brian Osborn on 5/18/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGSpatialReferenceSystem.h>
#import <GeoPackage/GPKGBoundingBox.h>
#import <GeoPackage/GPKGContentsDataTypes.h>

/**
 *  Contents table constants
 */
extern NSString * const GPKG_CON_TABLE_NAME;
extern NSString * const GPKG_CON_COLUMN_PK;
extern NSString * const GPKG_CON_COLUMN_TABLE_NAME;
extern NSString * const GPKG_CON_COLUMN_DATA_TYPE;
extern NSString * const GPKG_CON_COLUMN_IDENTIFIER;
extern NSString * const GPKG_CON_COLUMN_DESCRIPTION;
extern NSString * const GPKG_CON_COLUMN_LAST_CHANGE;
extern NSString * const GPKG_CON_COLUMN_MIN_X;
extern NSString * const GPKG_CON_COLUMN_MIN_Y;
extern NSString * const GPKG_CON_COLUMN_MAX_X;
extern NSString * const GPKG_CON_COLUMN_MAX_Y;
extern NSString * const GPKG_CON_COLUMN_SRS_ID;

/**
 * Contents object. Provides identifying and descriptive information that an
 * application can display to a user in a menu of geospatial data that is
 * available for access and/or update.
 */
@interface GPKGContents : NSObject <NSMutableCopying>

/**
 *  The name of the tiles, or feature table
 */
@property (nonatomic, strong) NSString *tableName;

/**
 * Type of data stored in the table:. “features” per clause Features,
 * “tiles” per clause Tiles, or an implementer-defined value for other data
 * tables per clause in an Extended GeoPackage.
 */
@property (nonatomic, strong) NSString *dataType;

/**
 *  A human-readable identifier (e.g. short name) for the table_name content
 */
@property (nonatomic, strong) NSString *identifier;

/**
 *  A human-readable description for the table_name content
 */
@property (nonatomic, strong) NSString *theDescription;

/**
 * timestamp value in ISO 8601 format as defined by the strftime function
 * %Y-%m-%dT%H:%M:%fZ format string applied to the current time
 */
@property (nonatomic, strong) NSDate *lastChange;

/**
 *  Bounding box minimum easting or longitude for all content in table_name
 */
@property (nonatomic, strong) NSDecimalNumber *minX;

/**
 *  Bounding box minimum northing or latitude for all content in table_name
 */
@property (nonatomic, strong) NSDecimalNumber *minY;

/**
 *  Bounding box maximum easting or longitude for all content in table_name
 */
@property (nonatomic, strong) NSDecimalNumber *maxX;

/**
 *  Bounding box maximum northing or latitude for all content in table_name
 */
@property (nonatomic, strong) NSDecimalNumber *maxY;

/**
 *  Unique identifier for each Spatial Reference System within a GeoPackage
 */
@property (nonatomic, strong) NSNumber *srsId;

/**
 *  Get the Contents Data Type
 *
 *  @return Contents Data Type
 */
-(GPKGContentsDataType) contentsDataType;

/**
 *  Set the Contents Data Type
 *
 *  @param dataType Contents Data Type
 */
-(void) setContentsDataType: (GPKGContentsDataType) dataType;

/**
 * Set the data type name and register the core data type
 *
 * @param name
 *            data type name
 * @param dataType
 *            core data type
 */
-(void) setDataType: (NSString *) name asContentsDataType: (GPKGContentsDataType) dataType;

/**
 * Determine if the contents data type is features
 *
 * @return true if features type
 */
-(BOOL) isFeaturesType;

/**
 * Determine if the contents data type is features or unknown
 *
 * @return true if features type or unknown
 */
-(BOOL) isFeaturesTypeOrUnknown;

/**
 * Determine if the contents data type is tiles
 *
 * @return true if tiles type
 */
-(BOOL) isTilesType;

/**
 * Determine if the contents data type is tiles or unknown
 *
 * @return true if tiles type or unknown
 */
-(BOOL) isTilesTypeOrUnknown;

/**
 * Determine if the contents data type is attributes
 *
 * @return true if attributes type
 */
-(BOOL) isAttributesType;

/**
 * Determine if the contents data type is attributes or unknown
 *
 * @return true if attributes type or unknown
 */
-(BOOL) isAttributesTypeOrUnknown;

/**
 *  Set the Spatial Reference System
 *
 *  @param srs Spatial Reference System
 */
-(void) setSrs: (GPKGSpatialReferenceSystem *) srs;

/**
 *  Get a bounding box
 *
 *  @return bounding box
 */
-(GPKGBoundingBox *) boundingBox;

/**
 *  Set a bounding box
 *
 *  @param boundingBox bounding box
 */
-(void) setBoundingBox: (GPKGBoundingBox *) boundingBox;

@end

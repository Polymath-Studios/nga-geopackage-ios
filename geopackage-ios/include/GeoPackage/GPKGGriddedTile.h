//
//  GPKGGriddedTile.h
//  geopackage-ios
//
//  Created by Brian Osborn on 11/11/16.
//  Copyright © 2016 NGA. All rights reserved.
//

#import <GeoPackage/GPKGContents.h>

/**
 *  Gridded Tile table constants
 */
extern NSString * const GPKG_CDGT_TABLE_NAME;
extern NSString * const GPKG_CDGT_COLUMN_PK;
extern NSString * const GPKG_CDGT_COLUMN_ID;
extern NSString * const GPKG_CDGT_COLUMN_TABLE_NAME;
extern NSString * const GPKG_CDGT_COLUMN_TABLE_ID;
extern NSString * const GPKG_CDGT_COLUMN_SCALE;
extern NSString * const GPKG_CDGT_COLUMN_OFFSET;
extern NSString * const GPKG_CDGT_COLUMN_MIN;
extern NSString * const GPKG_CDGT_COLUMN_MAX;
extern NSString * const GPKG_CDGT_COLUMN_MEAN;
extern NSString * const GPKG_CDGT_COLUMN_STANDARD_DEVIATION;

/**
 * Gridded Tile object
 */
@interface GPKGGriddedTile : NSObject <NSMutableCopying>

/**
 *  Auto increment primary key
 */
@property (nonatomic, strong) NSNumber *id;

/**
 * Name of tile pyramid user data table
 */
@property (nonatomic, strong) NSString *tableName;

/**
 *  Foreign key to id in tile pyramid user data table
 */
@property (nonatomic, strong) NSNumber *tableId;

/**
 *  Scale as a multiple relative to the unit of measure
 */
@property (nonatomic, strong) NSDecimalNumber *scale;

/**
 * The offset to the 0 value
 */
@property (nonatomic, strong) NSDecimalNumber *offset;

/**
 *  Minimum value of this tile
 */
@property (nonatomic, strong) NSDecimalNumber *min;

/**
 *  Maximum value of this tile
 */
@property (nonatomic, strong) NSDecimalNumber *max;

/**
 *  The arithmetic mean of values in this tile
 */
@property (nonatomic, strong) NSDecimalNumber *mean;

/**
 *  The standard deviation of values in this tile
 */
@property (nonatomic, strong) NSDecimalNumber *standardDeviation;

/**
 *  Set the contents
 *
 *  @param contents contents
 */
-(void) setContents: (GPKGContents *) contents;

/**
 *  Get the scale or default value
 *
 *  @return scale as a multiple relative to the unit of measure
 */
-(double) scaleOrDefault;

/**
 *  Get the offset or default value
 *
 *  @return offset to the 0 value
 */
-(double) offsetOrDefault;

@end

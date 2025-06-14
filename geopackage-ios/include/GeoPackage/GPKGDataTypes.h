//
//  GPKGDataTypes.h
//  geopackage-ios
//
//  Created by Brian Osborn on 5/20/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Enumeration of column data types
 */
typedef NS_ENUM(int, GPKGDataType) {
    GPKG_DT_BOOLEAN,
    GPKG_DT_TINYINT,
    GPKG_DT_SMALLINT,
    GPKG_DT_MEDIUMINT,
    GPKG_DT_INT,
    GPKG_DT_INTEGER,
    GPKG_DT_FLOAT,
    GPKG_DT_DOUBLE,
    GPKG_DT_REAL,
    GPKG_DT_TEXT,
    GPKG_DT_BLOB,
    GPKG_DT_DATE,
    GPKG_DT_DATETIME
};

/**
 *  Data type names
 */
extern NSString * const GPKG_DT_BOOLEAN_NAME;
extern NSString * const GPKG_DT_TINYINT_NAME;
extern NSString * const GPKG_DT_SMALLINT_NAME;
extern NSString * const GPKG_DT_MEDIUMINT_NAME;
extern NSString * const GPKG_DT_INT_NAME;
extern NSString * const GPKG_DT_INTEGER_NAME;
extern NSString * const GPKG_DT_FLOAT_NAME;
extern NSString * const GPKG_DT_DOUBLE_NAME;
extern NSString * const GPKG_DT_REAL_NAME;
extern NSString * const GPKG_DT_TEXT_NAME;
extern NSString * const GPKG_DT_BLOB_NAME;
extern NSString * const GPKG_DT_DATE_NAME;
extern NSString * const GPKG_DT_DATETIME_NAME;

@interface GPKGDataTypes : NSObject

/**
 *  Get the name of the data type
 *
 *  @param dataType data type
 *
 *  @return data type name
 */
+(NSString *) name: (GPKGDataType) dataType;

/**
 *  Get the data type from the data type name
 *
 *  @param name data type name
 *
 *  @return data type
 */
+(GPKGDataType) fromName: (NSString *) name;

/**
 *  Get the object c class type of the data type
 *
 *  @param dataType data type
 *
 *  @return class type
 */
+(Class) classType: (GPKGDataType) dataType;

/**
 *  Get the SQLite type of the data type
 *
 *  @param dataType data type
 *
 *  @return SQLite type
 */
+(int) sqliteType: (GPKGDataType) dataType;

@end

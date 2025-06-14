//
//  GPKGGriddedCoverageDataTypes.h
//  geopackage-ios
//
//  Created by Brian Osborn on 11/10/16.
//  Copyright © 2016 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Gridded Coverage data type enumeration
 */
typedef NS_ENUM(int, GPKGGriddedCoverageDataType) {
    GPKG_GCDT_INTEGER,
    GPKG_GCDT_FLOAT
};

/**
 *  Gridded Coverage data type names
 */
extern NSString * const GPKG_GCDT_INTEGER_NAME;
extern NSString * const GPKG_GCDT_FLOAT_NAME;

@interface GPKGGriddedCoverageDataTypes : NSObject

/**
 *  Get the name of the gridded coverage data type
 *
 *  @param griddedCoverageDataType gridded coverage data type
 *
 *  @return gridded coverage data type name
 */
+(NSString *) name: (GPKGGriddedCoverageDataType) griddedCoverageDataType;

/**
 *  Get the gridded coverage data type from the name
 *
 *  @param name gridded coverage data type name
 *
 *  @return gridded coverage data type
 */
+(GPKGGriddedCoverageDataType) fromName: (NSString *) name;

@end

//
//  GPKGAttributesTableReader.h
//  geopackage-ios
//
//  Created by Brian Osborn on 11/17/16.
//  Copyright © 2016 NGA. All rights reserved.
//

#import <GeoPackage/GPKGUserTableReader.h>
#import <GeoPackage/GPKGAttributesTable.h>

/**
 * Reads the metadata from an existing attributes table
 */
@interface GPKGAttributesTableReader : GPKGUserTableReader

/**
 *  Initialize
 *
 *  @param tableName table name
 *
 *  @return new attributes table reader
 */
-(instancetype) initWithTable: (NSString *) tableName;

/**
 *  Read the attributes table with the database connection
 *
 *  @param db database connection
 *
 *  @return attributes table
 */
-(GPKGAttributesTable *) readAttributesTableWithConnection: (GPKGConnection *) db;

@end

//
//  GPKGRelatedTablesUtils.h
//  geopackage-iosTests
//
//  Created by Brian Osborn on 6/29/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "GPKGUserCustomRow.h"
#import "GPKGDublinCoreTypes.h"

@interface GPKGRelatedTablesUtils : NSObject

/**
 * Create additional user table columns
 *
 * @return additional user table columns
 */
+(NSArray<GPKGUserCustomColumn *> *) createAdditionalUserColumns;

/**
 * Create additional user table columns
 *
 * @param notNull
 *            columns not nil value
 * @return additional user table columns
 */
+(NSArray<GPKGUserCustomColumn *> *) createAdditionalUserColumnsWithNotNil: (BOOL) notNull;

/**
 * Create simple user table columns
 *
 * @return simple user table columns
 */
+(NSArray<GPKGUserCustomColumn *> *) createSimpleUserColumns;

/**
 * Create simple user table columns
 *
 * @param notNull
 *            columns not nil value
 * @return simple user table columns
 */
+(NSArray<GPKGUserCustomColumn *> *) createSimpleUserColumnsWithNotNil: (BOOL) notNull;

/**
 * Populate the user row additional column values
 *
 * @param userTable
 *            user custom table
 * @param userRow
 *            user custom row
 * @param skipColumns
 *            columns to skip populating
 */
+(void) populateUserRowWithTable: (GPKGUserCustomTable *) userTable andRow: (GPKGUserCustomRow *) userRow andSkipColumns: (NSArray<NSString *> *) skipColumns;

/**
 * Validate a user row
 *
 * @param columns
 *            array of columns
 * @param userRow
 *            user custom row
 */
+(void) validateUserRow: (GPKGUserCustomRow *) userRow withColumns: (NSArray<NSString *> *) columns;

/**
 * Validate a user row for expected Dublin Core Columns
 *
 * @param userRow
 *            user custom row
 */
+(void) validateDublinCoreColumnsWithRow: (GPKGUserCustomRow *) userRow;

/**
 * Validate a user row for expected simple Dublin Core Columns
 *
 * @param userRow
 *            user custom row
 */
+(void) validateSimpleDublinCoreColumnsWithRow: (GPKGUserCustomRow *) userRow;

/**
 * Validate a user row for expected Dublin Core Column
 *
 * @param userRow
 *            user custom row
 * @param type
 *            Dublin Core Type
 */
+(void) validateDublinCoreColumnsWithRow: (GPKGUserCustomRow *) userRow andType: (enum GPKGDublinCoreType) type;

@end

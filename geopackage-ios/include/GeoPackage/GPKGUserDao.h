//
//  GPKGUserDao.h
//  geopackage-ios
//
//  Created by Brian Osborn on 5/20/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGBaseDao.h>
#import <GeoPackage/GPKGUserRow.h>
#import <GeoPackage/GPKGRowResultSet.h>
#import <GeoPackage/GPKGRowPaginatedResults.h>

@class GPKGRowResultSet;
@class GPKGRowPaginatedResults;

/**
 *  Abstract User DAO for reading user tables
 */
@interface GPKGUserDao : GPKGBaseDao

/**
 *  User table
 */
@property (nonatomic, strong) GPKGUserTable *table;

/**
 *  Projection
 */
@property (nonatomic, strong) PROJProjection *projection;

/**
 *  Initialize
 *
 *  @param database database connection
 *  @param table    user table
 *
 *  @return new user dao
 */
-(instancetype) initWithDatabase: (GPKGConnection *) database andTable: (GPKGUserTable *) table;

/**
 * Check if the table has a primary key column
 *
 * @return true if has a primary key
 */
-(BOOL) hasPkColumn;

/**
 * Get the primary key column index
 *
 * @return primary key column index
 */
-(int) pkIndex;

/**
 * Get the primary key column
 *
 * @return primary key column
 */
-(GPKGUserColumn *) pkColumn;

/**
 * Get the primary key column name
 *
 * @return primary key column name
 */
-(NSString *) pkColumnName;

/**
 * Get the table columns
 *
 * @return columns
 */
-(NSArray<GPKGUserColumn *> *) columns;

/**
 *  Get a user row from the current result
 *
 *  @param results result set
 *
 *  @return user row
 */
-(GPKGUserRow *) row: (GPKGResultSet *) results;

/**
 *  Get a user row from the row
 *
 *  @param row result row
 *
 *  @return user row
 */
-(GPKGUserRow *) rowWithRow: (GPKGRow *) row;

/**
 *  Wrap the result set
 *
 *  @param results result set
 *
 *  @return row result set
 */
-(GPKGRowResultSet *) results: (GPKGResultSet *) results;

/**
 *  Create a user row
 *
 *  @param columns      columns
 *  @param values      values
 *
 *  @return user row
 */
-(GPKGUserRow *) newRowWithColumns: (GPKGUserColumns *) columns andValues: (NSMutableArray *) values;

/**
 *  Get the bounding box of the user table data
 *
 *  @return bounding box
 */
-(GPKGBoundingBox *) boundingBox;

/**
 * Get the bounding box of the user table data
 *
 * @param projection
 *            desired projection
 *
 * @return bounding box of user table data
 */
-(GPKGBoundingBox *) boundingBoxInProjection: (PROJProjection *) projection;

/**
 * Project the provided bounding box in the declared projection to the user
 * DAO projection
 *
 * @param boundingBox
 *            bounding box
 * @param projection
 *            projection
 * @return projected bounding box
 */
-(GPKGBoundingBox *) boundingBox: (GPKGBoundingBox *) boundingBox inProjection: (PROJProjection *) projection;

/**
 * Get the contents
 *
 * @return contents
 */
-(GPKGContents *) contents;

/**
 *  Get the approximate zoom level of where the bounding box of the user data fits into the world
 *
 *  @return zoom level
 */
-(int) zoomLevel;

/**
 * Query for the row with the provided id
 *
 * @param id
 *            id
 * @return row
 */
-(GPKGUserRow *) queryForIdRow: (int) id;

/**
 * Query for the row with the provided id
 *
 * @param columns
 *            columns
 * @param id
 *            id
 * @return row
 */
-(GPKGUserRow *) queryWithColumns: (NSArray<NSString *> *) columns forIdRow: (int) id;

/**
 * Paginate the results
 *
 * @param results
 *            result set
 * @return row paginated results
 */
-(GPKGRowPaginatedResults *) paginate: (GPKGResultSet *) results;

/**
 * Paginate the results
 *
 * @param results
 *            result set
 * @param dao
 *            base DAO
 * @return row paginated results
 */
+(GPKGRowPaginatedResults *) paginate: (GPKGResultSet *) results withDao: (GPKGUserDao *) dao;

/**
 * Is the primary key modifiable
 *
 * @return true if the primary key is modifiable
 */
-(BOOL) isPkModifiable;

/**
 * Set if the primary key can be modified
 *
 * @param pkModifiable
 *            primary key modifiable flag
 */
-(void) setPkModifiable: (BOOL) pkModifiable;

/**
 * Is value validation against column types enabled
 *
 * @return true if values are validated against column types
 */
-(BOOL) isValueValidation;

/**
 * Set if values should validated against column types
 *
 * @param valueValidation
 *            value validation flag
 */
-(void) setValueValidation: (BOOL) valueValidation;

/**
 * Add a new column
 *
 * @param column
 *            new column
 */
-(void) addColumn: (GPKGUserColumn *) column;

/**
 * Rename column
 *
 * @param column
 *            column
 * @param newColumnName
 *            new column name
 */
-(void) renameColumn: (GPKGUserColumn *) column toColumn: (NSString *) newColumnName;

/**
 * Drop a column
 *
 * @param column
 *            column
 */
-(void) dropColumn: (GPKGUserColumn *) column;

/**
 * Drop columns
 *
 * @param columns
 *            column names
 */
-(void) dropColumns: (NSArray<GPKGUserColumn *> *) columns;

/**
 * Alter a column
 *
 * @param column
 *            column
 */
-(void) alterColumn: (GPKGUserColumn *) column;

/**
 * Alter columns
 *
 * @param columns
 *            columns
 */
-(void) alterColumns: (NSArray<GPKGUserColumn *> *) columns;

@end

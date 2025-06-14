//
//  GPKGUrlTileGenerator.h
//  geopackage-ios
//
//  Created by Brian Osborn on 6/18/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGTileGenerator.h>

/**
 *  Creates a set of tiles within a GeoPackage by downloading the tiles from a URL
 */
@interface GPKGUrlTileGenerator : GPKGTileGenerator

/**
 *  TMS URL flag, when true x,y,z converted to TMS when requesting the tile
 */
@property (nonatomic) BOOL tms;

/**
 *  The HTTP request method, when nil default is "GET"
 */
@property (nonatomic) NSString *httpMethod;

/**
 *  Initialize
 *
 *  @param geoPackage GeoPackage
 *  @param tableName  table name
 *  @param tileUrl    tile URL
 *  @param boundingBox tiles bounding box
 *  @param projection tiles projection
 *
 *  @return new url tile generator
 */
-(instancetype) initWithGeoPackage: (GPKGGeoPackage *) geoPackage andTableName: (NSString *) tableName andTileUrl: (NSString *) tileUrl andBoundingBox: (GPKGBoundingBox *) boundingBox andProjection: (PROJProjection *) projection;

/**
 *  Initialize
 *
 *  @param geoPackage GeoPackage
 *  @param tableName  table name
 *  @param tileUrl    tile URL
 *  @param zoomLevel   zoom level
 *  @param boundingBox tiles bounding box
 *  @param projection tiles projection
 *
 *  @return new url tile generator
 */
-(instancetype) initWithGeoPackage: (GPKGGeoPackage *) geoPackage andTableName: (NSString *) tableName andTileUrl: (NSString *) tileUrl andZoom: (int) zoomLevel andBoundingBox: (GPKGBoundingBox *) boundingBox andProjection: (PROJProjection *) projection;

/**
 *  Initialize
 *
 *  @param geoPackage GeoPackage
 *  @param tableName  table name
 *  @param tileUrl    tile URL
 *  @param minZoom    min zoom
 *  @param maxZoom    max zoom
 *  @param boundingBox tiles bounding box
 *  @param projection tiles projection
 *
 *  @return new url tile generator
 */
-(instancetype) initWithGeoPackage: (GPKGGeoPackage *) geoPackage andTableName: (NSString *) tableName andTileUrl: (NSString *) tileUrl andMinZoom: (int) minZoom andMaxZoom: (int) maxZoom andBoundingBox: (GPKGBoundingBox *) boundingBox andProjection: (PROJProjection *) projection;

/**
 *  Initialize
 *
 *  @param geoPackage GeoPackage
 *  @param tableName  table name
 *  @param tileUrl    tile URL
 *  @param zoomLevels  zoom levels
 *  @param boundingBox tiles bounding box
 *  @param projection tiles projection
 *
 *  @return new url tile generator
 */
-(instancetype) initWithGeoPackage: (GPKGGeoPackage *) geoPackage andTableName: (NSString *) tableName andTileUrl: (NSString *) tileUrl andZoomLevels: (NSArray<NSNumber *> *) zoomLevels andBoundingBox: (GPKGBoundingBox *) boundingBox andProjection: (PROJProjection *) projection;

/**
 *  Get the HTTP Header fields and field values
 *
 *  @return header map
 */
-(NSDictionary<NSString *, NSArray<NSString *> *> *) httpHeader;

/**
 *  Get the HTTP Header field values
 *
 *  @param field    field name
 *
 *  @return field values
 */
-(NSArray<NSString *> *) httpHeaderValuesforField: (NSString *) field;

/**
 *  Add a HTTP Header field value, appending to any existing values for the field
 *
 *  @param value    field value
 *  @param field    field name
 */
-(void) addValue: (NSString *) value forHTTPHeaderField: (NSString *) field;

/**
 *  Add HTTP Header field values, appending to any existing values for the field
 *
 *  @param values    field values
 *  @param field    field name
 */
-(void) addValues: (NSArray<NSString *> *) values forHTTPHeaderField: (NSString *) field;

@end

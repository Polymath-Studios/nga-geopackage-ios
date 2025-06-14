//
//  GPKGFeatureTileGenerator.h
//  geopackage-ios
//
//  Created by Brian Osborn on 6/17/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGTileGenerator.h>
#import <GeoPackage/GPKGFeatureTiles.h>

/**
 *  Creates a set of tiles within a GeoPackage by generating tiles from features
 */
@interface GPKGFeatureTileGenerator : GPKGTileGenerator

/**
 *  Flag indicating whether the feature and tile tables should be linked
 */
@property (nonatomic) BOOL linkTables;

/**
 *  Initialize
 *
 *  @param geoPackage   GeoPackage
 *  @param tableName    table name
 *  @param featureTiles feature tiles
 *  @param minZoom      min zoom
 *  @param maxZoom      max zoom
 *  @param boundingBox tiles bounding box
 *  @param projection tiles projection
 *
 *  @return new feature tile generator
 */
-(instancetype) initWithGeoPackage: (GPKGGeoPackage *) geoPackage andTableName: (NSString *) tableName andFeatureTiles: (GPKGFeatureTiles *) featureTiles andMinZoom: (int) minZoom andMaxZoom: (int) maxZoom andBoundingBox: (GPKGBoundingBox *) boundingBox andProjection: (PROJProjection *) projection;

/**
 * Initialize
 *
 * @param geoPackage        GeoPackage
 * @param tableName         table name
 * @param featureTiles      feature tiles
 * @param featureGeoPackage feature GeoPackage if different from the destination
 * @param minZoom           min zoom
 * @param maxZoom           max zoom
 * @param boundingBox       tiles bounding box
 * @param projection        tiles projection
 */
-(instancetype) initWithGeoPackage: (GPKGGeoPackage *) geoPackage andTableName: (NSString *) tableName andFeatureTiles: (GPKGFeatureTiles *) featureTiles andFeatureGeoPackage: (GPKGGeoPackage *) featureGeoPackage andMinZoom: (int) minZoom andMaxZoom: (int) maxZoom andBoundingBox: (GPKGBoundingBox *) boundingBox andProjection: (PROJProjection *) projection;

/**
 * Initialize, find the the bounding box from the feature table
 *
 * @param geoPackage   GeoPackage
 * @param tableName    table name
 * @param featureTiles feature tiles
 * @param minZoom      min zoom
 * @param maxZoom      max zoom
 * @param projection   tiles projection
 */
-(instancetype) initWithGeoPackage: (GPKGGeoPackage *) geoPackage andTableName: (NSString *) tableName andFeatureTiles: (GPKGFeatureTiles *) featureTiles andMinZoom: (int) minZoom andMaxZoom: (int) maxZoom andProjection: (PROJProjection *) projection;

/**
 * Initialize, find the the bounding box from the feature table
 *
 * @param geoPackage        GeoPackage
 * @param tableName         table name
 * @param featureTiles      feature tiles
 * @param featureGeoPackage feature GeoPackage if different from the destination
 * @param minZoom           min zoom
 * @param maxZoom           max zoom
 * @param projection        tiles projection
 */
-(instancetype) initWithGeoPackage: (GPKGGeoPackage *) geoPackage andTableName: (NSString *) tableName andFeatureTiles: (GPKGFeatureTiles *) featureTiles andFeatureGeoPackage: (GPKGGeoPackage *) featureGeoPackage andMinZoom: (int) minZoom andMaxZoom: (int) maxZoom andProjection: (PROJProjection *) projection;

@end

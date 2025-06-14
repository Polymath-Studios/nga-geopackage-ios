//
//  GPKGCoverageDataTileMatrixResults.h
//  geopackage-ios
//
//  Created by Brian Osborn on 11/18/16.
//  Copyright © 2016 NGA. All rights reserved.
//

#import <GeoPackage/GPKGTileMatrix.h>
#import <GeoPackage/GPKGResultSet.h>

/**
 * Coverage Data Tile Matrix results including the coverage data tile results
 * and the tile matrix where found
 */
@interface GPKGCoverageDataTileMatrixResults : NSObject

/**
 *  Initialize
 *
 *  @param tileMatrix tile matrix
 *  @param tileResults tile results
 *
 *  @return new instance
 */
-(instancetype) initWithTileMatrix: (GPKGTileMatrix *) tileMatrix andTileResults: (GPKGResultSet *) tileResults;

/**
 * Get the tile matrix
 *
 * @return tile matrix
 */
-(GPKGTileMatrix *) tileMatrix;

/**
 * Get the tile results
 *
 * @return tile results
 */
-(GPKGResultSet *) tileResults;

@end

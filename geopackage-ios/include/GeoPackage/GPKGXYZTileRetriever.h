//
//  GPKGXYZTileRetriever.h
//  geopackage-ios
//
//  Created by Brian Osborn on 3/9/16.
//  Copyright © 2016 NGA. All rights reserved.
//

#import <GeoPackage/GPKGTileRetriever.h>
#import <GeoPackage/GPKGTileDao.h>

/**
 *  XYZ Tile Retriever, assumes XYZ tiles
 */
@interface GPKGXYZTileRetriever : NSObject<GPKGTileRetriever>

/**
 *  Initializer
 *
 *  @param tileDao tile DAO
 *
 *  @return new instance
 */
-(instancetype) initWithTileDao: (GPKGTileDao *) tileDao;

@end

//
//  GPKGTileScalingTableCreator.m
//  geopackage-ios
//
//  Created by Brian Osborn on 9/3/20.
//  Copyright © 2020 NGA. All rights reserved.
//

#import <GeoPackage/GPKGTileScalingTableCreator.h>
#import <GeoPackage/GPKGTileScaling.h>

@implementation GPKGTileScalingTableCreator

-(instancetype) initWithDatabase: (GPKGConnection *) database{
    self = [super initWithDatabase:database];
    return self;
}

-(int) createTileScaling{
    return [self createTable:GPKG_TS_TABLE_NAME];
}

@end

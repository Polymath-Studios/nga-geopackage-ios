//
//  GPKGFeatureTileLinkTableCreator.m
//  geopackage-ios
//
//  Created by Brian Osborn on 9/3/20.
//  Copyright © 2020 NGA. All rights reserved.
//

#import <GeoPackage/GPKGFeatureTileLinkTableCreator.h>
#import <GeoPackage/GPKGFeatureTileLink.h>

@implementation GPKGFeatureTileLinkTableCreator

-(instancetype) initWithDatabase: (GPKGConnection *) database{
    self = [super initWithDatabase:database];
    return self;
}

-(int) createFeatureTileLink{
    return [self createTable:GPKG_FTL_TABLE_NAME];
}

@end

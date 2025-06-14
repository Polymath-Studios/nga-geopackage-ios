//
//  GPKGTableIndex.m
//  geopackage-ios
//
//  Created by Brian Osborn on 10/12/15.
//  Copyright © 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGTableIndex.h>

NSString * const GPKG_TI_TABLE_NAME = @"nga_table_index";
NSString * const GPKG_TI_COLUMN_PK = @"table_name";
NSString * const GPKG_TI_COLUMN_TABLE_NAME = @"table_name";
NSString * const GPKG_TI_COLUMN_LAST_INDEXED = @"last_indexed";

@implementation GPKGTableIndex

-(id) mutableCopyWithZone: (NSZone *) zone{
    GPKGTableIndex *tableIndex = [[GPKGTableIndex alloc] init];
    tableIndex.tableName = _tableName;
    tableIndex.lastIndexed = _lastIndexed;
    return tableIndex;
}

@end

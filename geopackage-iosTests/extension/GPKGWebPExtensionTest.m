//
//  GPKGWebPExtensionTest.m
//  geopackage-ios
//
//  Created by Brian Osborn on 5/5/16.
//  Copyright © 2016 NGA. All rights reserved.
//

#import "GPKGWebPExtensionTest.h"
#import "GPKGTestUtils.h"

@import GeoPackage;

@implementation GPKGWebPExtensionTest

/**
 *  Test the WebP Extension creation
 */
-(void) testWebPExtension{
    
    GPKGWebPExtension *webpExtension = [[GPKGWebPExtension alloc] initWithGeoPackage:self.geoPackage];
    
    NSString * tableName = @"table";
    
    GPKGExtensions *extension = [webpExtension extensionCreateWithTableName:tableName];
    [GPKGTestUtils assertNotNil:extension];
    [GPKGTestUtils assertTrue:[webpExtension hasWithTableName:tableName]];
     
    [GPKGTestUtils assertEqualWithValue:extension.extensionName andValue2:[NSString stringWithFormat:@"%@%@%@", GPKG_EXTENSION_AUTHOR, GPKG_EX_EXTENSION_NAME_DIVIDER, GPKG_WEBP_EXTENSION_NAME]];
    [GPKGTestUtils assertEqualWithValue:[extension author] andValue2:GPKG_EXTENSION_AUTHOR];
    [GPKGTestUtils assertEqualWithValue:[extension extensionNameNoAuthor] andValue2:GPKG_WEBP_EXTENSION_NAME];
    [GPKGTestUtils assertEqualWithValue:extension.tableName andValue2:tableName];
    [GPKGTestUtils assertEqualWithValue:extension.columnName andValue2:GPKG_TC_COLUMN_TILE_DATA];
    [GPKGTestUtils assertEqualIntWithValue:[extension extensionScopeType] andValue2:GPKG_EST_READ_WRITE];
    [GPKGTestUtils assertEqualWithValue:extension.definition andValue2:[GPKGProperties valueOfProperty:@"geopackage.extensions.webp"]];
    
    [[GPKGExtensionManager createWithGeoPackage:self.geoPackage] deleteExtensionsForTable:tableName];
    [GPKGTestUtils assertFalse:[webpExtension hasWithTableName:tableName]];
}

@end

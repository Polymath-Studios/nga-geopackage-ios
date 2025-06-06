//
//  GPKGFeatureStylesUtils.m
//  geopackage-iosTests
//
//  Created by Brian Osborn on 2/8/19.
//  Copyright © 2019 NGA. All rights reserved.
//

#import "GPKGFeatureStylesUtils.h"
#import "GPKGTestUtils.h"
#import "GPKGTestConstants.h"
#import "GPKGBundleHelper.h"

@import SimpleFeatures;


@implementation GPKGFeatureStylesUtils

+(void) testFeatureStylesWithGeoPackage: (GPKGGeoPackage *) geoPackage{
    
    [[GPKGExtensionManager createWithGeoPackage:geoPackage] deleteExtensions];
    
    GPKGFeatureStyleExtension *featureStyleExtension = [[GPKGFeatureStyleExtension alloc] initWithGeoPackage:geoPackage];
    
    [GPKGTestUtils assertFalse:[featureStyleExtension has]];
    
    NSArray<NSString *> *featureTables = [geoPackage featureTables];
    
    if(featureTables.count > 0){
        
        [GPKGTestUtils assertFalse:[geoPackage isTable:GPKG_ST_TABLE_NAME]];
        [GPKGTestUtils assertFalse:[geoPackage isTable:GPKG_IT_TABLE_NAME]];
        [GPKGTestUtils assertFalse:[geoPackage isTable:GPKG_CI_TABLE_NAME]];
        
        for(NSString *tableName in featureTables){
            
            [GPKGTestUtils assertFalse:[featureStyleExtension hasWithTable:tableName]];
            
            GPKGFeatureDao *featureDao = [geoPackage featureDaoWithTableName:tableName];
            
            GPKGFeatureTableStyles *featureTableStyles = [[GPKGFeatureTableStyles alloc] initWithGeoPackage:geoPackage andTable:[featureDao featureTable]];
            [GPKGTestUtils assertFalse:[featureTableStyles has]];
            
            enum SFGeometryType geometryType = [featureDao geometryType];
            NSDictionary<NSNumber *, NSDictionary *> *childGeometryTypes = [SFGeometryUtils childHierarchyOfType:geometryType];
            
            [GPKGTestUtils assertFalse:[featureTableStyles hasTableStyleRelationship]];
            [GPKGTestUtils assertFalse:[featureTableStyles hasStyleRelationship]];
            [GPKGTestUtils assertFalse:[featureTableStyles hasTableIconRelationship]];
            [GPKGTestUtils assertFalse:[featureTableStyles hasIconRelationship]];
            
            [GPKGTestUtils assertNotNil:[featureTableStyles tableName]];
            [GPKGTestUtils assertEqualWithValue:tableName andValue2:[featureTableStyles tableName]];
            [GPKGTestUtils assertNotNil:[featureTableStyles featureStyleExtension]];
            
            [GPKGTestUtils assertNil:[featureTableStyles tableFeatureStyles]];
            [GPKGTestUtils assertNil:[featureTableStyles tableStyles]];
            [GPKGTestUtils assertNil:[featureTableStyles cachedTableStyles]];
            [GPKGTestUtils assertNil:[featureTableStyles tableStyleDefault]];
            [GPKGTestUtils assertNil:[featureTableStyles tableStyleWithGeometryType:SF_GEOMETRY]];
            [GPKGTestUtils assertNil:[featureTableStyles tableIcons]];
            [GPKGTestUtils assertNil:[featureTableStyles cachedTableIcons]];
            [GPKGTestUtils assertNil:[featureTableStyles tableIconDefault]];
            [GPKGTestUtils assertNil:[featureTableStyles tableIconWithGeometryType:SF_GEOMETRY]];
            
            GPKGResultSet *featureResultSet = [featureDao queryForAll];
            while([featureResultSet moveToNext]){
                GPKGFeatureRow *featureRow = [featureDao row:featureResultSet];
                
                [GPKGTestUtils assertNil:[featureTableStyles featureStylesWithFeature:featureRow]];
                [GPKGTestUtils assertNil:[featureTableStyles featureStylesWithIdNumber:[featureRow id]]];
                
                [GPKGTestUtils assertNil:[featureTableStyles featureStyleWithFeature:featureRow]];
                [GPKGTestUtils assertNil:[featureTableStyles featureStyleDefaultWithFeature:featureRow]];
                [GPKGTestUtils assertNil:[featureTableStyles featureStyleWithIdNumber:[featureRow id] andGeometryType:[featureRow geometryType]]];
                [GPKGTestUtils assertNil:[featureTableStyles featureStyleDefaultWithIdNumber:[featureRow id]]];

                [GPKGTestUtils assertNil:[featureTableStyles stylesWithFeature:featureRow]];
                [GPKGTestUtils assertNil:[featureTableStyles stylesWithIdNumber:[featureRow id]]];
                
                [GPKGTestUtils assertNil:[featureTableStyles styleWithFeature:featureRow]];
                [GPKGTestUtils assertNil:[featureTableStyles styleDefaultWithFeature:featureRow]];
                [GPKGTestUtils assertNil:[featureTableStyles styleWithIdNumber:[featureRow id] andGeometryType:[featureRow geometryType]]];
                [GPKGTestUtils assertNil:[featureTableStyles styleDefaultWithIdNumber:[featureRow id]]];
                
                [GPKGTestUtils assertNil:[featureTableStyles  iconsWithFeature:featureRow]];
                [GPKGTestUtils assertNil:[featureTableStyles iconsWithIdNumber:[featureRow id]]];
                
                [GPKGTestUtils assertNil:[featureTableStyles iconWithFeature:featureRow]];
                [GPKGTestUtils assertNil:[featureTableStyles iconDefaultWithFeature:featureRow]];
                [GPKGTestUtils assertNil:[featureTableStyles iconWithIdNumber:[featureRow id] andGeometryType:[featureRow geometryType]]];
                [GPKGTestUtils assertNil:[featureTableStyles iconDefaultWithIdNumber:[featureRow id]]];
            }
            [featureResultSet close];
            
            // Table Styles
            [GPKGTestUtils assertFalse:[featureTableStyles hasTableStyleRelationship]];
            [GPKGTestUtils assertFalse:[geoPackage isTable:[[featureTableStyles featureStyleExtension] mappingTableNameWithPrefix:GPKG_FSE_TABLE_MAPPING_TABLE_STYLE andTable:tableName]]];
            
            // Add a default table style
            GPKGStyleRow *tableStyleDefault = [self randomStyle];
            [featureTableStyles setTableStyleDefault:tableStyleDefault];
            
            [GPKGTestUtils assertTrue:[featureStyleExtension has]];
            [GPKGTestUtils assertTrue:[featureStyleExtension hasWithTable:tableName]];
            [GPKGTestUtils assertTrue:[featureTableStyles has]];
            [GPKGTestUtils assertTrue:[featureTableStyles hasTableStyleRelationship]];
            [GPKGTestUtils assertTrue:[geoPackage isTable:GPKG_ST_TABLE_NAME]];
            [GPKGTestUtils assertTrue:[geoPackage isTable:GPKG_CI_TABLE_NAME]];
            [GPKGTestUtils assertTrue:[geoPackage isTable:[[featureTableStyles featureStyleExtension] mappingTableNameWithPrefix:GPKG_FSE_TABLE_MAPPING_TABLE_STYLE andTable:tableName]]];
            
            // Add geometry type table styles
            NSMutableDictionary *geometryTypeTableStyles = [self randomStylesWithGeometryTypes:childGeometryTypes];
            for(NSNumber *geometryTypeNumber in [geometryTypeTableStyles allKeys]){
                enum SFGeometryType geometryType = (enum SFGeometryType) [geometryTypeNumber intValue];
                GPKGStyleRow *styleRow = [geometryTypeTableStyles objectForKey:geometryTypeNumber];
                [featureTableStyles setTableStyle:styleRow withGeometryType:geometryType];
            }
            
            GPKGFeatureStyles *featureStyles = [featureTableStyles tableFeatureStyles];
            [GPKGTestUtils assertNotNil:featureStyles];
            [GPKGTestUtils assertNotNil:featureStyles.styles];
            [GPKGTestUtils assertNil:featureStyles.icons];
            
            GPKGStyles *tableStyles = [featureTableStyles tableStyles];
            [GPKGTestUtils assertNotNil:tableStyles];
            [GPKGTestUtils assertNotNil:[tableStyles defaultStyle]];
            [GPKGTestUtils assertEqualWithValue:[tableStyleDefault id] andValue2:[[tableStyles defaultStyle] id]];
            [GPKGTestUtils assertEqualWithValue:[tableStyleDefault id] andValue2:[[featureTableStyles tableStyleWithGeometryType:SF_NONE] id]];
            [GPKGTestUtils assertEqualWithValue:[tableStyleDefault id] andValue2:[[featureTableStyles tableStyleWithGeometryType:geometryType] id]];
            [self validateTableStyles:featureTableStyles andStyle:tableStyleDefault andStyles:geometryTypeTableStyles andTypes:childGeometryTypes];
            
            // Table Icons
            [GPKGTestUtils assertFalse:[featureTableStyles hasTableIconRelationship]];
            [GPKGTestUtils assertFalse:[geoPackage isTable:[[featureTableStyles featureStyleExtension] mappingTableNameWithPrefix:GPKG_FSE_TABLE_MAPPING_TABLE_ICON andTable:tableName]]];
            
            // Create table icon relationship
            [GPKGTestUtils assertFalse:[featureTableStyles hasTableIconRelationship]];
            [featureTableStyles createTableIconRelationship];
            [GPKGTestUtils assertTrue:[featureTableStyles hasTableIconRelationship]];
            
            GPKGIcons *createTableIcons = [[GPKGIcons alloc] init];
            GPKGIconRow *tableIconDefault = [self randomIcon];
            [createTableIcons setDefaultIcon:tableIconDefault];
            NSMutableDictionary<NSNumber *, GPKGIconRow *> *geometryTypeTableIcons = [self randomIconsWithGeometryTypes:childGeometryTypes];
            GPKGIconRow *baseGeometryTypeIcon = [self randomIcon];
            [geometryTypeTableIcons setObject:baseGeometryTypeIcon forKey:[NSNumber numberWithInteger:geometryType]];
            for(NSNumber *geometryTypeNumber in [geometryTypeTableIcons allKeys]){
                [createTableIcons setIcon:[geometryTypeTableIcons objectForKey:geometryTypeNumber] forGeometryType:[geometryTypeNumber intValue]];
            }
            
            // Set the table icons
            [featureTableStyles setTableIcons:createTableIcons];
            
            [GPKGTestUtils assertTrue:[featureTableStyles hasTableIconRelationship]];
            [GPKGTestUtils assertTrue:[geoPackage isTable:GPKG_IT_TABLE_NAME]];
            [GPKGTestUtils assertTrue:[geoPackage isTable:[[featureTableStyles featureStyleExtension] mappingTableNameWithPrefix:GPKG_FSE_TABLE_MAPPING_TABLE_ICON andTable:tableName]]];
            
            featureStyles = [featureTableStyles tableFeatureStyles];
            [GPKGTestUtils assertNotNil:featureStyles];
            [GPKGTestUtils assertNotNil:featureStyles.styles];
            GPKGIcons *tableIcons = featureStyles.icons;
            [GPKGTestUtils assertNotNil:tableIcons];
            
            [GPKGTestUtils assertNotNil:[tableIcons defaultIcon]];
            [GPKGTestUtils assertEqualWithValue:[tableIconDefault id] andValue2:[[tableIcons defaultIcon] id]];
            [GPKGTestUtils assertEqualWithValue:[tableIconDefault id] andValue2:[[featureTableStyles tableIconWithGeometryType:SF_NONE] id]];
            [GPKGTestUtils assertEqualWithValue:[baseGeometryTypeIcon id] andValue2:[[featureTableStyles tableIconWithGeometryType:geometryType] id]];
            [self validateTableIcons:featureTableStyles andIcon:baseGeometryTypeIcon andIcons:geometryTypeTableIcons andTypes:childGeometryTypes];
            
            [GPKGTestUtils assertFalse:[featureTableStyles hasStyleRelationship]];
            [GPKGTestUtils assertFalse:[geoPackage isTable:[[featureTableStyles featureStyleExtension] mappingTableNameWithPrefix:GPKG_FSE_TABLE_MAPPING_STYLE andTable:tableName]]];
            [GPKGTestUtils assertFalse:[featureTableStyles hasIconRelationship]];
            [GPKGTestUtils assertFalse:[geoPackage isTable:[[featureTableStyles featureStyleExtension] mappingTableNameWithPrefix:GPKG_FSE_TABLE_MAPPING_ICON andTable:tableName]]];
            
            GPKGStyleDao *styleDao = [featureTableStyles styleDao];
            GPKGIconDao *iconDao = [featureTableStyles iconDao];
            
            NSMutableArray<GPKGStyleRow *> *randomStyles = [NSMutableArray array];
            NSMutableArray<GPKGIconRow *> *randomIcons = [NSMutableArray array];
            for (int i = 0; i < 10; i++) {
                GPKGStyleRow *styleRow = [self randomStyle];
                [randomStyles addObject:styleRow];
                GPKGIconRow *iconRow = [self randomIcon];
                [randomIcons addObject:iconRow];
                
                if (i % 2 == 0) {
                    [styleDao insert:styleRow];
                    [iconDao insert:iconRow];
                }
            }
            
            // Create style and icon relationship
            [featureTableStyles createStyleRelationship];
            [GPKGTestUtils assertTrue:[featureTableStyles hasStyleRelationship]];
            [GPKGTestUtils assertTrue:[geoPackage isTable:[[featureTableStyles featureStyleExtension] mappingTableNameWithPrefix:GPKG_FSE_TABLE_MAPPING_STYLE andTable:tableName]]];
            [featureTableStyles createIconRelationship];
            [GPKGTestUtils assertTrue:[featureTableStyles hasIconRelationship]];
            [GPKGTestUtils assertTrue:[geoPackage isTable:[[featureTableStyles featureStyleExtension] mappingTableNameWithPrefix:GPKG_FSE_TABLE_MAPPING_ICON andTable:tableName]]];
            
            NSMutableDictionary<NSNumber *, NSMutableDictionary *> *featureResultsStyles = [NSMutableDictionary dictionary];
            NSMutableDictionary<NSNumber *, NSMutableDictionary *> *featureResultsIcons = [NSMutableDictionary dictionary];
            
            featureResultSet = [featureDao queryForAll];
            while([featureResultSet moveToNext]){
                
                double randomFeatureOption = [GPKGTestUtils randomDouble];
                
                if (randomFeatureOption < .25) {
                    continue;
                }
                
                GPKGFeatureRow *featureRow = [featureDao row:featureResultSet];
                
                if (randomFeatureOption < .75) {
                    
                    // Feature Styles
                    
                    NSMutableDictionary<NSNumber *, GPKGStyleRow *> *featureRowStyles = [NSMutableDictionary dictionary];
                    [featureResultsStyles setObject:featureRowStyles forKey:[featureRow id]];
                    
                    // Add a default style
                    GPKGStyleRow *styleDefault = [self randomStyleWithRandomStyles:randomStyles];
                    [featureTableStyles setStyleDefault:styleDefault withFeature:featureRow];
                    [featureRowStyles setObject:styleDefault forKey:[NSNumber numberWithInt:SF_NONE]];
                    
                    // Add geometry type styles
                    NSMutableDictionary<NSNumber *, GPKGStyleRow *> *geometryTypeStyles = [self randomStylesWithGeometryTypes:childGeometryTypes andRandomSyles:randomStyles];
                    for(NSNumber *geometryTypeStyleNumber in [geometryTypeStyles allKeys]){
                        enum SFGeometryType geometryTypeStyle = (enum SFGeometryType) [geometryTypeStyleNumber intValue];
                        GPKGStyleRow *style = [geometryTypeStyles objectForKey:geometryTypeStyleNumber];
                        [featureTableStyles setStyle:style withFeature:featureRow andGeometryType:geometryTypeStyle];
                        [featureRowStyles setObject:style forKey:geometryTypeStyleNumber];
                    }
                    
                }
                
                if (randomFeatureOption >= .5) {
                    
                    // Feature Icons
                    
                    NSMutableDictionary<NSNumber *, GPKGIconRow *> *featureRowIcons = [NSMutableDictionary dictionary];
                    [featureResultsIcons setObject:featureRowIcons forKey:[featureRow id]];
                    
                    // Add a default icon
                    GPKGIconRow *iconDefault = [self randomIconWithRandomIcons:randomIcons];
                    [featureTableStyles setIconDefault:iconDefault withFeature:featureRow];
                    [featureRowIcons setObject:iconDefault forKey:[NSNumber numberWithInt:SF_NONE]];
                    
                    // Add geometry type icons
                    NSMutableDictionary<NSNumber *, GPKGIconRow *> *geometryTypeIcons = [self randomIconsWithGeometryTypes:childGeometryTypes andRandomIcons:randomIcons];
                    for(NSNumber *geometryTypeIconNumber in [geometryTypeIcons allKeys]){
                        enum SFGeometryType geometryTypeIcon = (enum SFGeometryType) [geometryTypeIconNumber intValue];
                        GPKGIconRow *icon = [geometryTypeIcons objectForKey:geometryTypeIconNumber];
                        [featureTableStyles setIcon:icon withFeature:featureRow andGeometryType:geometryTypeIcon];
                        [featureRowIcons setObject:icon forKey:geometryTypeIconNumber];
                    }
                    
                }
                
            }
            [featureResultSet close];
            
            NSDictionary<NSNumber *, GPKGStyleRow *> *allStyles = [featureTableStyles styles];
            NSDictionary<NSNumber *, GPKGStyleRow *> *allFeatureStyles = [featureTableStyles featureStyles];
            for(NSNumber *styleId in [allFeatureStyles allKeys]){
                [GPKGTestUtils assertNotNil:[allStyles objectForKey:styleId]];
            }
            NSDictionary<NSNumber *, GPKGIconRow *> *allIcons = [featureTableStyles icons];
            NSDictionary<NSNumber *, GPKGIconRow *> *allFeatureIcons = [featureTableStyles featureIcons];
            for(NSNumber *iconId in [allFeatureIcons allKeys]){
                [GPKGTestUtils assertNotNil:[allIcons objectForKey:iconId]];
            }
            
            featureResultSet = [featureDao queryForAll];
            while([featureResultSet moveToNext]){
                
                GPKGFeatureRow *featureRow = [featureDao row:featureResultSet];
                
                NSNumber *featureRowId = [featureRow id];
                NSMutableDictionary<NSNumber *, GPKGStyleRow *> *featureRowStyles = [featureResultsStyles objectForKey:featureRowId];
                BOOL hasFeatureRowStyles = featureRowStyles != nil;
                NSMutableDictionary<NSNumber *, GPKGIconRow *> *featureRowIcons = [featureResultsIcons objectForKey:featureRowId];
                BOOL hasFeatureRowIcons = featureRowIcons !=  nil;
                GPKGFeatureStyle *featureStyle = [featureTableStyles featureStyleWithFeature:featureRow];
                [GPKGTestUtils assertNotNil:featureStyle];
                [GPKGTestUtils assertTrue:[featureStyle hasStyle]];
                [GPKGTestUtils assertNotNil:featureStyle.style];
                [GPKGTestUtils assertEqualBoolWithValue:!hasFeatureRowStyles andValue2:featureStyle.style.tableStyle];
                GPKGStyleRow *expectedStyleRow = [self expectedRowStyle:featureRow andGeometryType:[featureRow geometryType] andTableStyleDefault:tableStyleDefault andTableStyles:geometryTypeTableStyles andFeatureStyles:featureResultsStyles];
                [GPKGTestUtils assertEqualWithValue:[expectedStyleRow id] andValue2:[featureStyle.style id]];
                [GPKGTestUtils assertTrue:[featureStyle hasIcon]];
                [GPKGTestUtils assertNotNil:featureStyle.icon];
                [GPKGTestUtils assertEqualBoolWithValue:!hasFeatureRowIcons andValue2:featureStyle.icon.tableIcon];
                GPKGIconRow *expectedIconRow = [self expectedRowIcon:featureRow andGeometryType:[featureRow geometryType] andTableIconDefault:tableIconDefault andTableIcons:geometryTypeTableIcons andFeatureIcons:featureResultsIcons];
                [GPKGTestUtils assertEqualWithValue:[expectedIconRow id] andValue2:[featureStyle.icon id]];
                [GPKGTestUtils assertEqualBoolWithValue:hasFeatureRowIcons || !hasFeatureRowStyles andValue2:[featureStyle useIcon]];
                
                [self validateRowStyles:featureTableStyles andFeature:featureRow andTableStyleDefault:tableStyleDefault andTableStyles:geometryTypeTableStyles andFeatureStyles:featureResultsStyles];
                
                [self validateRowIcons:featureTableStyles andFeature:featureRow andTableIconDefault:tableIconDefault andTableIcons:geometryTypeTableIcons andFeatureIcons:featureResultsIcons];
                
            }
            [featureResultSet close];
            
        }

        NSArray<NSString *> *tables = [featureStyleExtension tables];
        [GPKGTestUtils assertEqualUnsignedLongWithValue:featureTables.count andValue2:tables.count];
        
        for(NSString *tableName in featureTables){
            
            [GPKGTestUtils assertTrue:[tables containsObject:tableName]];
            
            [GPKGTestUtils assertNotNil:[featureStyleExtension tableStylesWithTableName:tableName]];
            [GPKGTestUtils assertNotNil:[featureStyleExtension tableIconsWithTableName:tableName]];
            
            [featureStyleExtension deleteAllFeatureStylesWithTableName:tableName];
            
            [GPKGTestUtils assertNil:[featureStyleExtension tableStylesWithTableName:tableName]];
            [GPKGTestUtils assertNil:[featureStyleExtension tableIconsWithTableName:tableName]];
            
            GPKGFeatureDao *featureDao = [geoPackage featureDaoWithTableName:tableName];
            GPKGResultSet *featureResultSet = [featureDao queryForAll];
            while([featureResultSet moveToNext]){
                
                GPKGFeatureRow *featureRow = [featureDao row:featureResultSet];
                
                [GPKGTestUtils assertNil:[featureStyleExtension stylesWithFeature:featureRow]];
                [GPKGTestUtils assertNil:[featureStyleExtension iconsWithFeature:featureRow]];
                
            }
            [featureResultSet close];
            
            [featureStyleExtension deleteRelationshipsWithTable:tableName];
            [GPKGTestUtils assertFalse:[featureStyleExtension hasWithTable:tableName]];
            
        }
        
        [GPKGTestUtils assertFalse:[featureStyleExtension has]];
        
        [GPKGTestUtils assertTrue:[geoPackage isTable:GPKG_ST_TABLE_NAME]];
        [GPKGTestUtils assertTrue:[geoPackage isTable:GPKG_IT_TABLE_NAME]];
        [GPKGTestUtils assertTrue:[geoPackage isTable:GPKG_CI_TABLE_NAME]];
        
        [featureStyleExtension removeExtension];
        
        [GPKGTestUtils assertFalse:[geoPackage isTable:GPKG_ST_TABLE_NAME]];
        [GPKGTestUtils assertFalse:[geoPackage isTable:GPKG_IT_TABLE_NAME]];
        [GPKGTestUtils assertTrue:[geoPackage isTable:GPKG_CI_TABLE_NAME]];
        
        GPKGContentsIdExtension *contentsIdExtension = [featureStyleExtension contentsId];
        [GPKGTestUtils assertEqualIntWithValue:(int)featureTables.count andValue2:[contentsIdExtension count]];
        [GPKGTestUtils assertEqualIntWithValue:(int)featureTables.count andValue2:[contentsIdExtension deleteIds]];
        [contentsIdExtension removeExtension];
        [GPKGTestUtils assertFalse:[geoPackage isTable:GPKG_CI_TABLE_NAME]];
        
    }

}

+(void) validateTableStyles: (GPKGFeatureTableStyles *) featureTableStyles andStyle: (GPKGStyleRow *) styleRow andStyles: (NSDictionary *) geometryTypeStyles andTypes: (NSDictionary *) geometryTypes{
    
    if(geometryTypes != nil){
        for(NSNumber *typeNumber in [geometryTypes allKeys]){
            enum SFGeometryType type = (enum SFGeometryType) [typeNumber intValue];
            GPKGStyleRow *typeStyleRow = styleRow;
            if([geometryTypeStyles objectForKey:typeNumber] != nil){
                typeStyleRow = [geometryTypeStyles objectForKey:typeNumber];
            }
            [GPKGTestUtils assertEqualWithValue:[typeStyleRow id] andValue2:[[featureTableStyles tableStyleWithGeometryType:type] id]];
            NSDictionary *childGeometryTypes = [geometryTypes objectForKey:typeNumber];
            [self validateTableStyles:featureTableStyles andStyle:typeStyleRow andStyles:geometryTypeStyles andTypes:childGeometryTypes];
        }
    }
}

+(void) validateTableIcons: (GPKGFeatureTableStyles *) featureTableStyles andIcon: (GPKGIconRow *) iconRow andIcons: (NSDictionary *) geometryTypeIcons andTypes: (NSDictionary *) geometryTypes{
    [self validateTableIcons:featureTableStyles andIcon:iconRow andIcons:geometryTypeIcons andTypes:geometryTypes andShared:NO];
}

+(void) validateTableIcons: (GPKGFeatureTableStyles *) featureTableStyles andIcon: (GPKGIconRow *) iconRow andIcons: (NSDictionary *) geometryTypeIcons andTypes: (NSDictionary *) geometryTypes andShared: (BOOL) shared{
    
    if(geometryTypes != nil){
        for(NSNumber *typeNumber in [geometryTypes allKeys]){
            enum SFGeometryType type = (enum SFGeometryType) [typeNumber intValue];
            GPKGIconRow *typeIconRow = iconRow;
            if([geometryTypeIcons objectForKey:typeNumber] != nil){
                typeIconRow = [geometryTypeIcons objectForKey:typeNumber];
                [GPKGTestUtils assertTrue:[typeIconRow idValue] >= 0];
                [GPKGTestUtils assertNotNil:[typeIconRow data]];
                [GPKGTestUtils assertEqualWithValue:[NSString stringWithFormat:@"image/%@", GPKG_TEST_ICON_POINT_IMAGE_EXTENSION] andValue2:[typeIconRow contentType]];
                UIImage *iconImage = [typeIconRow dataImage];
                [GPKGTestUtils assertNotNil:iconImage];
                [GPKGTestUtils assertTrue:iconImage.size.width > 0];
                [GPKGTestUtils assertTrue:iconImage.size.height > 0];
            }
            if(!shared){
                [GPKGTestUtils assertEqualWithValue:[typeIconRow id] andValue2:[[featureTableStyles tableIconWithGeometryType:type] id]];
            }
            NSDictionary *childGeometryTypes = [geometryTypes objectForKey:typeNumber];
            [self validateTableIcons:featureTableStyles andIcon:typeIconRow andIcons:geometryTypeIcons andTypes:childGeometryTypes andShared:shared];
        }
    }
}

+(void) validateRowStyles: (GPKGFeatureTableStyles *) featureTableStyles andFeature: (GPKGFeatureRow *) featureRow andTableStyleDefault: (GPKGStyleRow *) tableStyleDefault andTableStyles: (NSDictionary *) geometryTypeTableStyles andFeatureStyles: (NSDictionary *) featureResultsStyles{
    
    enum SFGeometryType geometryType = [featureRow geometryType];
    
    [self validateRowStyles:featureTableStyles andFeature:featureRow andGeometryType:SF_NONE andTableStyleDefault:tableStyleDefault andTableStyles:geometryTypeTableStyles andFeatureStyles:featureResultsStyles];
    
    if(geometryType != SF_NONE && geometryType >= 0){
        
        NSArray<NSNumber *> *geometryTypes = [SFGeometryUtils parentHierarchyOfType:geometryType];
        for(NSNumber *parentGeometryTypeNumber in geometryTypes){
            enum SFGeometryType parentGeometryType = (enum SFGeometryType) [parentGeometryTypeNumber intValue];
            [self validateRowStyles:featureTableStyles andFeature:featureRow andGeometryType:parentGeometryType andTableStyleDefault:tableStyleDefault andTableStyles:geometryTypeTableStyles andFeatureStyles:featureResultsStyles];
        }
        
        NSArray<NSNumber *> *childTypes = [self allChildTypes:geometryType];
        for(NSNumber *childGeometryTypeNumber in childTypes){
            enum SFGeometryType childGeometryType = (enum SFGeometryType) [childGeometryTypeNumber intValue];
            [self validateRowStyles:featureTableStyles andFeature:featureRow andGeometryType:childGeometryType andTableStyleDefault:tableStyleDefault andTableStyles:geometryTypeTableStyles andFeatureStyles:featureResultsStyles];
        }
    }
    
}

+(void) validateRowStyles: (GPKGFeatureTableStyles *) featureTableStyles andFeature: (GPKGFeatureRow *) featureRow andGeometryType: (enum SFGeometryType) geometryType andTableStyleDefault: (GPKGStyleRow *) tableStyleDefault andTableStyles: (NSDictionary *) geometryTypeTableStyles andFeatureStyles: (NSDictionary *) featureResultsStyles{
    
    GPKGStyleRow *styleRow = nil;
    if (geometryType == SF_NONE || geometryType < 0) {
        styleRow = [featureTableStyles styleWithFeature:featureRow];
        geometryType = [featureRow geometryType];
    } else {
        styleRow = [featureTableStyles styleWithFeature:featureRow andGeometryType:geometryType];
    }
    
    GPKGStyleRow *expectedStyleRow = [self expectedRowStyle:featureRow andGeometryType:geometryType andTableStyleDefault:tableStyleDefault andTableStyles:geometryTypeTableStyles andFeatureStyles:featureResultsStyles];
    
    if (expectedStyleRow != nil) {
        [GPKGTestUtils assertEqualWithValue:[expectedStyleRow id] andValue2:[styleRow id]];
        [GPKGTestUtils assertNotNil:[styleRow table]];
        [GPKGTestUtils assertTrue:[styleRow idValue] >= 0];
        [styleRow name];
        [styleRow description];
        [styleRow color];
        [styleRow hexColor];
        [styleRow opacity];
        [styleRow width];
        [styleRow fillColor];
        [styleRow fillHexColor];
        [styleRow fillOpacity];
    } else {
        [GPKGTestUtils assertNil:styleRow];
    }
    
}

+(GPKGStyleRow *) expectedRowStyle: (GPKGFeatureRow *) featureRow andGeometryType: (enum SFGeometryType) geometryType andTableStyleDefault: (GPKGStyleRow *) tableStyleDefault andTableStyles: (NSDictionary *) geometryTypeTableStyles andFeatureStyles: (NSDictionary *) featureResultsStyles{
    
    NSMutableArray<NSNumber *> *geometryTypes = [NSMutableArray array];
    if(geometryType != SF_NONE && geometryType >= 0){
        [geometryTypes addObject:[NSNumber numberWithInteger:geometryType]];
        [geometryTypes addObjectsFromArray:[SFGeometryUtils parentHierarchyOfType:geometryType]];
    }
    [geometryTypes addObject:[NSNumber numberWithInt:SF_NONE]];
    
    GPKGStyleRow *expectedStyleRow = nil;
    NSDictionary *geometryTypeRowStyles = [featureResultsStyles objectForKey:[featureRow id]];
    if(geometryTypeRowStyles != nil){
        for(NSNumber *typeNumber in geometryTypes){
            expectedStyleRow = [geometryTypeRowStyles objectForKey:typeNumber];
            if(expectedStyleRow != nil){
                break;
            }
        }
    }
    
    if (expectedStyleRow == nil) {
        for(NSNumber *typeNumber in geometryTypes){
            expectedStyleRow = [geometryTypeTableStyles objectForKey:typeNumber];
            if(expectedStyleRow != nil){
                break;
            }
        }
        
        if (expectedStyleRow == nil) {
            expectedStyleRow = tableStyleDefault;
        }
    }
    
    return expectedStyleRow;
}

+(void) validateRowIcons: (GPKGFeatureTableStyles *) featureTableStyles andFeature: (GPKGFeatureRow *) featureRow andTableIconDefault: (GPKGIconRow *) tableIconDefault andTableIcons: (NSDictionary *) geometryTypeTableIcons andFeatureIcons: (NSDictionary *) featureResultsIcons{
    
    enum SFGeometryType geometryType = [featureRow geometryType];
    
    [self validateRowIcons:featureTableStyles andFeature:featureRow andGeometryType:SF_NONE andTableIconDefault:tableIconDefault andTableIcons:geometryTypeTableIcons andFeatureIcons:featureResultsIcons];
    
    if(geometryType != SF_NONE && geometryType >= 0){
        
        NSArray<NSNumber *> *geometryTypes = [SFGeometryUtils parentHierarchyOfType:geometryType];
        for(NSNumber *parentGeometryTypeNumber in geometryTypes){
            enum SFGeometryType parentGeometryType = (enum SFGeometryType) [parentGeometryTypeNumber intValue];
            [self validateRowIcons:featureTableStyles andFeature:featureRow andGeometryType:parentGeometryType andTableIconDefault:tableIconDefault andTableIcons:geometryTypeTableIcons andFeatureIcons:featureResultsIcons];
        }
        
        NSArray<NSNumber *> *childTypes = [self allChildTypes:geometryType];
        for(NSNumber *childGeometryTypeNumber in childTypes){
            enum SFGeometryType childGeometryType = (enum SFGeometryType) [childGeometryTypeNumber intValue];
            [self validateRowIcons:featureTableStyles andFeature:featureRow andGeometryType:childGeometryType andTableIconDefault:tableIconDefault andTableIcons:geometryTypeTableIcons andFeatureIcons:featureResultsIcons];
        }
    }
    
}

+(void) validateRowIcons: (GPKGFeatureTableStyles *) featureTableStyles andFeature: (GPKGFeatureRow *) featureRow andGeometryType: (enum SFGeometryType) geometryType andTableIconDefault: (GPKGIconRow *) tableIconDefault andTableIcons: (NSDictionary *) geometryTypeTableIcons andFeatureIcons: (NSDictionary *) featureResultsIcons{
    
    GPKGIconRow *iconRow = nil;
    if (geometryType == SF_NONE || geometryType < 0) {
        iconRow = [featureTableStyles iconWithFeature:featureRow];
        geometryType = [featureRow geometryType];
    } else {
        iconRow = [featureTableStyles iconWithFeature:featureRow andGeometryType:geometryType];
    }
    
    GPKGIconRow *expectedIconRow = [self expectedRowIcon:featureRow andGeometryType:geometryType andTableIconDefault:tableIconDefault andTableIcons:geometryTypeTableIcons andFeatureIcons:featureResultsIcons];
    
    if (expectedIconRow != nil) {
        [GPKGTestUtils assertEqualWithValue:[expectedIconRow id] andValue2:[iconRow id]];
        [GPKGTestUtils assertNotNil:[iconRow table]];
        [GPKGTestUtils assertTrue:[iconRow idValue] >= 0];
        [iconRow name];
        [iconRow description];
        [iconRow width];
        [iconRow height];
        [iconRow anchorU];
        [iconRow anchorV];
    } else {
        [GPKGTestUtils assertNil:iconRow];
    }
    
}

+(GPKGIconRow *) expectedRowIcon: (GPKGFeatureRow *) featureRow andGeometryType: (enum SFGeometryType) geometryType andTableIconDefault: (GPKGIconRow *) tableIconDefault andTableIcons: (NSDictionary *) geometryTypeTableIcons andFeatureIcons: (NSDictionary *) featureResultsIcons{
    
    NSMutableArray<NSNumber *> *geometryTypes = [NSMutableArray array];
    if(geometryType != SF_NONE && geometryType >= 0){
        [geometryTypes addObject:[NSNumber numberWithInteger:geometryType]];
        [geometryTypes addObjectsFromArray:[SFGeometryUtils parentHierarchyOfType:geometryType]];
    }
    [geometryTypes addObject:[NSNumber numberWithInt:SF_NONE]];
    
    GPKGIconRow *expectedIconRow = nil;
    NSDictionary *geometryTypeRowIcons = [featureResultsIcons objectForKey:[featureRow id]];
    if(geometryTypeRowIcons != nil){
        for(NSNumber *typeNumber in geometryTypes){
            expectedIconRow = [geometryTypeRowIcons objectForKey:typeNumber];
            if(expectedIconRow != nil){
                break;
            }
        }
    }
    
    if (expectedIconRow == nil) {
        for(NSNumber *typeNumber in geometryTypes){
            expectedIconRow = [geometryTypeTableIcons objectForKey:typeNumber];
            if(expectedIconRow != nil){
                break;
            }
        }
        
        if (expectedIconRow == nil) {
            expectedIconRow = tableIconDefault;
        }
    }
    
    return expectedIconRow;
}

+(GPKGStyleRow *) randomStyle{
    GPKGStyleRow *styleRow = [[GPKGStyleRow alloc] init];
    
    if ([GPKGTestUtils randomDouble] < .5) {
        [styleRow setName:@"Style Name"];
    }
    if ([GPKGTestUtils randomDouble] < .5) {
        [styleRow setDescription:@"Style Description"];
    }
    [styleRow setColor:[self randomColor]];
    if ([GPKGTestUtils randomDouble] < .5) {
        [styleRow setWidthValue:1.0 + [GPKGTestUtils randomDouble] * 3];
    }
    [styleRow setFillColor:[self randomColor]];
    
    return styleRow;
}

+(CLRColor *) randomColor{
    
    CLRColor *color = nil;
    
    if([GPKGTestUtils randomDouble] < .5){
        color = [[CLRColor alloc] initWithRed:[GPKGTestUtils randomIntLessThan:256] andGreen:[GPKGTestUtils randomIntLessThan:256] andBlue:[GPKGTestUtils randomIntLessThan:256]];
        if([GPKGTestUtils randomDouble] < .5){
            [color setOpacity:(float)[GPKGTestUtils randomDouble]];
        }
    }
    
    return color;
}

+(GPKGIconRow *) randomIcon{
    GPKGIconRow *iconRow = [[GPKGIconRow alloc] init];
    
    NSString *iconImagePath = [GPKGBundleHelper pathForResource:GPKG_TEST_ICON_POINT_IMAGE];
    UIImage *iconImage = [UIImage imageWithContentsOfFile:iconImagePath];
    
    [iconRow setDataWithImage:iconImage andFormat:GPKG_CF_PNG];
    [iconRow setContentType:[NSString stringWithFormat:@"image/%@", GPKG_TEST_ICON_POINT_IMAGE_EXTENSION]];
    if ([GPKGTestUtils randomDouble] < .5) {
        [iconRow setName:@"Icon Name"];
    }
    if ([GPKGTestUtils randomDouble] < .5) {
        [iconRow setDescription:@"Icon Description"];
    }
    if ([GPKGTestUtils randomDouble] < .5) {
        [iconRow setWidthValue:[GPKGTestUtils randomDouble] * iconImage.size.width];
    }
    if ([GPKGTestUtils randomDouble] < .5) {
        [iconRow setHeightValue:[GPKGTestUtils randomDouble] * iconImage.size.height];
    }
    if ([GPKGTestUtils randomDouble] < .5) {
        [iconRow setAnchorUValue:[GPKGTestUtils randomDouble]];
    }
    if ([GPKGTestUtils randomDouble] < .5) {
        [iconRow setAnchorVValue:[GPKGTestUtils randomDouble]];
    }
    
    return iconRow;
}

+(NSMutableDictionary<NSNumber *, GPKGStyleRow *> *) randomStylesWithGeometryTypes: (NSDictionary *) geometryTypes{
    return [self randomStylesWithGeometryTypes:geometryTypes andRandomSyles:nil];
}

+(NSMutableDictionary<NSNumber *, GPKGIconRow *> *) randomIconsWithGeometryTypes: (NSDictionary *) geometryTypes{
    return [self randomIconsWithGeometryTypes:geometryTypes andRandomIcons:nil];
}

+(NSMutableDictionary<NSNumber *, GPKGStyleRow *> *) randomStylesWithGeometryTypes: (NSDictionary *) geometryTypes andRandomSyles: (NSArray *) randomStyles{
    NSMutableDictionary<NSNumber *, GPKGStyleRow *>  *rowMap = [NSMutableDictionary dictionary];
    if(geometryTypes != nil){
        for(NSNumber *typeNumber in [geometryTypes allKeys]){
            enum SFGeometryType type = (enum SFGeometryType) [typeNumber intValue];
            if ([GPKGTestUtils randomDouble] < .5) {
                [rowMap setObject:[self randomStyleWithRandomStyles:randomStyles] forKey:[NSNumber numberWithInteger:type]];
            }
            NSMutableDictionary *childGeometryTypes = [geometryTypes objectForKey:typeNumber];
            NSMutableDictionary *childRowMap = [self randomStylesWithGeometryTypes:childGeometryTypes andRandomSyles:randomStyles];
            [rowMap setValuesForKeysWithDictionary:childRowMap];
        }
    }
    return rowMap;
}

+(NSMutableDictionary<NSNumber *, GPKGIconRow *> *) randomIconsWithGeometryTypes: (NSDictionary *) geometryTypes andRandomIcons: (NSArray *) randomIcons{
    NSMutableDictionary<NSNumber *, GPKGIconRow *> *rowMap = [NSMutableDictionary dictionary];
    if(geometryTypes != nil){
        for(NSNumber *typeNumber in [geometryTypes allKeys]){
            enum SFGeometryType type = (enum SFGeometryType) [typeNumber intValue];
            if ([GPKGTestUtils randomDouble] < .5) {
                [rowMap setObject:[self randomIconWithRandomIcons:randomIcons] forKey:[NSNumber numberWithInteger:type]];
            }
            NSMutableDictionary *childGeometryTypes = [geometryTypes objectForKey:typeNumber];
            NSMutableDictionary *childRowMap = [self randomIconsWithGeometryTypes:childGeometryTypes andRandomIcons:randomIcons];
            [rowMap setValuesForKeysWithDictionary:childRowMap];
        }
    }
    return rowMap;
}

+(GPKGStyleRow *) randomStyleWithRandomStyles: (NSArray *) randomStyles{
    GPKGStyleRow *randomStyle = nil;
    if(randomStyles != nil){
        randomStyle = [randomStyles objectAtIndex:[GPKGTestUtils randomIntLessThan:(int)randomStyles.count]];
    }else{
        randomStyle = [self randomStyle];
    }
    
    return randomStyle;
}

+(GPKGIconRow *) randomIconWithRandomIcons: (NSArray *) randomIcons{
    GPKGIconRow *randomIcon = nil;
    if(randomIcons != nil){
        randomIcon = [randomIcons objectAtIndex:[GPKGTestUtils randomIntLessThan:(int)randomIcons.count]];
    }else{
        randomIcon = [self randomIcon];
    }
    
    return randomIcon;
}

+(NSMutableArray<NSNumber *> *) allChildTypes: (enum SFGeometryType) geometryType{
    
    NSMutableArray<NSNumber *> *allChildTypes = [NSMutableArray array];
    
    NSArray<NSNumber *> *childTypes = [SFGeometryUtils childTypesOfType:geometryType];
    [allChildTypes addObjectsFromArray:childTypes];
    
    for(NSNumber *childTypeNumber in childTypes){
        enum SFGeometryType childType = (enum SFGeometryType) [childTypeNumber intValue];
        [allChildTypes addObjectsFromArray:[self allChildTypes:childType]];
    }
    
    return allChildTypes;
}

+(void) testSharedFeatureStylesWithGeoPackage: (GPKGGeoPackage *) geoPackage{
    
    [[GPKGExtensionManager createWithGeoPackage:geoPackage] deleteExtensions];
    
    GPKGFeatureStyleExtension *featureStyleExtension = [[GPKGFeatureStyleExtension alloc] initWithGeoPackage:geoPackage];
    
    [GPKGTestUtils assertFalse:[featureStyleExtension has]];
    
    NSArray<NSString *> *featureTables = [geoPackage featureTables];
    
    if(featureTables.count > 0){
        
        [featureStyleExtension createStyleTable];
        [featureStyleExtension createIconTable];
        
        GPKGStyleDao *styleDao = [featureStyleExtension styleDao];
        GPKGIconDao *iconDao = [featureStyleExtension iconDao];
        
        GPKGStyleRow *tableStyleDefault = [self randomStyle];
        NSDictionary<NSNumber *, NSDictionary *> *geometryTypes = [SFGeometryUtils childHierarchyOfType:SF_GEOMETRY];
        NSDictionary<NSNumber *, GPKGStyleRow *> *geometryTypeTableStyles = [self randomStylesWithGeometryTypes:geometryTypes];
        
        GPKGIconRow *tableIconDefault = [self randomIcon];
        NSMutableDictionary<NSNumber *, GPKGIconRow *> *geometryTypeTableIcons = [self randomIconsWithGeometryTypes:geometryTypes];
        
        NSMutableArray<GPKGStyleRow *> *randomStyles = [NSMutableArray array];
        NSMutableArray<GPKGIconRow *> *randomIcons = [NSMutableArray array];
        for(int i = 0; i < 10; i++){
            GPKGStyleRow *styleRow = [self randomStyle];
            [randomStyles addObject:styleRow];
            GPKGIconRow *iconRow = [self randomIcon];
            [randomIcons addObject:iconRow];
            
            if(i % 2 == 0){
                [styleDao insert:styleRow];
                [iconDao insert:iconRow];
            }
        }
        
        int extraStyles = 2;
        for(int i = 0; i < extraStyles; i++){
            [styleDao insert:[self randomStyle]];
        }
        
        int extraIcons = 3;
        for(int i = 0; i < extraIcons; i++){
            [iconDao insert:[self randomIcon]];
        }
        
        [GPKGTestUtils assertTrue:[geoPackage isTable:GPKG_ST_TABLE_NAME]];
        [GPKGTestUtils assertTrue:[geoPackage isTable:GPKG_IT_TABLE_NAME]];
        [GPKGTestUtils assertFalse:[geoPackage isTable:GPKG_CI_TABLE_NAME]];
        
        for(NSString *tableName in featureTables){
            
            [GPKGTestUtils assertFalse:[featureStyleExtension hasWithTable:tableName]];
            
            GPKGFeatureDao *featureDao = [geoPackage featureDaoWithTableName:tableName];
            
            GPKGFeatureTableStyles *featureTableStyles = [[GPKGFeatureTableStyles alloc] initWithGeoPackage:geoPackage andTable:[featureDao featureTable]];
            [GPKGTestUtils assertFalse:[featureTableStyles has]];
            
            enum SFGeometryType geometryType = [featureDao geometryType];
            
            [GPKGTestUtils assertFalse:[featureTableStyles hasTableStyleRelationship]];
            [GPKGTestUtils assertFalse:[featureTableStyles hasStyleRelationship]];
            [GPKGTestUtils assertFalse:[featureTableStyles hasTableIconRelationship]];
            [GPKGTestUtils assertFalse:[featureTableStyles hasIconRelationship]];
            
            [GPKGTestUtils assertNotNil:[featureTableStyles tableName]];
            [GPKGTestUtils assertEqualWithValue:tableName andValue2:[featureTableStyles tableName]];
            [GPKGTestUtils assertNotNil:[featureTableStyles featureStyleExtension]];
            
            [GPKGTestUtils assertNil:[featureTableStyles tableFeatureStyles]];
            [GPKGTestUtils assertNil:[featureTableStyles tableStyles]];
            [GPKGTestUtils assertNil:[featureTableStyles cachedTableStyles]];
            [GPKGTestUtils assertNil:[featureTableStyles tableStyleDefault]];
            [GPKGTestUtils assertNil:[featureTableStyles tableStyleWithGeometryType:SF_GEOMETRY]];
            [GPKGTestUtils assertNil:[featureTableStyles tableIcons]];
            [GPKGTestUtils assertNil:[featureTableStyles cachedTableIcons]];
            [GPKGTestUtils assertNil:[featureTableStyles tableIconDefault]];
            [GPKGTestUtils assertNil:[featureTableStyles tableIconWithGeometryType:SF_GEOMETRY]];
            
            GPKGResultSet *featureResultSet = [featureDao queryForAll];
            while([featureResultSet moveToNext]){
                GPKGFeatureRow *featureRow = [featureDao row:featureResultSet];
                
                [GPKGTestUtils assertNil:[featureTableStyles featureStylesWithFeature:featureRow]];
                [GPKGTestUtils assertNil:[featureTableStyles featureStylesWithIdNumber:[featureRow id]]];
                
                [GPKGTestUtils assertNil:[featureTableStyles featureStyleWithFeature:featureRow]];
                [GPKGTestUtils assertNil:[featureTableStyles featureStyleDefaultWithFeature:featureRow]];
                [GPKGTestUtils assertNil:[featureTableStyles featureStyleWithIdNumber:[featureRow id] andGeometryType:[featureRow geometryType]]];
                [GPKGTestUtils assertNil:[featureTableStyles featureStyleDefaultWithIdNumber:[featureRow id]]];

                [GPKGTestUtils assertNil:[featureTableStyles stylesWithFeature:featureRow]];
                [GPKGTestUtils assertNil:[featureTableStyles stylesWithIdNumber:[featureRow id]]];
                
                [GPKGTestUtils assertNil:[featureTableStyles styleWithFeature:featureRow]];
                [GPKGTestUtils assertNil:[featureTableStyles styleDefaultWithFeature:featureRow]];
                [GPKGTestUtils assertNil:[featureTableStyles styleWithIdNumber:[featureRow id] andGeometryType:[featureRow geometryType]]];
                [GPKGTestUtils assertNil:[featureTableStyles styleDefaultWithIdNumber:[featureRow id]]];
                
                [GPKGTestUtils assertNil:[featureTableStyles  iconsWithFeature:featureRow]];
                [GPKGTestUtils assertNil:[featureTableStyles iconsWithIdNumber:[featureRow id]]];
                
                [GPKGTestUtils assertNil:[featureTableStyles iconWithFeature:featureRow]];
                [GPKGTestUtils assertNil:[featureTableStyles iconDefaultWithFeature:featureRow]];
                [GPKGTestUtils assertNil:[featureTableStyles iconWithIdNumber:[featureRow id] andGeometryType:[featureRow geometryType]]];
                [GPKGTestUtils assertNil:[featureTableStyles iconDefaultWithIdNumber:[featureRow id]]];
            }
            [featureResultSet close];
            
            // Table Styles
            [GPKGTestUtils assertFalse:[featureTableStyles hasTableStyleRelationship]];
            [GPKGTestUtils assertFalse:[geoPackage isTable:[[featureTableStyles featureStyleExtension] mappingTableNameWithPrefix:GPKG_FSE_TABLE_MAPPING_TABLE_STYLE andTable:tableName]]];
            
            // Add a default table style
            [featureTableStyles setTableStyleDefault:tableStyleDefault];
            
            [GPKGTestUtils assertTrue:[featureStyleExtension has]];
            [GPKGTestUtils assertTrue:[featureStyleExtension hasWithTable:tableName]];
            [GPKGTestUtils assertTrue:[featureTableStyles has]];
            [GPKGTestUtils assertTrue:[featureTableStyles hasTableStyleRelationship]];
            [GPKGTestUtils assertTrue:[geoPackage isTable:GPKG_ST_TABLE_NAME]];
            [GPKGTestUtils assertTrue:[geoPackage isTable:GPKG_CI_TABLE_NAME]];
            [GPKGTestUtils assertTrue:[geoPackage isTable:[[featureTableStyles featureStyleExtension] mappingTableNameWithPrefix:GPKG_FSE_TABLE_MAPPING_TABLE_STYLE andTable:tableName]]];
            
            // Add geometry type table styles
            for(NSNumber *geometryTypeNumber in [geometryTypeTableStyles allKeys]){
                enum SFGeometryType geometryType = (enum SFGeometryType) [geometryTypeNumber intValue];
                GPKGStyleRow *styleRow = [geometryTypeTableStyles objectForKey:geometryTypeNumber];
                [featureTableStyles setTableStyle:styleRow withGeometryType:geometryType];
            }
            
            GPKGFeatureStyles *featureStyles = [featureTableStyles tableFeatureStyles];
            [GPKGTestUtils assertNotNil:featureStyles];
            [GPKGTestUtils assertNotNil:featureStyles.styles];
            [GPKGTestUtils assertNil:featureStyles.icons];
            
            GPKGStyles *tableStyles = [featureTableStyles tableStyles];
            [GPKGTestUtils assertNotNil:tableStyles];
            [GPKGTestUtils assertNotNil:[tableStyles defaultStyle]];
            [GPKGTestUtils assertEqualWithValue:[tableStyleDefault id] andValue2:[[tableStyles defaultStyle] id]];
            [GPKGTestUtils assertEqualWithValue:[tableStyleDefault id] andValue2:[[featureTableStyles tableStyleWithGeometryType:SF_NONE] id]];
            [self validateTableStyles:featureTableStyles andStyle:tableStyleDefault andStyles:geometryTypeTableStyles andTypes:geometryTypes];
            
            // Table Icons
            [GPKGTestUtils assertFalse:[featureTableStyles hasTableIconRelationship]];
            [GPKGTestUtils assertFalse:[geoPackage isTable:[[featureTableStyles featureStyleExtension] mappingTableNameWithPrefix:GPKG_FSE_TABLE_MAPPING_TABLE_ICON andTable:tableName]]];
            
            // Create table icon relationship
            [GPKGTestUtils assertFalse:[featureTableStyles hasTableIconRelationship]];
            [featureTableStyles createTableIconRelationship];
            [GPKGTestUtils assertTrue:[featureTableStyles hasTableIconRelationship]];
            
            GPKGIcons *createTableIcons = [[GPKGIcons alloc] init];
            [createTableIcons setDefaultIcon:tableIconDefault];
            GPKGIconRow *baseGeometryTypeIcon = [geometryTypeTableIcons objectForKey:[NSNumber numberWithInteger:geometryType]];
            if(baseGeometryTypeIcon == nil){
                baseGeometryTypeIcon = [self randomIcon];
                [geometryTypeTableIcons setObject:baseGeometryTypeIcon forKey:[NSNumber numberWithInteger:geometryType]];
            }
            for(NSNumber *geometryTypeNumber in [geometryTypeTableIcons allKeys]){
                [createTableIcons setIcon:[geometryTypeTableIcons objectForKey:geometryTypeNumber] forGeometryType:[geometryTypeNumber intValue]];
            }
            
            // Set the table icons
            [featureTableStyles setTableIcons:createTableIcons];
            
            [GPKGTestUtils assertTrue:[featureTableStyles hasTableIconRelationship]];
            [GPKGTestUtils assertTrue:[geoPackage isTable:GPKG_IT_TABLE_NAME]];
            [GPKGTestUtils assertTrue:[geoPackage isTable:[[featureTableStyles featureStyleExtension] mappingTableNameWithPrefix:GPKG_FSE_TABLE_MAPPING_TABLE_ICON andTable:tableName]]];
            
            featureStyles = [featureTableStyles tableFeatureStyles];
            [GPKGTestUtils assertNotNil:featureStyles];
            [GPKGTestUtils assertNotNil:featureStyles.styles];
            GPKGIcons *tableIcons = featureStyles.icons;
            [GPKGTestUtils assertNotNil:tableIcons];
            
            [GPKGTestUtils assertNotNil:[tableIcons defaultIcon]];
            [GPKGTestUtils assertEqualWithValue:[tableIconDefault id] andValue2:[[tableIcons defaultIcon] id]];
            [GPKGTestUtils assertEqualWithValue:[tableIconDefault id] andValue2:[[featureTableStyles tableIconWithGeometryType:SF_NONE] id]];
            [GPKGTestUtils assertEqualWithValue:[baseGeometryTypeIcon id] andValue2:[[featureTableStyles tableIconWithGeometryType:geometryType] id]];
            [self validateTableIcons:featureTableStyles andIcon:baseGeometryTypeIcon andIcons:geometryTypeTableIcons andTypes:geometryTypes andShared:YES];
            
            [GPKGTestUtils assertFalse:[featureTableStyles hasStyleRelationship]];
            [GPKGTestUtils assertFalse:[geoPackage isTable:[[featureTableStyles featureStyleExtension] mappingTableNameWithPrefix:GPKG_FSE_TABLE_MAPPING_STYLE andTable:tableName]]];
            [GPKGTestUtils assertFalse:[featureTableStyles hasIconRelationship]];
            [GPKGTestUtils assertFalse:[geoPackage isTable:[[featureTableStyles featureStyleExtension] mappingTableNameWithPrefix:GPKG_FSE_TABLE_MAPPING_ICON andTable:tableName]]];
            
            // Create style and icon relationship
            [featureTableStyles createStyleRelationship];
            [GPKGTestUtils assertTrue:[featureTableStyles hasStyleRelationship]];
            [GPKGTestUtils assertTrue:[geoPackage isTable:[[featureTableStyles featureStyleExtension] mappingTableNameWithPrefix:GPKG_FSE_TABLE_MAPPING_STYLE andTable:tableName]]];
            [featureTableStyles createIconRelationship];
            [GPKGTestUtils assertTrue:[featureTableStyles hasIconRelationship]];
            [GPKGTestUtils assertTrue:[geoPackage isTable:[[featureTableStyles featureStyleExtension] mappingTableNameWithPrefix:GPKG_FSE_TABLE_MAPPING_ICON andTable:tableName]]];
            
            NSMutableDictionary<NSNumber *, NSMutableDictionary *> *featureResultsStyles = [NSMutableDictionary dictionary];
            NSMutableDictionary<NSNumber *, NSMutableDictionary *> *featureResultsIcons = [NSMutableDictionary dictionary];
            
            featureResultSet = [featureDao queryForAll];
            while([featureResultSet moveToNext]){
                
                double randomFeatureOption = [GPKGTestUtils randomDouble];
                
                if (randomFeatureOption < .25) {
                    continue;
                }
                
                GPKGFeatureRow *featureRow = [featureDao row:featureResultSet];
                
                if (randomFeatureOption < .75) {
                    
                    // Feature Styles
                    
                    NSMutableDictionary<NSNumber *, GPKGStyleRow *> *featureRowStyles = [NSMutableDictionary dictionary];
                    [featureResultsStyles setObject:featureRowStyles forKey:[featureRow id]];
                    
                    // Add a default style
                    GPKGStyleRow *styleDefault = [self randomStyleWithRandomStyles:randomStyles];
                    [featureTableStyles setStyleDefault:styleDefault withFeature:featureRow];
                    [featureRowStyles setObject:styleDefault forKey:[NSNumber numberWithInt:SF_NONE]];
                    
                    // Add geometry type styles
                    NSMutableDictionary<NSNumber *, GPKGStyleRow *> *geometryTypeStyles = [self randomStylesWithGeometryTypes:geometryTypes andRandomSyles:randomStyles];
                    for(NSNumber *geometryTypeStyleNumber in [geometryTypeStyles allKeys]){
                        enum SFGeometryType geometryTypeStyle = (enum SFGeometryType) [geometryTypeStyleNumber intValue];
                        GPKGStyleRow *style = [geometryTypeStyles objectForKey:geometryTypeStyleNumber];
                        [featureTableStyles setStyle:style withFeature:featureRow andGeometryType:geometryTypeStyle];
                        [featureRowStyles setObject:style forKey:geometryTypeStyleNumber];
                    }
                    
                }
                
                if (randomFeatureOption >= .5) {
                    
                    // Feature Icons
                    
                    NSMutableDictionary<NSNumber *, GPKGIconRow *> *featureRowIcons = [NSMutableDictionary dictionary];
                    [featureResultsIcons setObject:featureRowIcons forKey:[featureRow id]];
                    
                    // Add a default icon
                    GPKGIconRow *iconDefault = [self randomIconWithRandomIcons:randomIcons];
                    [featureTableStyles setIconDefault:iconDefault withFeature:featureRow];
                    [featureRowIcons setObject:iconDefault forKey:[NSNumber numberWithInt:SF_NONE]];
                    
                    // Add geometry type icons
                    NSMutableDictionary<NSNumber *, GPKGIconRow *> *geometryTypeIcons = [self randomIconsWithGeometryTypes:geometryTypes andRandomIcons:randomIcons];
                    for(NSNumber *geometryTypeIconNumber in [geometryTypeIcons allKeys]){
                        enum SFGeometryType geometryTypeIcon = (enum SFGeometryType) [geometryTypeIconNumber intValue];
                        GPKGIconRow *icon = [geometryTypeIcons objectForKey:geometryTypeIconNumber];
                        [featureTableStyles setIcon:icon withFeature:featureRow andGeometryType:geometryTypeIcon];
                        [featureRowIcons setObject:icon forKey:geometryTypeIconNumber];
                    }
                    
                }
                
            }
            [featureResultSet close];
            
            featureResultSet = [featureDao queryForAll];
            while([featureResultSet moveToNext]){
                
                GPKGFeatureRow *featureRow = [featureDao row:featureResultSet];
                
                NSNumber *featureRowId = [featureRow id];
                NSMutableDictionary<NSNumber *, GPKGStyleRow *> *featureRowStyles = [featureResultsStyles objectForKey:featureRowId];
                BOOL hasFeatureRowStyles = featureRowStyles != nil;
                NSMutableDictionary<NSNumber *, GPKGIconRow *> *featureRowIcons = [featureResultsIcons objectForKey:featureRowId];
                BOOL hasFeatureRowIcons = featureRowIcons !=  nil;
                GPKGFeatureStyle *featureStyle = [featureTableStyles featureStyleWithFeature:featureRow];
                [GPKGTestUtils assertNotNil:featureStyle];
                [GPKGTestUtils assertTrue:[featureStyle hasStyle]];
                [GPKGTestUtils assertNotNil:featureStyle.style];
                [GPKGTestUtils assertEqualBoolWithValue:!hasFeatureRowStyles andValue2:featureStyle.style.tableStyle];
                GPKGStyleRow *expectedStyleRow = [self expectedRowStyle:featureRow andGeometryType:[featureRow geometryType] andTableStyleDefault:tableStyleDefault andTableStyles:geometryTypeTableStyles andFeatureStyles:featureResultsStyles];
                [GPKGTestUtils assertEqualWithValue:[expectedStyleRow id] andValue2:[featureStyle.style id]];
                [GPKGTestUtils assertTrue:[featureStyle hasIcon]];
                [GPKGTestUtils assertNotNil:featureStyle.icon];
                [GPKGTestUtils assertEqualBoolWithValue:!hasFeatureRowIcons andValue2:featureStyle.icon.tableIcon];
                GPKGIconRow *expectedIconRow = [self expectedRowIcon:featureRow andGeometryType:[featureRow geometryType] andTableIconDefault:tableIconDefault andTableIcons:geometryTypeTableIcons andFeatureIcons:featureResultsIcons];
                [GPKGTestUtils assertEqualWithValue:[expectedIconRow id] andValue2:[featureStyle.icon id]];
                [GPKGTestUtils assertEqualBoolWithValue:hasFeatureRowIcons || !hasFeatureRowStyles andValue2:[featureStyle useIcon]];
                
                [self validateRowStyles:featureTableStyles andFeature:featureRow andTableStyleDefault:tableStyleDefault andTableStyles:geometryTypeTableStyles andFeatureStyles:featureResultsStyles];
                
                [self validateRowIcons:featureTableStyles andFeature:featureRow andTableIconDefault:tableIconDefault andTableIcons:geometryTypeTableIcons andFeatureIcons:featureResultsIcons];
                
            }
            [featureResultSet close];
            
        }

        [GPKGTestUtils assertTrue:styleDao.count > 0];
        [GPKGTestUtils assertTrue:iconDao.count > 0];
        
        int styleRowsWithNoMappings = 0;
        GPKGResultSet *styleRows = [styleDao query];
        @try {
            while([styleRows moveToNext]){
                GPKGStyleRow *styleRow = [styleDao row:styleRows];
                if(![featureStyleExtension hasMappingToStyleRow:styleRow]){
                    styleRowsWithNoMappings++;
                }
            }
        } @finally {
            [styleRows close];
        }
        [GPKGTestUtils assertTrue:styleRowsWithNoMappings >= extraStyles];
        [GPKGTestUtils assertEqualIntWithValue:styleRowsWithNoMappings andValue2:[featureStyleExtension deleteNotMappedStyleRows]];
        
        int iconRowsWithNoMappings = 0;
        GPKGResultSet *iconRows = [iconDao query];
        @try {
            while([iconRows moveToNext]){
                GPKGIconRow *iconRow = [iconDao row:iconRows];
                if(![featureStyleExtension hasMappingToIconRow:iconRow]){
                    iconRowsWithNoMappings++;
                }
            }
        } @finally {
            [iconRows close];
        }
        [GPKGTestUtils assertTrue:iconRowsWithNoMappings >= extraIcons];
        [GPKGTestUtils assertEqualIntWithValue:iconRowsWithNoMappings andValue2:[featureStyleExtension deleteNotMappedIconRows]];
        
        [GPKGTestUtils assertTrue:[featureStyleExtension deleteStyleRow:tableStyleDefault] >= 1];
        for(GPKGStyleRow *styleRow in [geometryTypeTableStyles allValues]){
            [GPKGTestUtils assertTrue:[featureStyleExtension deleteStyleRow:styleRow] >= 1];
        }
        
        [GPKGTestUtils assertTrue:[featureStyleExtension deleteIconRow:tableIconDefault] >= 1];
        for(GPKGIconRow *iconRow in [geometryTypeTableIcons allValues]){
            [GPKGTestUtils assertTrue:[featureStyleExtension deleteIconRow:iconRow] >= 1];
        }
        
        [GPKGTestUtils assertTrue:[featureStyleExtension deleteStyleRows] >= 1];
        [GPKGTestUtils assertTrue:[featureStyleExtension deleteIconRows] >= 1];
        
        NSArray<NSString *> *tables = [featureStyleExtension tables];
        [GPKGTestUtils assertEqualUnsignedLongWithValue:featureTables.count andValue2:tables.count];
        
        for(NSString *tableName in featureTables){
            
            [GPKGTestUtils assertTrue:[tables containsObject:tableName]];
            
            [GPKGTestUtils assertNil:[featureStyleExtension tableStylesWithTableName:tableName]];
            [GPKGTestUtils assertNil:[featureStyleExtension tableIconsWithTableName:tableName]];
            
            GPKGFeatureDao *featureDao = [geoPackage featureDaoWithTableName:tableName];
            GPKGResultSet *featureResultSet = [featureDao queryForAll];
            while([featureResultSet moveToNext]){
                
                GPKGFeatureRow *featureRow = [featureDao row:featureResultSet];
                
                [GPKGTestUtils assertNil:[featureStyleExtension stylesWithFeature:featureRow]];
                [GPKGTestUtils assertNil:[featureStyleExtension iconsWithFeature:featureRow]];
                
            }
            [featureResultSet close];
            
            [featureStyleExtension deleteRelationshipsWithTable:tableName];
            [GPKGTestUtils assertFalse:[featureStyleExtension hasWithTable:tableName]];
            
        }
        
        [GPKGTestUtils assertFalse:[featureStyleExtension has]];
        
        [GPKGTestUtils assertTrue:[geoPackage isTable:GPKG_ST_TABLE_NAME]];
        [GPKGTestUtils assertTrue:[geoPackage isTable:GPKG_IT_TABLE_NAME]];
        [GPKGTestUtils assertTrue:[geoPackage isTable:GPKG_CI_TABLE_NAME]];
        
        [featureStyleExtension removeExtension];
        
        [GPKGTestUtils assertFalse:[geoPackage isTable:GPKG_ST_TABLE_NAME]];
        [GPKGTestUtils assertFalse:[geoPackage isTable:GPKG_IT_TABLE_NAME]];
        [GPKGTestUtils assertTrue:[geoPackage isTable:GPKG_CI_TABLE_NAME]];
        
        GPKGContentsIdExtension *contentsIdExtension = [featureStyleExtension contentsId];
        [GPKGTestUtils assertEqualIntWithValue:(int)featureTables.count andValue2:[contentsIdExtension count]];
        [GPKGTestUtils assertEqualIntWithValue:(int)featureTables.count andValue2:[contentsIdExtension deleteIds]];
        [contentsIdExtension removeExtension];
        [GPKGTestUtils assertFalse:[geoPackage isTable:GPKG_CI_TABLE_NAME]];
        
    }

}

@end

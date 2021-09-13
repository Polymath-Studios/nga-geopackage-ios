//
//  GPKGTestUtils.m
//  geopackage-ios
//
//  Created by Brian Osborn on 6/12/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "GPKGTestUtils.h"
#import "GPKGUtils.h"
#import "GPKGDateTimeUtils.h"
#import "PROJProjectionConstants.h"
#import "GPKGSchemaExtension.h"

#define ARC4RANDOM_MAX      0x100000000

NSString * const GPKG_GEOPACKAGE_TEST_SAMPLE_RANGE_CONSTRAINT = @"sampleRange";
NSString * const GPKG_GEOPACKAGE_TEST_SAMPLE_ENUM_CONSTRAINT = @"sampleEnum";
NSString * const GPKG_GEOPACKAGE_TEST_SAMPLE_GLOB_CONSTRAINT = @"sampleGlob";
NSString * const GPKG_GEOPACKAGE_TEST_INTEGER_COLUMN = @"test_integer";

@implementation GPKGTestUtils

+(void)assertNil:(id) value{
    if(value != nil){
        [NSException raise:@"Assert Nil" format:@"Value is not nil: %@", value];
    }
}

+(void)assertNotNil:(id) value{
    if(value == nil){
        [NSException raise:@"Assert Not Nil" format:@"Value is nil: %@", value];
    }
}

+(void)assertTrue: (BOOL) value{
    if(!value){
        [NSException raise:@"Assert True" format:@"Value is false"];
    }
}

+(void)assertFalse: (BOOL) value{
    if(value){
        [NSException raise:@"Assert False" format:@"Value is true"];
    }
}

+(void)assertEqualWithValue:(NSObject *) value andValue2: (NSObject *) value2{
    if(value == nil){
        if(value2 != nil){
            [NSException raise:@"Assert Equal" format:@"Value 1: '%@' is not equal to Value 2: '%@'", value, value2];
        }
    } else if(![value isEqual:value2]){
        [NSException raise:@"Assert Equal" format:@"Value 1: '%@' is not equal to Value 2: '%@'", value, value2];
    }
}

+(void)assertEqualDecimalNumberWithValue:(NSDecimalNumber *) value andValue2: (NSDecimalNumber *) value2 andDelta: (double) delta{
    if(value == nil){
        if(value2 != nil){
            [NSException raise:@"Assert Decimal Number Equal" format:@"Value 1: '%@' is not equal to Value 2: '%@'", value, value2];
        }
    } else{
        [self assertEqualDoubleWithValue:[value doubleValue] andValue2:[value2 doubleValue] andDelta:delta];
    }
}

+(void)assertEqualBoolWithValue:(BOOL) value andValue2: (BOOL) value2{
    if(value != value2){
        [NSException raise:@"Assert Equal BOOL" format:@"Value 1: '%d' is not equal to Value 2: '%d'", value, value2];
    }
}

+(void)assertEqualIntWithValue:(int) value andValue2: (int) value2{
    if(value != value2){
        [NSException raise:@"Assert Equal int" format:@"Value 1: '%d' is not equal to Value 2: '%d'", value, value2];
    }
}

+(void)assertEqualUnsignedIntWithValue:(unsigned int) value andValue2: (unsigned int) value2{
    if(value != value2){
        [NSException raise:@"Assert Equal unsigned int" format:@"Value 1: '%d' is not equal to Value 2: '%d'", value, value2];
    }
}

+(void)assertEqualUnsignedLongWithValue:(unsigned long) value andValue2: (unsigned long) value2{
    if(value != value2){
        [NSException raise:@"Assert Equal unsigned long" format:@"Value 1: '%lu' is not equal to Value 2: '%lu'", value, value2];
    }
}

+(void)assertEqualDoubleWithValue:(double) value andValue2: (double) value2{
    if(value != value2){
        [NSException raise:@"Assert Equal double" format:@"Value 1: '%f' is not equal to Value 2: '%f'", value, value2];
    }
}

+(void)assertEqualDoubleWithValue:(double) value andValue2: (double) value2 andDelta: (double) delta{
    if(fabsl(value - value2) > delta){
        [NSException raise:@"Assert Equal double" format:@"Value 1: '%f' is not equal to Value 2: '%f' within delta: '%f'", value, value2, delta];
    }
}

+(BOOL) equalDoubleWithValue:(double) value andValue2: (double) value2 andDelta: (double) delta{
    return fabsl(value - value2) <= delta;
}

+(void)assertEqualDoubleWithValue:(double) value andValue2: (double) value2 andPercentage: (double) percentage{
    if(fabsl(value - value2) > percentage * MAX(fabsl(value), fabsl(value2))){
        [NSException raise:@"Assert Equal double" format:@"Value 1: '%f' is not equal to Value 2: '%f' within percentage: '%f'", value, value2, percentage];
    }
}

+(void)assertEqualDataWithValue:(NSData *) value andValue2: (NSData *) value2{
    if(value == nil){
        if(value2 != nil){
            [NSException raise:@"Assert Data Equal" format:@"Value 1: '%@' is not equal to Value 2: '%@'", value, value2];
        }
    } else if(![value isEqualToData:value2]){
        [NSException raise:@"Assert Data Equal" format:@"Value 1: '%@' is not equal to Value 2: '%@'", value, value2];
    }
}

+(void)fail:(NSString *) message{
    [NSException raise:@"Test Failure" format:@"%@", message];
}

+(void) createConstraints: (GPKGGeoPackage *) geoPackage{
    
    GPKGSchemaExtension *schemaExtension = [[GPKGSchemaExtension alloc] initWithGeoPackage:geoPackage];
    [schemaExtension createDataColumnConstraintsTable];
    
    GPKGDataColumnConstraintsDao * dao = [schemaExtension dataColumnConstraintsDao];
    
    GPKGDataColumnConstraints * sampleRange = [[GPKGDataColumnConstraints alloc] init];
    [sampleRange setConstraintName:GPKG_GEOPACKAGE_TEST_SAMPLE_RANGE_CONSTRAINT];
    [sampleRange setDataColumnConstraintType:GPKG_DCCT_RANGE];
    [sampleRange setMin: [[NSDecimalNumber alloc] initWithDouble:1.0]];
    [sampleRange setMinIsInclusiveValue:YES];
    [sampleRange setMax: [[NSDecimalNumber alloc] initWithDouble:10.0]];
    [sampleRange setMaxIsInclusiveValue:YES];
    [dao create:sampleRange];
    
    GPKGDataColumnConstraints * sampleEnum1 = [[GPKGDataColumnConstraints alloc] init];
    [sampleEnum1 setConstraintName:GPKG_GEOPACKAGE_TEST_SAMPLE_ENUM_CONSTRAINT];
    [sampleEnum1 setDataColumnConstraintType:GPKG_DCCT_ENUM];
    [sampleEnum1 setValue:@"1"];
    [dao create:sampleEnum1];
    
    GPKGDataColumnConstraints * sampleEnum3 = [[GPKGDataColumnConstraints alloc] init];
    [sampleEnum3 setConstraintName:GPKG_GEOPACKAGE_TEST_SAMPLE_ENUM_CONSTRAINT];
    [sampleEnum3 setDataColumnConstraintType:GPKG_DCCT_ENUM];
    [sampleEnum3 setValue:@"3"];
    [dao create:sampleEnum3];
    
    GPKGDataColumnConstraints * sampleEnum5 = [[GPKGDataColumnConstraints alloc] init];
    [sampleEnum5 setConstraintName:GPKG_GEOPACKAGE_TEST_SAMPLE_ENUM_CONSTRAINT];
    [sampleEnum5 setDataColumnConstraintType:GPKG_DCCT_ENUM];
    [sampleEnum5 setValue:@"5"];
    [dao create:sampleEnum5];
    
    GPKGDataColumnConstraints * sampleEnum7 = [[GPKGDataColumnConstraints alloc] init];
    [sampleEnum7 setConstraintName:GPKG_GEOPACKAGE_TEST_SAMPLE_ENUM_CONSTRAINT];
    [sampleEnum7 setDataColumnConstraintType:GPKG_DCCT_ENUM];
    [sampleEnum7 setValue:@"7"];
    [dao create:sampleEnum7];
    
    GPKGDataColumnConstraints * sampleEnum9 = [[GPKGDataColumnConstraints alloc] init];
    [sampleEnum9 setConstraintName:GPKG_GEOPACKAGE_TEST_SAMPLE_ENUM_CONSTRAINT];
    [sampleEnum9 setDataColumnConstraintType:GPKG_DCCT_ENUM];
    [sampleEnum9 setValue:@"9"];
    [dao create:sampleEnum9];
    
    GPKGDataColumnConstraints * sampleGlob = [[GPKGDataColumnConstraints alloc] init];
    [sampleGlob setConstraintName:GPKG_GEOPACKAGE_TEST_SAMPLE_GLOB_CONSTRAINT];
    [sampleGlob setDataColumnConstraintType:GPKG_DCCT_GLOB];
    [sampleGlob setValue:@"[1-2][0-9][0-9][0-9]"];
    [dao create:sampleGlob];
}

+(GPKGFeatureTable *) createFeatureTableWithGeoPackage: (GPKGGeoPackage *) geoPackage andContents: (GPKGContents *) contents andGeometryColumn: (NSString *) geometryColumn andGeometryType: (enum SFGeometryType) geometryType{
    
    GPKGFeatureTable * table = [self buildFeatureTableWithTableName:contents.tableName andGeometryColumn:geometryColumn andGeometryType:geometryType];
    [geoPackage createFeatureTable:table];
    
    srandom((unsigned int)time(NULL));
    int random = [self randomIntLessThan:3];
    
    GPKGDataColumnsDao * dataColumnsDao = [GPKGSchemaExtension dataColumnsDaoWithGeoPackage:geoPackage];
    GPKGDataColumns * dataColumns = [[GPKGDataColumns alloc] init];
    [dataColumns setContents:contents];
    [dataColumns setColumnName:GPKG_GEOPACKAGE_TEST_INTEGER_COLUMN];
    [dataColumns setName:contents.tableName];
    [dataColumns setTitle:@"TEST_TITLE"];
    [dataColumns setTheDescription:@"TEST_DESCRIPTION"];
    [dataColumns setMimeType:@"TEST_MIME_TYPE"];
    
    switch( random){
        case 0:
            [dataColumns setConstraintName:GPKG_GEOPACKAGE_TEST_SAMPLE_RANGE_CONSTRAINT];
            break;
        case 1:
            [dataColumns setConstraintName:GPKG_GEOPACKAGE_TEST_SAMPLE_ENUM_CONSTRAINT];
            break;
        default:
            [dataColumns setConstraintName:GPKG_GEOPACKAGE_TEST_SAMPLE_GLOB_CONSTRAINT];
    }

    [dataColumnsDao create:dataColumns];
    
    return table;
}

+(GPKGFeatureTable *) buildFeatureTableWithTableName: (NSString *) tableName andGeometryColumn: (NSString *) geometryColumn andGeometryType: (enum SFGeometryType) geometryType{
    
    NSMutableArray * columns = [NSMutableArray array];
    
    [GPKGUtils addObject:[GPKGFeatureColumn createPrimaryKeyColumnWithIndex:0 andName:@"id"] toArray:columns];
    [GPKGUtils addObject:[GPKGFeatureColumn createColumnWithIndex:7 andName:@"test_text_limited" andDataType:GPKG_DT_TEXT andMax: [NSNumber numberWithInt:5]] toArray:columns];
    [GPKGUtils addObject:[GPKGFeatureColumn createColumnWithIndex:8 andName:@"test_blob_limited" andDataType:GPKG_DT_BLOB andMax: [NSNumber numberWithInt:7]] toArray:columns];
    [GPKGUtils addObject:[GPKGFeatureColumn createColumnWithIndex:9 andName:@"test_date" andDataType:GPKG_DT_DATE] toArray:columns];
    [GPKGUtils addObject:[GPKGFeatureColumn createColumnWithIndex:10 andName:@"test_datetime" andDataType:GPKG_DT_DATETIME] toArray:columns];
    [GPKGUtils addObject:[GPKGFeatureColumn createGeometryColumnWithIndex:1 andName:geometryColumn andGeometryType:geometryType] toArray:columns];
    [GPKGUtils addObject:[GPKGFeatureColumn createColumnWithIndex:2 andName:@"test_text" andDataType:GPKG_DT_TEXT andNotNull:NO andDefaultValue:@""] toArray:columns];
    [GPKGUtils addObject:[GPKGFeatureColumn createColumnWithIndex:3 andName:@"test_real" andDataType:GPKG_DT_REAL] toArray:columns];
    [GPKGUtils addObject:[GPKGFeatureColumn createColumnWithIndex:4 andName:@"test_boolean" andDataType:GPKG_DT_BOOLEAN] toArray:columns];
    [GPKGUtils addObject:[GPKGFeatureColumn createColumnWithIndex:5 andName:@"test_blob" andDataType:GPKG_DT_BLOB] toArray:columns];
    [GPKGUtils addObject:[GPKGFeatureColumn createColumnWithIndex:6 andName:GPKG_GEOPACKAGE_TEST_INTEGER_COLUMN andDataType:GPKG_DT_INTEGER] toArray:columns];
    
    GPKGFeatureTable * table = [[GPKGFeatureTable alloc] initWithTable:tableName andGeometryColumn:geometryColumn andColumns:columns];
    
    return table;
}

+(GPKGTileTable *) buildTileTableWithTableName: (NSString *) tableName{
    
    NSArray * columns = [GPKGTileTable createRequiredColumns];
    
    GPKGTileTable * table = [[GPKGTileTable alloc] initWithTable:tableName andColumns:columns];
    
    return table;
}

+(void) addRowsToFeatureTableWithGeoPackage: (GPKGGeoPackage *) geoPackage andGeometryColumns: (GPKGGeometryColumns *) geometryColumns andFeatureTable: (GPKGFeatureTable *) table andNumRows: (int) numRows andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM andAllowEmptyFeatures: (BOOL) allowEmptyFeatures{
    
    GPKGFeatureDao * dao = [geoPackage featureDaoWithGeometryColumns:geometryColumns];
    
    srandom((unsigned int)time(NULL));
    
    for(int i = 0; i < numRows; i++){
        
        GPKGFeatureRow * newRow = [dao newRow];
        
        for(GPKGFeatureColumn * column in table.columns){
            if(!column.primaryKey){
                
                // Leave nullable columns null 20% of the time
                if(!column.notNull){
                    if(allowEmptyFeatures && [self randomIntLessThan:5] == 0){
                        continue;
                    }
                }
                
                if([column isGeometry]){
                    
                    SFGeometry * geometry = nil;
                    
                    switch(column.geometryType){
                            
                        case SF_POINT:
                            geometry = [self createPointWithHasZ:hasZ andHasM:hasM];
                            break;
                        case SF_LINESTRING:
                            geometry = [self createLineStringWithHasZ:hasZ andHasM:hasM andRing:NO];
                            break;
                        case SF_POLYGON:
                            geometry = [self createPolygonWithHasZ:hasZ andHasM:hasM];
                            break;
                        default:
                            [NSException raise:@"Not implemented" format:@"Not implemented for geometry type: %u", column.geometryType];
                    }
                    
                    GPKGGeometryData *geometryData = [GPKGGeometryData createWithSrsId:geometryColumns.srsId andGeometry:geometry];
                    
                    [newRow setGeometry:geometryData];
                }else{
                    
                    NSObject * value = nil;
                    
                    switch(column.dataType){
                            
                        case GPKG_DT_TEXT:
                            {
                                NSString * text = [[NSProcessInfo processInfo] globallyUniqueString];
                                if(column.max != nil && [text length] > [column.max intValue]){
                                    text = [text substringToIndex:[column.max intValue]];
                                }
                                value = text;
                            }
                            break;
                        case GPKG_DT_REAL:
                        case GPKG_DT_DOUBLE:
                            value = [[NSDecimalNumber alloc] initWithDouble:[GPKGTestUtils randomDoubleLessThan:5000.0]];
                            break;
                        case GPKG_DT_BOOLEAN:
                            value = [NSNumber numberWithBool:([self randomDouble] < .5 ? NO : YES)];
                            break;
                        case GPKG_DT_INTEGER:
                        case GPKG_DT_INT:
                            value = [NSNumber numberWithInt:[self randomIntLessThan:500]];
                            break;
                        case GPKG_DT_BLOB:
                            {
                                NSData * blob = [[[NSProcessInfo processInfo] globallyUniqueString] dataUsingEncoding:NSUTF8StringEncoding];
                                if(column.max != nil && [blob length] > [column.max intValue]){
                                    blob = [blob subdataWithRange:NSMakeRange(0, [column.max intValue])];
                                }
                                value = blob;
                            }
                            break;
                        case GPKG_DT_DATE:
                        case GPKG_DT_DATETIME:
                            {
                                NSDate *date = [NSDate date];
                                if([GPKGTestUtils randomDouble] < .5){
                                    if(column.dataType == GPKG_DT_DATE){
                                        value = [GPKGDateTimeUtils convertToDateWithString:[GPKGDateTimeUtils convertToStringWithDate:date andType:column.dataType]];
                                    }else{
                                        value = date;
                                    }
                                }else{
                                    value = [GPKGDateTimeUtils convertToStringWithDate:date andType:column.dataType];
                                }
                            }
                            break;
                        default:
                            [NSException raise:@"Not implemented" format:@"Not implemented for data type: %u", column.dataType];
                            
                    }
                    
                    [newRow setValueWithColumnName:column.name andValue:value];
                }
            }
        }
        [dao create:newRow];
    }
    
}

+(void) addRowsToTileTableWithGeoPackage: (GPKGGeoPackage *) geoPackage andTileMatrix: (GPKGTileMatrix *) tileMatrix andData: (NSData *) tileData{
    
    GPKGTileDao * dao = [geoPackage tileDaoWithTableName:tileMatrix.tableName];
    
    for(int column = 0; column < [tileMatrix.matrixWidth intValue]; column++){
        
        for(int row = 0; row < [tileMatrix.matrixHeight intValue]; row++){
            
            GPKGTileRow * newRow = [dao newRow];
            
            [newRow setZoomLevel:[tileMatrix.zoomLevel intValue]];
            [newRow setTileColumn:column];
            [newRow setTileRow:row];
            [newRow setTileData:tileData];
            
            [dao create:newRow];
        }
    }
}

+(SFPoint *) createPointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    double x = [self randomDoubleLessThan:180.0] * ([self randomDouble] < .5 ? 1 : -1);
    double y = [self randomDoubleLessThan:PROJ_WEB_MERCATOR_MIN_LAT_RANGE] * ([self randomDouble] < .5 ? 1 : -1);
    
    SFPoint * point = [[SFPoint alloc] initWithHasZ:hasZ andHasM:hasM andXValue:x andYValue:y];
    
    if(hasZ){
        double z = [self randomDoubleLessThan:1000.0];
        [point setZValue:z];
    }
    
    if(hasM){
        double m = [self randomDoubleLessThan:1000.0];
        [point setMValue:m];
    }
       
    return point;
}

+(SFLineString *) createLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM andRing: (BOOL) ring{
    
    SFLineString * lineString = [[SFLineString alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numPoints = 2 + [self randomIntLessThan:9];
    
    for(int i = 0; i < numPoints; i++){
        [lineString addPoint:[self createPointWithHasZ:hasZ andHasM:hasM]];
    }
    
    if(ring){
        [lineString addPoint:[lineString.points objectAtIndex:0]];
    }
    
    return lineString;
}

+(SFPolygon *) createPolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFPolygon * polygon = [[SFPolygon alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numLineStrings = 1 + [self randomIntLessThan:5];
    
    for(int i = 0; i < numLineStrings; i++){
        [polygon addRing:[self createLineStringWithHasZ:hasZ andHasM:hasM andRing:YES]];
    }
    
    return polygon;
}

+(NSDecimalNumber *) roundDouble: (double) value{
    return [self roundDouble:value withScale:1];
}

+(NSDecimalNumber *) roundDouble: (double) value withScale: (int) scale{
    NSDecimalNumberHandler *rounder = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    return [[[NSDecimalNumber alloc] initWithDouble:value] decimalNumberByRoundingAccordingToBehavior:rounder];
}

+(int) randomIntLessThan: (int) max{
    return arc4random() % max;
}

+(double) randomDouble{
    return ((double)arc4random() / ARC4RANDOM_MAX);
}

+(double) randomDoubleLessThan: (double) max{
    return [self randomDouble] * max;
}

+(void) validateGeoPackage: (GPKGGeoPackage *) geoPackage{
    [self assertNil:[geoPackage foreignKeyCheck]];
    [self assertNil:[geoPackage integrityCheck]];
    [self assertNil:[geoPackage quickCheck]];
}

+(void) validateIntegerValue: (NSObject *) value andDataType: (enum GPKGDataType) dataType{
    
    if((int)dataType != -1){
    
        switch(dataType){
            case GPKG_DT_BOOLEAN:
            case GPKG_DT_TINYINT:
            case GPKG_DT_SMALLINT:
            case GPKG_DT_MEDIUMINT:
            case GPKG_DT_INT:
            case GPKG_DT_INTEGER:
                [GPKGTestUtils assertTrue:[value isKindOfClass:[NSNumber class]]];
                break;
            default:
                [NSException raise:@"Integer Data Type" format:@"Data Type %u is not an integer type", dataType];
        }
        
    }
}

+(void) validateFloatValue: (NSObject *) value andDataType: (enum GPKGDataType) dataType{
    
    if((int)dataType != -1){
    
        switch(dataType){
            case GPKG_DT_FLOAT:
            case GPKG_DT_DOUBLE:
            case GPKG_DT_REAL:
                {
                    [GPKGTestUtils assertTrue:[value isKindOfClass:[NSNumber class]]];
                    NSDecimalNumber * decimalNumber = ((NSDecimalNumber *)value);
                    [GPKGTestUtils assertNotNil:decimalNumber];
                }
                break;
            default:
                [NSException raise:@"Float Data Type" format:@"Data Type %u is not a float type", dataType];
        }
        
    }
}

@end

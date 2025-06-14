//
//  GPKGMetadataReferenceDao.m
//  geopackage-ios
//
//  Created by Brian Osborn on 5/19/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGMetadataReferenceDao.h>
#import <GeoPackage/GPKGDateConverter.h>

@implementation GPKGMetadataReferenceDao

+(GPKGMetadataReferenceDao *) createWithDatabase: (GPKGConnection *) database{
    return [[GPKGMetadataReferenceDao alloc] initWithDatabase:database];
}

-(instancetype) initWithDatabase: (GPKGConnection *) database{
    self = [super initWithDatabase:database];
    if(self != nil){
        self.tableName = GPKG_MR_TABLE_NAME;
        self.idColumns = @[GPKG_MR_COLUMN_FILE_ID, GPKG_MR_COLUMN_PARENT_ID];
        self.columnNames = @[GPKG_MR_COLUMN_REFERENCE_SCOPE, GPKG_MR_COLUMN_TABLE_NAME, GPKG_MR_COLUMN_COLUMN_NAME, GPKG_MR_COLUMN_ROW_ID_VALUE, GPKG_MR_COLUMN_TIMESTAMP, GPKG_MR_COLUMN_FILE_ID, GPKG_MR_COLUMN_PARENT_ID];
        [self initializeColumnIndex];
    }
    return self;
}

-(NSObject *) createObject{
    return [[GPKGMetadataReference alloc] init];
}

-(void) setValueInObject: (NSObject*) object withColumnIndex: (int) columnIndex withValue: (NSObject *) value{
    
    GPKGMetadataReference *setObject = (GPKGMetadataReference*) object;
    
    switch(columnIndex){
        case 0:
            setObject.referenceScope = (NSString *) value;
            break;
        case 1:
            setObject.tableName = (NSString *) value;
            break;
        case 2:
            setObject.columnName = (NSString *) value;
            break;
        case 3:
            setObject.rowIdValue = (NSNumber *) value;
            break;
        case 4:
            setObject.timestamp = [GPKGDateConverter convertToDateWithString:((NSString *) value)];
            break;
        case 5:
            setObject.fileId = (NSNumber *) value;
            break;
        case 6:
            setObject.parentId = (NSNumber *) value;
            break;
        default:
            [NSException raise:@"Illegal Column Index" format:@"Unsupported column index: %d", columnIndex];
            break;
    }
    
}

-(NSObject *) valueFromObject: (NSObject*) object withColumnIndex: (int) columnIndex{
    
    NSObject *value = nil;
    
    GPKGMetadataReference *reference = (GPKGMetadataReference*) object;
    
    switch(columnIndex){
        case 0:
            value = reference.referenceScope;
            break;
        case 1:
            value = reference.tableName;
            break;
        case 2:
            value = reference.columnName;
            break;
        case 3:
            value = reference.rowIdValue;
            break;
        case 4:
            value = reference.timestamp;
            break;
        case 5:
            value = reference.fileId;
            break;
        case 6:
            value = reference.parentId;
            break;
        default:
            [NSException raise:@"Illegal Column Index" format:@"Unsupported column index: %d", columnIndex];
            break;
    }
    
    return value;
}

-(int) deleteByMetadata: (NSNumber *) fileId{
    NSString *where = [self buildWhereWithField:GPKG_MR_COLUMN_FILE_ID andValue:fileId];
    NSArray *whereArgs = [self buildWhereArgsWithValue:fileId];
    int count = [self deleteWhere:where andWhereArgs:whereArgs];
    return count;
}

-(int) removeMetadataParent: (NSNumber *) parentId{
    
    GPKGContentValues *values = [[GPKGContentValues alloc] init];
    [values putKey:GPKG_MR_COLUMN_PARENT_ID withValue:nil];

    NSString *where = [self buildWhereWithField:GPKG_MR_COLUMN_PARENT_ID andValue:parentId];
    NSArray *whereArgs = [self buildWhereArgsWithValue:parentId];
    
    int count = [self updateWithValues:values andWhere:where andWhereArgs:whereArgs];
    return count;
}

-(GPKGResultSet *) queryByMetadata: (NSNumber *) fileId andParent: (NSNumber *) parentId{
    
    GPKGColumnValues *values = [[GPKGColumnValues alloc] init];
    [values addColumn:GPKG_MR_COLUMN_FILE_ID withValue:fileId];
    [values addColumn:GPKG_MR_COLUMN_PARENT_ID withValue:parentId];
    
    return [self queryForFieldValues:values];
}

-(GPKGResultSet *) queryByMetadata: (NSNumber *) fileId{
    return [self queryForEqWithField:GPKG_MR_COLUMN_FILE_ID andValue:fileId];
}

-(GPKGResultSet *) queryByMetadataParent: (NSNumber *) parentId{
    return [self queryForEqWithField:GPKG_MR_COLUMN_PARENT_ID andValue:parentId];
}

-(GPKGResultSet *) queryByTable: (NSString *) tableName{
    return [self queryForEqWithField:GPKG_MR_COLUMN_TABLE_NAME andValue:tableName];
}

-(int) deleteByTableName: (NSString *) tableName{
    NSString *where = [self buildWhereWithField:GPKG_MR_COLUMN_TABLE_NAME andValue:tableName];
    NSArray *whereArgs = [self buildWhereArgsWithValue:tableName];
    return [self deleteWhere:where andWhereArgs:whereArgs];
}

@end

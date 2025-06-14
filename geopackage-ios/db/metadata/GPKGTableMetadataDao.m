//
//  GPKGTableMetadataDao.m
//  geopackage-ios
//
//  Created by Brian Osborn on 6/24/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGTableMetadataDao.h>
#import <GeoPackage/GPKGGeometryMetadataDao.h>
#import <GeoPackage/GPKGGeoPackageMetadataDao.h>
#import <GeoPackage/GPKGDateConverter.h>

@implementation GPKGTableMetadataDao

-(instancetype) initWithDatabase: (GPKGConnection *) database{
    self = [super initWithDatabase:database];
    if(self != nil){
        self.tableName = GPKG_GPTM_TABLE_NAME;
        self.idColumns = @[GPKG_GPTM_COLUMN_PK1, GPKG_GPTM_COLUMN_PK2];
        self.columnNames = @[GPKG_GPTM_COLUMN_GEOPACKAGE_ID, GPKG_GPTM_COLUMN_TABLE_NAME, GPKG_GPTM_COLUMN_LAST_INDEXED];
        [self initializeColumnIndex];
    }
    return self;
}

-(NSObject *) createObject{
    return [[GPKGTableMetadata alloc] init];
}

-(void) setValueInObject: (NSObject*) object withColumnIndex: (int) columnIndex withValue: (NSObject *) value{
    
    GPKGTableMetadata *setObject = (GPKGTableMetadata*) object;
    
    switch(columnIndex){
        case 0:
            setObject.geoPackageId = (NSNumber *) value;
            break;
        case 1:
            setObject.tableName = (NSString *) value;
            break;
        case 2:
            setObject.lastIndexed = [GPKGDateConverter convertToDateWithString:((NSString *) value)];
            break;
        default:
            [NSException raise:@"Illegal Column Index" format:@"Unsupported column index: %d", columnIndex];
            break;
    }
    
}

-(NSObject *) valueFromObject: (NSObject*) object withColumnIndex: (int) columnIndex{
    
    NSObject *value = nil;
    
    GPKGTableMetadata *metadata = (GPKGTableMetadata*) object;
    
    switch(columnIndex){
        case 0:
            value = metadata.geoPackageId;
            break;
        case 1:
            value = metadata.tableName;
            break;
        case 2:
            value = metadata.lastIndexed;
            break;
        default:
            [NSException raise:@"Illegal Column Index" format:@"Unsupported column index: %d", columnIndex];
            break;
    }
    
    return value;
}

-(BOOL) deleteMetadata: (GPKGTableMetadata *) metadata{
    return [self deleteByGeoPackageId:metadata.geoPackageId andTableName:metadata.tableName];
}

-(BOOL) deleteByGeoPackageName: (NSString *) name{
    return [self deleteByGeoPackageId:[self geoPackageIdForGeoPackageName:name]];
}

-(BOOL) deleteByGeoPackageId: (NSNumber *) geoPackageId{
    
    GPKGGeometryMetadataDao *geomDao = [[GPKGGeometryMetadataDao alloc] initWithDatabase:self.database];
    [geomDao deleteByGeoPackageId:geoPackageId];
    
    NSString *where = [self buildWhereWithField:GPKG_GPTM_COLUMN_GEOPACKAGE_ID andValue:geoPackageId];
    NSArray *whereArgs = [self buildWhereArgsWithValue:geoPackageId];
    
    int count = [self deleteWhere:where andWhereArgs:whereArgs];
    return count > 0;
}

-(BOOL) deleteByGeoPackageName: (NSString *) name andTableName: (NSString *) tableName{
    return [self deleteByGeoPackageId:[self geoPackageIdForGeoPackageName:name] andTableName:tableName];
}

-(BOOL) deleteByGeoPackageId: (NSNumber *) geoPackageId andTableName: (NSString *) tableName{
    
    GPKGGeometryMetadataDao *geomDao = [[GPKGGeometryMetadataDao alloc] initWithDatabase:self.database];
    [geomDao deleteByGeoPackageId:geoPackageId andTableName:tableName];
    
    GPKGColumnValues *values = [[GPKGColumnValues alloc] init];
    [values addColumn:GPKG_GPTM_COLUMN_GEOPACKAGE_ID withValue:geoPackageId];
    [values addColumn:GPKG_GPTM_COLUMN_TABLE_NAME withValue:tableName];
    
    NSString *where = [self buildWhereWithFields:values];
    NSArray *whereArgs = [self buildWhereArgsWithValues:values];
    
    int count = [self deleteWhere:where andWhereArgs:whereArgs];
    return count > 0;
}

-(BOOL) updateLastIndexed: (NSDate *) lastIndexed inMetadata: (GPKGTableMetadata *) metadata{
    BOOL updated = [self updateLastIndexed:lastIndexed withGeoPackageId:metadata.geoPackageId andTableName:metadata.tableName];
    if(updated){
        [metadata setLastIndexed:lastIndexed];
    }
    return updated;
}

-(BOOL) updateLastIndexed: (NSDate *) lastIndexed withGeoPackageName: (NSString *) name andTableName: (NSString *) tableName{
    return [self updateLastIndexed:lastIndexed withGeoPackageId:[self geoPackageIdForGeoPackageName:name] andTableName:tableName];
}

-(BOOL) updateLastIndexed: (NSDate *) lastIndexed withGeoPackageId: (NSNumber *) geoPackageId andTableName: (NSString *) tableName{
    
    GPKGContentValues *values = [[GPKGContentValues alloc] init];
    [values putKey:GPKG_GPTM_COLUMN_LAST_INDEXED withValue:lastIndexed];
    
    GPKGColumnValues *whereValues = [[GPKGColumnValues alloc] init];
    [whereValues addColumn:GPKG_GPTM_COLUMN_GEOPACKAGE_ID withValue:geoPackageId];
    [whereValues addColumn:GPKG_GPTM_COLUMN_TABLE_NAME withValue:tableName];
    
    NSString *where = [self buildWhereWithFields:whereValues];
    NSArray *whereArgs = [self buildWhereArgsWithValues:whereValues];
    
    int count = [self updateWithValues:values andWhere:where andWhereArgs:whereArgs];
    return count > 0;
}

-(GPKGTableMetadata *) metadataByGeoPackageName: (NSString *) name andTableName: (NSString *) tableName{
    return [self metadataByGeoPackageId:[self geoPackageIdForGeoPackageName:name] andTableName:tableName];
}

-(GPKGTableMetadata *) metadataByGeoPackageId: (NSNumber *) geoPackageId andTableName: (NSString *) tableName{
    
    GPKGTableMetadata *metadata = nil;
    
    GPKGColumnValues *values = [[GPKGColumnValues alloc] init];
    [values addColumn:GPKG_GPTM_COLUMN_GEOPACKAGE_ID withValue:geoPackageId];
    [values addColumn:GPKG_GPTM_COLUMN_TABLE_NAME withValue:tableName];
    
    GPKGResultSet *results = [self queryForFieldValues:values];
    @try{
        if([results moveToNext]){
            metadata = (GPKGTableMetadata *) [self object:results];
        }
    }@finally{
        [results close];
    }
    
    return metadata;
}

-(GPKGTableMetadata *) metadataCreateByGeoPackageName: (NSString *) name andTableName: (NSString *) tableName{
    
    GPKGGeoPackageMetadataDao *ds = [[GPKGGeoPackageMetadataDao alloc] initWithDatabase:self.database];
    GPKGGeoPackageMetadata *geoPackageMetadata = [ds metadataCreateByName:name];
    
    GPKGTableMetadata *metadata = [self metadataByGeoPackageId:geoPackageMetadata.id andTableName:tableName];
    
    if(metadata == nil){
        metadata = [[GPKGTableMetadata alloc] init];
        [metadata setGeoPackageId:geoPackageMetadata.id];
        [metadata setTableName:tableName];
        [self create:metadata];
    }
    return metadata;
}

-(NSNumber *) geoPackageIdForGeoPackageName: (NSString *) name{
    NSNumber *id  = [NSNumber numberWithInt:-1];
    GPKGGeoPackageMetadataDao *ds = [[GPKGGeoPackageMetadataDao alloc] initWithDatabase:self.database];
    GPKGGeoPackageMetadata *metadata = [ds metadataCreateByName:name];
    if(metadata != nil){
        id = metadata.id;
    }
    return id;
}

@end

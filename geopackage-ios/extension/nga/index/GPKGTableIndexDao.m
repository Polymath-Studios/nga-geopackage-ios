//
//  GPKGTableIndexDao.m
//  geopackage-ios
//
//  Created by Brian Osborn on 10/12/15.
//  Copyright © 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGTableIndexDao.h>
#import <GeoPackage/GPKGGeometryIndexDao.h>
#import <GeoPackage/GPKGDateConverter.h>

@implementation GPKGTableIndexDao

+(GPKGTableIndexDao *) createWithDatabase: (GPKGConnection *) database{
    return [[GPKGTableIndexDao alloc] initWithDatabase:database];
}

-(instancetype) initWithDatabase: (GPKGConnection *) database{
    self = [super initWithDatabase:database];
    if(self != nil){
        self.tableName = GPKG_TI_TABLE_NAME;
        self.idColumns = @[GPKG_TI_COLUMN_PK];
        self.columnNames = @[GPKG_TI_COLUMN_TABLE_NAME, GPKG_TI_COLUMN_LAST_INDEXED];
        [self initializeColumnIndex];
    }
    return self;
}

-(NSObject *) createObject{
    return [[GPKGTableIndex alloc] init];
}

-(void) setValueInObject: (NSObject*) object withColumnIndex: (int) columnIndex withValue: (NSObject *) value{
    
    GPKGTableIndex *setObject = (GPKGTableIndex*) object;
    
    switch(columnIndex){
        case 0:
            setObject.tableName = (NSString *) value;
            break;
        case 1:
            setObject.lastIndexed = [GPKGDateConverter convertToDateWithString:((NSString *) value)];
            break;
        default:
            [NSException raise:@"Illegal Column Index" format:@"Unsupported column index: %d", columnIndex];
            break;
    }
    
}

-(NSObject *) valueFromObject: (NSObject*) object withColumnIndex: (int) columnIndex{
    
    NSObject *value = nil;
    
    GPKGTableIndex *index = (GPKGTableIndex*) object;
    
    switch(columnIndex){
        case 0:
            value = index.tableName;
            break;
        case 1:
            value = index.lastIndexed;
            break;
        default:
            [NSException raise:@"Illegal Column Index" format:@"Unsupported column index: %d", columnIndex];
            break;
    }
    
    return value;
}

-(int) deleteCascade: (GPKGTableIndex *) tableIndex{
    
    int count = 0;
    
    if(tableIndex != nil){
        
        // Delete Geometry Indices
        GPKGGeometryIndexDao *geometryIndexDao = [self geometryIndexDao];
        if([geometryIndexDao tableExists]){
            GPKGResultSet *geometryIndexResults = [self geometryIndices:tableIndex];
            while([geometryIndexResults moveToNext]){
                GPKGGeometryIndex *geometryIndex = (GPKGGeometryIndex *)[geometryIndexDao object:geometryIndexResults];
                [geometryIndexDao delete:geometryIndex];
            }
            [geometryIndexResults close];
        }
        
        // Delete
        count = [self delete:tableIndex];
    }
    
    return count;
}

-(int) deleteCascadeWithCollection: (NSArray *) tableIndexCollection{
    int count = 0;
    if(tableIndexCollection != nil){
        for(GPKGTableIndex *tableIndex in tableIndexCollection){
            count += [self deleteCascade:tableIndex];
        }
    }
    return count;
}

-(int) deleteCascadeWhere: (NSString *) where andWhereArgs: (NSArray *) whereArgs{
    int count = 0;
    if(where != nil){
        NSMutableArray *tableIndexArray = [NSMutableArray array];
        GPKGResultSet *results = [self queryWhere:where andWhereArgs:whereArgs];
        while([results moveToNext]){
            GPKGTableIndex *tableIndex = (GPKGTableIndex *)[self object:results];
            [tableIndexArray addObject:tableIndex];
        }
        [results close];
        for(GPKGTableIndex *tableIndex in tableIndexArray){
            count += [self deleteCascade:tableIndex];
        }
    }
    return count;
}

-(int) deleteByIdCascade: (NSString *) id{
    int count = 0;
    if(id != nil){
        GPKGTableIndex *tableIndex = (GPKGTableIndex *) [self queryForIdObject:id];
        if(tableIndex != nil){
            count = [self deleteCascade:tableIndex];
        }
    }
    return count;
}

-(int) deleteIdsCascade: (NSArray *) idCollection{
    int count = 0;
    if(idCollection != nil){
        for(NSString *id in idCollection){
            count += [self deleteByIdCascade:id];
        }
    }
    return count;
}

-(void) deleteTable: (NSString *) table{
    [self deleteByIdCascade:table];
}

-(GPKGResultSet *) geometryIndices: (GPKGTableIndex *) tableIndex{
    GPKGGeometryIndexDao *dao = [self geometryIndexDao];
    GPKGResultSet *results = [dao queryForEqWithField:GPKG_GI_COLUMN_TABLE_NAME andValue:tableIndex.tableName];
    return results;
}

-(int) geometryIndexCount: (GPKGTableIndex *) tableIndex{
    GPKGResultSet *results = [self geometryIndices:tableIndex];
    int count = results.count;
    [results close];
    return count;
}

-(GPKGGeometryIndexDao *) geometryIndexDao{
    return [GPKGGeometryIndexDao createWithDatabase:self.database];
}

-(int) deleteAllCascade{
    
    // Delete Geometry Indices
    [[self geometryIndexDao] deleteAll];
    
    int count = [self deleteAll];
    
    return count;
}

-(int) deleteAll{
    
    int count = 0;
    
    if([self tableExists]){
        count = [super deleteAll];
    }
    
    return count;
}

@end

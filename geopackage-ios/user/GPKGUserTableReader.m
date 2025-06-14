//
//  GPKGUserTableReader.m
//  geopackage-ios
//
//  Created by Brian Osborn on 5/27/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGUserTableReader.h>
#import <GeoPackage/GPKGSQLiteMaster.h>
#import <GeoPackage/GPKGTableInfo.h>
#import <GeoPackage/GPKGDataColumnsDao.h>

@implementation GPKGUserTableReader

-(instancetype) initWithTable: (NSString *) tableName{
    self = [super init];
    if(self != nil){
        self.tableName = tableName;
    }
    return self;
}

-(GPKGUserTable *) createTableWithName: (NSString *) tableName andColumns: (NSArray *) columns{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

-(GPKGUserColumn *) createColumnWithTableColumn: (GPKGTableColumn *) tableColumn{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

-(GPKGUserTable *) readTableWithConnection: (GPKGConnection *) db{
    
    NSMutableArray<GPKGUserColumn *> *columns = [NSMutableArray array];
    
    GPKGTableInfo *tableInfo = [GPKGTableInfo infoWithConnection:db andTable:self.tableName];
    if(tableInfo == nil){
        [NSException raise:@"No Table" format:@"Table does not exist: %@", self.tableName];
    }
    
    GPKGTableConstraints *constraints = [GPKGSQLiteMaster queryForConstraintsWithConnection:db andTable:self.tableName];
    GPKGDataColumnsDao *dataColumnsDao = [GPKGDataColumnsDao createWithDatabase:db];
    
    for(GPKGTableColumn *tableColumn in [tableInfo columns]){
        if((int)[tableColumn dataType] < 0){
            NSLog(@"Unexpected column data type: '%@', column: %@", [tableColumn type], tableColumn.name);
        }
        GPKGUserColumn *column = [self createColumnWithTableColumn:tableColumn];
        [column setAutoincrement:NO];
        
        GPKGColumnConstraints *columnConstraints = [constraints columnConstraintsForColumn:column.name];
        if(columnConstraints != nil && [columnConstraints hasConstraints]){
            [column clearConstraintsWithReset:NO];
            [column addColumnConstraints:columnConstraints];
        }
        
        @try {
            [dataColumnsDao loadSchemaWithTable:self.tableName andColumn:column];
        } @catch (NSException *exception) {
            NSLog(@"Failed to load column schema. table: %@, column: %@", self.tableName, column.name);
        }
        
        [columns addObject:column];
    }
    
    GPKGUserTable *table = [self createTableWithName:self.tableName andColumns:columns];
    
    [table addConstraints:[constraints tableConstraints]];
    
    return table;
}

@end

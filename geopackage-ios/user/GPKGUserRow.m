//
//  GPKGUserRow.m
//  geopackage-ios
//
//  Created by Brian Osborn on 5/20/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "GPKGUserRow.h"
#import <sqlite3.h>
#import "GPKGUtils.h"
#import "GPKGDateTimeUtils.h"

@implementation GPKGUserRow

-(instancetype) initWithTable: (GPKGUserTable *) table andColumns: (GPKGUserColumns *) columns andValues: (NSMutableArray *) values{
    self = [super init];
    if(self != nil){
        self.table = table;
        self.columns = columns;
        self.values = values;
    }
    return self;
}

-(instancetype) initWithTable: (GPKGUserTable *) table{
    self = [super init];
    if(self != nil){
        self.table = table;
        self.columns = [table userColumns];
        
        int columnCount = [_columns columnCount];
        NSMutableArray *tempValues = [NSMutableArray arrayWithCapacity:columnCount];
        for(int i = 0; i < columnCount; i++){
            [GPKGUtils addObject:nil toArray:tempValues];
        }
        
        self.values = tempValues;
    }
    return self;
}

-(instancetype) initWithRow: (GPKGUserRow *) row{
    self = [super init];
    if(self != nil){
        self.table = row.table;
        self.columns = row.columns;
        self.values = [NSMutableArray array];
        for(int i = 0; i < row.values.count; i++){
            NSObject *value = [GPKGUtils objectAtIndex:i inArray:row.values];
            if(value != nil){
                GPKGUserColumn *column = [row columnWithIndex:i];
                value = [self copyValue:value forColumn:column];
            }
            [GPKGUtils addObject:value toArray:self.values];
        }
    }
    return self;
}

-(NSObject *) toObjectValueWithIndex: (int) index andValue: (NSObject *) value{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

-(NSObject *) toDatabaseValueWithIndex: (int) index andValue: (NSObject *) value{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

-(NSString *) tableName{
    return [_table tableName];
}

-(int) columnCount{
    return [_columns columnCount];
}

-(NSArray *) columnNames{
    return [_columns columnNames];
}

-(NSString *) columnNameWithIndex: (int) index{
    return [_columns columnNameWithIndex:index];
}

-(int) columnIndexWithColumnName: (NSString *) columnName{
    return [_columns columnIndexWithColumnName:columnName];
}

-(NSObject *) valueWithIndex: (int) index{
    NSObject *value = [GPKGUtils objectAtIndex:index inArray:self.values];
    if(value != nil){
        GPKGUserColumn *column = [self columnWithIndex:index];
        if([value isKindOfClass:[NSString class]] && (column.dataType == GPKG_DT_DATE || column.dataType == GPKG_DT_DATETIME)){
            value = [GPKGDateTimeUtils convertToDateWithString:((NSString *) value)];
        }else{
            value = [self toObjectValueWithIndex:index andValue:value];
        }
    }
    return value;
}

-(NSObject *) valueWithColumnName: (NSString *) columnName{
    return [self valueWithIndex:[_columns columnIndexWithColumnName:columnName]];
}

-(NSObject *) valueWithColumn: (GPKGUserColumn *) column{
    return [self valueWithColumnName:column.name];
}

-(NSString *) valueStringWithIndex: (int) index{
    NSString *stringValue = nil;
    NSObject *value = [self valueWithIndex:index];
    if(value != nil){
        stringValue = (NSString *) value;
    }
    return stringValue;
}

-(NSString *) valueStringWithColumnName: (NSString *) columnName{
    return [self valueStringWithIndex:[_columns columnIndexWithColumnName:columnName]];
}

-(NSObject *) databaseValueWithIndex: (int) index{
    NSObject *value = [GPKGUtils objectAtIndex:index inArray:self.values];
    if(value != nil){
        value =[self toDatabaseValueWithIndex:index andValue:value];
    }
    return value;
}

-(NSObject *) databaseValueWithColumnName: (NSString *) columnName{
    return [self databaseValueWithIndex:[_columns columnIndexWithColumnName:columnName]];
}

-(enum GPKGDataType) dataTypeWithIndex: (int) index{
    return [self columnWithIndex:index].dataType;
}

-(enum GPKGDataType) dataTypeWithColumnName: (NSString *) columnName{
    return [self columnWithColumnName:columnName].dataType;
}

-(int) sqliteTypeWithIndex: (int) index{
    return [GPKGDataTypes sqliteType:[self dataTypeWithIndex:index]];
}

-(int) sqliteTypeWithColumnName: (NSString *) columnName{
    return [GPKGDataTypes sqliteType:[self dataTypeWithColumnName:columnName]];
}

-(GPKGUserColumn *) columnWithIndex: (int) index{
    return [_columns columnWithIndex:index];
}

-(GPKGUserColumn *) columnWithColumnName: (NSString *) columnName{
    return [_columns columnWithColumnName:columnName];
}

-(BOOL) hasColumnWithColumnName: (NSString *) columnName{
    return [_columns hasColumnWithColumnName:columnName];
}

-(NSNumber *) id{
    NSNumber *id = nil;
    GPKGUserColumn *pkColumn = [_columns pkColumn];
    if(pkColumn == nil){
        NSMutableString *error = [NSMutableString stringWithString:@"No id column in "];
        if(_columns.custom){
            [error appendString:@"custom specified table columns. "];
        }
        [error appendFormat:@"table: %@", _columns.tableName];
        if(_columns.custom){
            [error appendFormat:@", columns: [%@]", [[_columns columnNames] componentsJoinedByString:@", "]];
        }
        [NSException raise:@"No Id Column" format:error, nil];
    }
    NSObject *objectValue = [self valueWithColumn:pkColumn];
    if(objectValue == nil){
        [NSException raise:@"Null Id" format:@"Id was null. table: %@, index: %d, name: %@", _columns.tableName, pkColumn.index, pkColumn.name];
    }
    if([objectValue isKindOfClass:[NSNumber class]]){
        id = (NSNumber *) objectValue;
    }else{
        [NSException raise:@"Non Number Id" format:@"Id value was not a number. table: %@, index: %d, name: %@, value: %@", _columns.tableName, pkColumn.index, pkColumn.name, objectValue];
    }
    
    return id;
}

-(int) idValue{
    return [[self id] intValue];
}

-(BOOL) hasIdColumn{
    return [_columns hasIdColumn];
}

-(BOOL) hasId{
    BOOL hasId = NO;
    if([self hasIdColumn]){
        NSObject *objectValue = [self valueWithIndex:[self idIndex]];
        hasId = objectValue != nil && [objectValue isKindOfClass:[NSNumber class]];
    }
    return hasId;
}

-(int) idIndex{
    return [_columns idIndex];
}

-(GPKGUserColumn *) idColumn{
    return [_columns idColumn];
}

-(NSString *) idColumnName{
    return [_columns idColumnName];
}

-(NSObject *) pk{
    return [self valueWithIndex:[self pkIndex]];
}

-(BOOL) hasPkColumn{
    return [_columns hasPkColumn];
}

-(BOOL) hasPk{
    BOOL hasPk = NO;
    if([self hasPkColumn]){
        NSObject *objectValue = [self valueWithIndex:[self pkIndex]];
        hasPk = objectValue != nil;
    }
    return hasPk;
}

-(int) pkIndex{
    return [_columns pkIndex];
}

-(GPKGUserColumn *) pkColumn{
    return [_columns pkColumn];
}

-(NSString *) pkColumnName{
    return [_columns pkColumnName];
}

-(void) setValueWithIndex: (int) index andValue: (NSObject *) value{
    if(index == [_columns pkIndex] && !_columns.pkModifiable){
        [NSException raise:@"Primary Key Update" format:@"Can not update the primary key of the row. Table Name: %@, Index: %d, Name: %@", [_table tableName], index, [_table pkColumnName]];
    }
    [self setValueNoValidationWithIndex:index andValue:value];
}

-(void) setValueNoValidationWithIndex: (int) index andValue: (NSObject *) value{
    
    if(value != nil){
        if([value isKindOfClass:[NSDate class]]){
            GPKGUserColumn *userColumn = [self columnWithIndex:index];
            value = [GPKGDateTimeUtils convertToStringWithDate:(NSDate *)value andType:userColumn.dataType];
        }
    }
    
    [GPKGUtils replaceObjectAtIndex:index withObject:value inArray:self.values];
}

-(void) setValueWithColumnName: (NSString *) columnName andValue: (NSObject *) value{
    [self setValueWithIndex:[self columnIndexWithColumnName:columnName] andValue:value];
}

-(void) setId: (NSNumber *) id{
    [self setId:id withModifiable:_columns.pkModifiable];
}

-(void) setId: (NSNumber *) id withModifiable: (BOOL) pkModifiable{
    int index = [self pkIndex];
    if(index >= 0){
        if(!pkModifiable){
            [NSException raise:@"Not Modifiable" format:@"Can not update the primary key of the row. Table Name: %@, Index: %d, Name: %@", [_table tableName], index, [_table pkColumnName]];
        }
        [GPKGUtils replaceObjectAtIndex:index withObject:id inArray:self.values];
    }
}

-(void) resetId{
    [GPKGUtils replaceObjectAtIndex:[self pkIndex] withObject:nil inArray:self.values];
}

-(void) validateValueWithColumn: (GPKGUserColumn *) column andValue: (NSObject *) value andValueTypes: (NSArray *) valueTypes{
    
    if(_columns.valueValidation){
        
        enum GPKGDataType dataType = column.dataType;
        if ((int)dataType < 0) {
            [NSException raise:@"Missing Data Type" format:@"Column is missing a data type. Column: %@, Value: %@, Type: '%@', Actual Type: %@", column.name, value, column.type, NSStringFromClass([[valueTypes objectAtIndex:0] class])];
        }
        
        Class dataTypeClass = [GPKGDataTypes classType:dataType];
        
        BOOL valid = NO;
        for(Class valueType in valueTypes){
            if(valueType == dataTypeClass){
                valid = YES;
                break;
            }
        }
        
        if(!valid){
            [NSException raise:@"Illegal Value" format:@"Column: %@, Value: %@, Expected Type: %@, Actual Type: %@", column.name, value, [dataTypeClass description], [[[GPKGUtils objectAtIndex:0 inArray:valueTypes] class] description]];
        }
        
    }
    
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    GPKGUserRow *userRow = [[[self class] allocWithZone:zone] init];
    userRow.table = _table;
    userRow.columns = _columns;
    userRow.values = [NSMutableArray arrayWithCapacity:_values.count];
    for(int i = 0; i < _values.count; i++){
        NSObject *value = [_values objectAtIndex:i];
        if(![value isEqual:[NSNull null]]){
            GPKGUserColumn *column = [self columnWithIndex:i];
            value = [self copyValue:value forColumn:column];
        }
        [userRow.values addObject:value];
    }
    return userRow;
}

-(NSObject *) copyValue: (NSObject *) value forColumn: (GPKGUserColumn *) column{
    
    NSObject *copyValue = value;
        
    switch(column.dataType){
            
        case GPKG_DT_TEXT:
        case GPKG_DT_DATE:
        case GPKG_DT_DATETIME:
            
            if([value isKindOfClass:[NSMutableString class]]){
                NSMutableString *mutableString = (NSMutableString *) value;
                copyValue = [mutableString mutableCopy];
            }
            
            break;
            
        case GPKG_DT_BLOB:
            
            if([value isKindOfClass:[NSMutableData class]]){
                NSMutableData *mutableData = (NSMutableData *) value;
                copyValue = [mutableData mutableCopy];
            }
            
            break;
        default:
            break;
    }
    
    return copyValue;
}

@end

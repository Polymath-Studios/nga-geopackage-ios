//
//  GPKGDublinCoreMetadata.m
//  geopackage-ios
//
//  Created by Brian Osborn on 6/14/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import <GeoPackage/GPKGDublinCoreMetadata.h>

@implementation GPKGDublinCoreMetadata

+(BOOL) hasColumn: (GPKGDublinCoreType) type inTable: (GPKGUserTable *) table{
    
    BOOL hasColumn = [table hasColumnWithColumnName:[GPKGDublinCoreTypes name:type]];
    
    if (!hasColumn) {
        for (NSString *synonym in [GPKGDublinCoreTypes synonyms:type]) {
            hasColumn =  [table hasColumnWithColumnName:synonym];
            if (hasColumn) {
                break;
            }
        }
    }
    
    return hasColumn;
}

+(BOOL) hasColumn: (GPKGDublinCoreType) type inRow: (GPKGUserRow *) row{
    return [self hasColumn:type inTable:row.table];
}

+(GPKGUserColumn *) column: (GPKGDublinCoreType) type fromTable: (GPKGUserTable *) table{
    
    GPKGUserColumn *column = nil;
    
    NSString *typeName = [GPKGDublinCoreTypes name:type];
    if([table hasColumnWithColumnName:typeName]){
        column = [table columnWithColumnName:typeName];
    }else{
        for(NSString *synonym in [GPKGDublinCoreTypes synonyms:type]){
            if([table hasColumnWithColumnName:synonym]){
                column = [table columnWithColumnName:synonym];
                break;
            }
        }
    }
    
    return column;
}

+(GPKGUserColumn *) column: (GPKGDublinCoreType) type fromRow: (GPKGUserRow *) row{
    return [self column:type fromTable:row.table];
}

+(NSObject *) value: (GPKGDublinCoreType) type fromRow: (GPKGUserRow *) row{
    
    GPKGUserColumn *column = [self column:type fromRow:row];
    
    NSObject *value = [row valueWithIndex:column.index];
    
    return value;
}

+(void) setValue: (NSObject *) value asColumn: (GPKGDublinCoreType) type inRow: (GPKGUserRow *) row{
    
    GPKGUserColumn *column = [self column:type fromRow:row];
    
    [row setValueWithIndex:column.index andValue:value];
}

@end

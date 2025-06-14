//
//  GPKGDataColumns.m
//  geopackage-ios
//
//  Created by Brian Osborn on 5/19/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGDataColumns.h>

NSString * const GPKG_DC_TABLE_NAME = @"gpkg_data_columns";
NSString * const GPKG_DC_COLUMN_PK1 = @"table_name";
NSString * const GPKG_DC_COLUMN_PK2 = @"column_name";
NSString * const GPKG_DC_COLUMN_TABLE_NAME = @"table_name";
NSString * const GPKG_DC_COLUMN_COLUMN_NAME = @"column_name";
NSString * const GPKG_DC_COLUMN_NAME = @"name";
NSString * const GPKG_DC_COLUMN_TITLE = @"title";
NSString * const GPKG_DC_COLUMN_DESCRIPTION = @"description";
NSString * const GPKG_DC_COLUMN_MIME_TYPE = @"mime_type";
NSString * const GPKG_DC_COLUMN_CONSTRAINT_NAME = @"constraint_name";

@implementation GPKGDataColumns

-(void) setContents: (GPKGContents *) contents{
    if(contents != nil){
        self.tableName = contents.tableName;
    }else{
        self.tableName = nil;
    }
}

-(void) setConstraint: (GPKGDataColumnConstraints *) constraint{
    if(constraint != nil){
        self.constraintName = constraint.constraintName;
    }else{
        self.constraintName = nil;
    }
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    GPKGDataColumns *dataColumns = [[GPKGDataColumns alloc] init];
    dataColumns.tableName = _tableName;
    dataColumns.columnName = _columnName;
    dataColumns.name = _name;
    dataColumns.title = _title;
    dataColumns.theDescription = _theDescription;
    dataColumns.mimeType = _mimeType;
    dataColumns.constraintName = _constraintName;
    return dataColumns;
}

@end

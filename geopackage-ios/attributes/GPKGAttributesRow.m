//
//  GPKGAttributesRow.m
//  geopackage-ios
//
//  Created by Brian Osborn on 11/17/16.
//  Copyright © 2016 NGA. All rights reserved.
//

#import <GeoPackage/GPKGAttributesRow.h>

@implementation GPKGAttributesRow

-(instancetype) initWithAttributesTable: (GPKGAttributesTable *) table andColumns: (GPKGAttributesColumns *) columns andValues: (NSMutableArray *) values{
    self = [super initWithTable:table andColumns:columns andValues:values];
    if(self != nil){
        self.attributesTable = table;
        self.attributesColumns = columns;
    }
    return self;
}

-(instancetype) initWithAttributesTable: (GPKGAttributesTable *) table{
    self = [super initWithTable:table];
    if(self != nil){
        self.attributesTable = table;
        self.attributesColumns = [table attributesColumns];
    }
    return self;
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    GPKGAttributesRow *attributesRow = [super mutableCopyWithZone:zone];
    attributesRow.attributesTable = _attributesTable;
    attributesRow.attributesColumns = _attributesColumns;
    return attributesRow;
}

@end

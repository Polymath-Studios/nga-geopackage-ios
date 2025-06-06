//
//  GPKGStyleMappingRow.m
//  geopackage-ios
//
//  Created by Brian Osborn on 1/17/19.
//  Copyright © 2019 NGA. All rights reserved.
//

#import <GeoPackage/GPKGStyleMappingRow.h>

@implementation GPKGStyleMappingRow

-(instancetype) initWithStyleMappingTable: (GPKGStyleMappingTable *) table andColumns: (GPKGUserColumns *) columns andValues: (NSMutableArray *) values{
    self = [super initWithUserMappingTable:table andColumns:columns andValues:values];
    return self;
}

-(instancetype) initWithStyleMappingTable: (GPKGStyleMappingTable *) table{
    self = [super initWithUserMappingTable:table];
    return self;
}

-(GPKGStyleMappingTable *) styleMappingTable{
    return (GPKGStyleMappingTable *) [super userMappingTable];
}

-(int) geometryTypeNameColumnIndex{
    return [[self userCustomColumns] columnIndexWithColumnName:GPKG_SMT_COLUMN_GEOMETRY_TYPE_NAME];
}

-(GPKGUserCustomColumn *) geometryTypeNameColumn{
    return (GPKGUserCustomColumn *)[[self userCustomColumns] columnWithColumnName:GPKG_SMT_COLUMN_GEOMETRY_TYPE_NAME];
}

-(NSString *) geometryTypeName{
    return (NSString *)[self valueWithIndex:[self geometryTypeNameColumnIndex]];
}

-(SFGeometryType) geometryType{
    SFGeometryType geometryType = SF_NONE;
    NSString *geometryTypeName = [self geometryTypeName];
    if(geometryTypeName != nil){
        geometryType = [SFGeometryTypes fromName:geometryTypeName];
    }
    return geometryType;
}

-(void) setGeometryType: (SFGeometryType) geometryType{
    NSString *geometryTypeName = nil;
    if (geometryType != SF_NONE && geometryType >= 0) {
        geometryTypeName = [SFGeometryTypes name:geometryType];
    }
    [self setValueWithIndex:[self geometryTypeNameColumnIndex] andValue:geometryTypeName];
}

@end

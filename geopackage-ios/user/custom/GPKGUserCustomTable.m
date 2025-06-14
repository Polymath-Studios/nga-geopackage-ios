//
//  GPKGUserCustomTable.m
//  geopackage-ios
//
//  Created by Brian Osborn on 6/14/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import <GeoPackage/GPKGUserCustomTable.h>

@implementation GPKGUserCustomTable

-(instancetype) initWithTable: (NSString *) tableName andColumns: (NSArray<GPKGUserCustomColumn *> *) columns{
    return [self initWithTable:tableName andColumns:columns andRequiredColumns:nil];
}

-(instancetype) initWithTable: (NSString *) tableName andColumns: (NSArray<GPKGUserCustomColumn *> *) columns andRequiredColumns: (NSArray<NSString *> *) requiredColumns{
    return [self initWithColumns:[[GPKGUserCustomColumns alloc] initWithTable:tableName andColumns:columns andRequiredColumns:requiredColumns]];
}

-(instancetype) initWithColumns: (GPKGUserCustomColumns *) columns{
    self = [super initWithColumns:columns];
    return self;
}

-(instancetype) initWithCustomTable: (GPKGUserCustomTable *) userCustomTable{
    self = [super initWithUserTable:userCustomTable];
    return self;
}

-(NSString *) dataType{
    return [self dataTypeWithDefault:nil];
}

-(GPKGUserCustomColumns *) userCustomColumns{
    return (GPKGUserCustomColumns *) [super userColumns];
}

-(GPKGUserColumns *) createUserColumnsWithColumns: (NSArray<GPKGUserColumn *> *) columns{
    return [[GPKGUserCustomColumns alloc] initWithTable:[self tableName] andColumns:columns andRequiredColumns:[self requiredColumns] andCustom:YES];
}

-(NSArray<NSString *> *) requiredColumns{
    return [self userCustomColumns].requiredColumns;
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    GPKGUserCustomTable *userCustomTable = [super mutableCopyWithZone:zone];
    return userCustomTable;
}

@end

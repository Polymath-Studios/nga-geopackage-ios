//
//  GPKGUniqueConstraint.m
//  geopackage-ios
//
//  Created by Brian Osborn on 8/20/19.
//  Copyright © 2019 NGA. All rights reserved.
//

#import <GeoPackage/GPKGUniqueConstraint.h>

NSString * const GPKG_UNIQUE = @"UNIQUE";

@implementation GPKGUniqueConstraint

-(instancetype) init{
    self = [super initWithType:GPKG_CT_UNIQUE];
    if(self != nil){
        self.columns = [NSMutableArray array];
    }
    return self;
}

-(instancetype) initWithName: (NSString *) name{
    self = [super initWithType:GPKG_CT_UNIQUE andName:name];
    if(self != nil){
        self.columns = [NSMutableArray array];
    }
    return self;
}

-(instancetype) initWithOrder: (NSNumber *) order{
    self = [super initWithType:GPKG_CT_UNIQUE andOrder:order];
    if(self != nil){
        self.columns = [NSMutableArray array];
    }
    return self;
}

-(instancetype) initWithName: (NSString *) name andOrder: (NSNumber *) order{
    self = [super initWithType:GPKG_CT_UNIQUE andName:name andOrder:order];
    if(self != nil){
        self.columns = [NSMutableArray array];
    }
    return self;
}

-(instancetype) initWithColumn: (GPKGUserColumn *) column{
    self = [super initWithType:GPKG_CT_UNIQUE];
    if(self != nil){
        self.columns = [NSMutableArray array];
        [self addColumn:column];
    }
    return self;
}

-(instancetype) initWithColumns: (NSArray<GPKGUserColumn *> *) columns{
    self = [super initWithType:GPKG_CT_UNIQUE];
    if(self != nil){
        self.columns = [NSMutableArray array];
        [self addColumns:columns];
    }
    return self;
}

-(instancetype) initWithName: (NSString *) name andColumn: (GPKGUserColumn *) column{
    self = [super initWithType:GPKG_CT_UNIQUE andName:name];
    if(self != nil){
        self.columns = [NSMutableArray array];
        [self addColumn:column];
    }
    return self;
}

-(instancetype) initWithName: (NSString *) name andColumns: (NSArray<GPKGUserColumn *> *) columns{
    self = [super initWithType:GPKG_CT_UNIQUE andName:name];
    if(self != nil){
        self.columns = [NSMutableArray array];
        [self addColumns:columns];
    }
    return self;
}

-(void) addColumn: (GPKGUserColumn *) column{
    [self.columns addObject:column];
}

-(void) addColumns: (NSArray<GPKGUserColumn *> *) columns{
    [self.columns addObjectsFromArray:columns];
}

-(NSString *) buildSql{
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:[self buildNameSql]];
    [sql appendString:GPKG_UNIQUE];
    [sql appendString:@" ("];
    for (int i = 0; i < self.columns.count; i++) {
        GPKGUserColumn *column = [self.columns objectAtIndex:i];
        if (i > 0) {
            [sql appendString:@", "];
        }
        [sql appendString:column.name];
    }
    [sql appendString:@")"];
    return sql;
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    GPKGUniqueConstraint *constraint = [super mutableCopyWithZone:zone];
    constraint.columns = [NSMutableArray array];
    for(GPKGUserColumn *column in _columns){
        [constraint addColumn:[column mutableCopy]];
    }
    return constraint;
}

@end

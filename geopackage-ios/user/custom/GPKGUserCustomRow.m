//
//  GPKGUserCustomRow.m
//  geopackage-ios
//
//  Created by Brian Osborn on 6/19/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import <GeoPackage/GPKGUserCustomRow.h>

@implementation GPKGUserCustomRow

-(instancetype) initWithUserCustomTable: (GPKGUserCustomTable *) table andColumns: (GPKGUserCustomColumns *) columns andValues: (NSMutableArray *) values{
    self = [super initWithTable:table andColumns:columns andValues:values];
    return self;
}

-(instancetype) initWithUserCustomTable: (GPKGUserCustomTable *) table{
    self = [super initWithTable:table];
    return self;
}

-(instancetype) initWithUserCustomRow: (GPKGUserCustomRow *) userCustomRow{
    self = [super initWithRow:userCustomRow];
    return self;
}

-(GPKGUserCustomTable *) userCustomTable{
    return (GPKGUserCustomTable *) super.table;
}

-(GPKGUserCustomColumns *) userCustomColumns{
    return (GPKGUserCustomColumns *) super.columns;
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    GPKGUserCustomRow *userCustomRow = [super mutableCopyWithZone:zone];
    return userCustomRow;
}

@end

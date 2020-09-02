//
//  GPKGAttributesColumn.m
//  geopackage-ios
//
//  Created by Brian Osborn on 11/1/16.
//  Copyright © 2016 NGA. All rights reserved.
//

#import "GPKGAttributesColumn.h"
#import "GPKGUserTable.h"

@implementation GPKGAttributesColumn

+(GPKGAttributesColumn *) createPrimaryKeyColumnWithName: (NSString *) name{
    return [self createPrimaryKeyColumnWithName:name andAutoincrement:DEFAULT_AUTOINCREMENT];
}

+(GPKGAttributesColumn *) createPrimaryKeyColumnWithName: (NSString *) name andAutoincrement: (BOOL) autoincrement{
    return [self createPrimaryKeyColumnWithIndex:NO_INDEX andName:name andAutoincrement:autoincrement];
}

+(GPKGAttributesColumn *) createPrimaryKeyColumnWithIndex: (int) index
                                                  andName: (NSString *) name{
    return [self createPrimaryKeyColumnWithIndex:index andName:name andAutoincrement:DEFAULT_AUTOINCREMENT];
}

+(GPKGAttributesColumn *) createPrimaryKeyColumnWithIndex: (int) index
                                                  andName: (NSString *) name andAutoincrement: (BOOL) autoincrement{
    return [[GPKGAttributesColumn alloc] initWithIndex:index andName:name andDataType:GPKG_DT_INTEGER andMax:nil andNotNull:YES andDefaultValue:nil andPrimaryKey:YES andAutoincrement:autoincrement];
}

+(GPKGAttributesColumn *) createColumnWithName: (NSString *) name
                                   andDataType: (enum GPKGDataType) type{
    return [self createColumnWithIndex:NO_INDEX andName:name andDataType:type];
}

+(GPKGAttributesColumn *) createColumnWithIndex: (int) index
                                        andName: (NSString *) name
                                    andDataType: (enum GPKGDataType) type{
    return [self createColumnWithIndex:index andName:name andDataType:type andNotNull:NO andDefaultValue:nil];
}

+(GPKGAttributesColumn *) createColumnWithName: (NSString *) name
                                   andDataType: (enum GPKGDataType) type
                                    andNotNull: (BOOL) notNull{
    return [self createColumnWithIndex:NO_INDEX andName:name andDataType:type andNotNull:notNull];
}

+(GPKGAttributesColumn *) createColumnWithIndex: (int) index
                                        andName: (NSString *) name
                                    andDataType: (enum GPKGDataType) type
                                     andNotNull: (BOOL) notNull{
    return [self createColumnWithIndex:index andName:name andDataType:type andNotNull:notNull andDefaultValue:nil];
}

+(GPKGAttributesColumn *) createColumnWithName: (NSString *) name
                                   andDataType: (enum GPKGDataType) type
                                    andNotNull: (BOOL) notNull
                               andDefaultValue: (NSObject *) defaultValue{
    return [self createColumnWithIndex:NO_INDEX andName:name andDataType:type andNotNull:notNull andDefaultValue:defaultValue];
}

+(GPKGAttributesColumn *) createColumnWithIndex: (int) index
                                        andName: (NSString *) name
                                    andDataType: (enum GPKGDataType) type
                                     andNotNull: (BOOL) notNull
                                andDefaultValue: (NSObject *) defaultValue{
    return [self createColumnWithIndex:index andName:name andDataType:type andMax:nil andNotNull:notNull andDefaultValue:defaultValue];
}

+(GPKGAttributesColumn *) createColumnWithName: (NSString *) name
                                   andDataType: (enum GPKGDataType) type
                                        andMax: (NSNumber *) max{
    return [self createColumnWithIndex:NO_INDEX andName:name andDataType:type andMax:max];
}

+(GPKGAttributesColumn *) createColumnWithIndex: (int) index
                                        andName: (NSString *) name
                                    andDataType: (enum GPKGDataType) type
                                         andMax: (NSNumber *) max{
    return [self createColumnWithIndex:index andName:name andDataType:type andMax:max andNotNull:NO andDefaultValue:nil];
}

+(GPKGAttributesColumn *) createColumnWithName: (NSString *) name
                                   andDataType: (enum GPKGDataType) type
                                        andMax: (NSNumber *) max
                                    andNotNull: (BOOL) notNull
                               andDefaultValue: (NSObject *) defaultValue{
    return [self createColumnWithIndex:NO_INDEX andName:name andDataType:type andMax:max andNotNull:notNull andDefaultValue:defaultValue];
}

+(GPKGAttributesColumn *) createColumnWithIndex: (int) index
                                        andName: (NSString *) name
                                    andDataType: (enum GPKGDataType) type
                                         andMax: (NSNumber *) max
                                     andNotNull: (BOOL) notNull
                                andDefaultValue: (NSObject *) defaultValue{
    return [[GPKGAttributesColumn alloc] initWithIndex:index andName:name andDataType:type andMax:max andNotNull:notNull andDefaultValue:defaultValue andPrimaryKey:NO andAutoincrement:NO];
}

+(GPKGAttributesColumn *) createColumnWithTableColumn: (GPKGTableColumn *) tableColumn{
    return [[GPKGAttributesColumn alloc] initWithTableColumn:tableColumn];
}

-(instancetype) initWithIndex: (int) index
                      andName: (NSString *) name
                  andDataType: (enum GPKGDataType) dataType
                       andMax: (NSNumber *) max
                   andNotNull: (BOOL) notNull
              andDefaultValue: (NSObject *) defaultValue
                andPrimaryKey: (BOOL) primaryKey
                andAutoincrement: (BOOL) autoincrement{
    self = [super initWithIndex:index andName:name andDataType:dataType andMax:max andNotNull:notNull andDefaultValue:defaultValue andPrimaryKey:primaryKey andAutoincrement:autoincrement];
    return self;
}

-(instancetype) initWithTableColumn: (GPKGTableColumn *) tableColumn{
    self = [super initWithTableColumn:tableColumn];
    return self;
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    GPKGAttributesColumn *attributesColumn = [super mutableCopyWithZone:zone];
    return attributesColumn;
}

@end

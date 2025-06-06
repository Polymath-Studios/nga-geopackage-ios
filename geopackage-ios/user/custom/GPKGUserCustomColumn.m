//
//  GPKGUserCustomColumn.m
//  geopackage-ios
//
//  Created by Brian Osborn on 6/14/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import <GeoPackage/GPKGUserCustomColumn.h>
#import <GeoPackage/GPKGUserTable.h>

@implementation GPKGUserCustomColumn

+(GPKGUserCustomColumn *) createPrimaryKeyColumnWithName: (NSString *) name{
    return [self createPrimaryKeyColumnWithName:name andAutoincrement:DEFAULT_AUTOINCREMENT];
}

+(GPKGUserCustomColumn *) createPrimaryKeyColumnWithName: (NSString *) name
                                        andAutoincrement: (BOOL) autoincrement{
    return [self createPrimaryKeyColumnWithIndex:NO_INDEX andName:name andAutoincrement:autoincrement];
}

+(GPKGUserCustomColumn *) createPrimaryKeyColumnWithIndex: (int) index
                                                  andName: (NSString *) name{
    return [self createPrimaryKeyColumnWithIndex:index andName:name andAutoincrement:DEFAULT_AUTOINCREMENT];
}

+(GPKGUserCustomColumn *) createPrimaryKeyColumnWithIndex: (int) index
                                                  andName: (NSString *) name
                                         andAutoincrement: (BOOL) autoincrement{
    return [[GPKGUserCustomColumn alloc] initWithIndex:index andName:name andDataType:GPKG_DT_INTEGER andMax:nil andNotNull:YES andDefaultValue:nil andPrimaryKey:YES andAutoincrement:autoincrement];
}

+(GPKGUserCustomColumn *) createColumnWithName: (NSString *) name
                                   andDataType: (GPKGDataType) type{
    return [self createColumnWithIndex:NO_INDEX andName:name andDataType:type];
}

+(GPKGUserCustomColumn *) createColumnWithIndex: (int) index
                                        andName: (NSString *) name
                                    andDataType: (GPKGDataType) type{
    return [self createColumnWithIndex:index andName:name andDataType:type andNotNull:NO andDefaultValue:nil];
}

+(GPKGUserCustomColumn *) createColumnWithName: (NSString *) name
                                   andDataType: (GPKGDataType) type
                                    andNotNull: (BOOL) notNull{
    return [self createColumnWithIndex:NO_INDEX andName:name andDataType:type andNotNull:notNull];
}

+(GPKGUserCustomColumn *) createColumnWithIndex: (int) index
                                        andName: (NSString *) name
                                    andDataType: (GPKGDataType) type
                                     andNotNull: (BOOL) notNull{
    return [self createColumnWithIndex:index andName:name andDataType:type andNotNull:notNull andDefaultValue:nil];
}

+(GPKGUserCustomColumn *) createColumnWithName: (NSString *) name
                                   andDataType: (GPKGDataType) type
                                    andNotNull: (BOOL) notNull
                               andDefaultValue: (NSObject *) defaultValue{
    return [self createColumnWithIndex:NO_INDEX andName:name andDataType:type andNotNull:notNull andDefaultValue:defaultValue];
}

+(GPKGUserCustomColumn *) createColumnWithIndex: (int) index
                                        andName: (NSString *) name
                                    andDataType: (GPKGDataType) type
                                     andNotNull: (BOOL) notNull
                                andDefaultValue: (NSObject *) defaultValue{
    return [self createColumnWithIndex:index andName:name andDataType:type andMax:nil andNotNull:notNull andDefaultValue:defaultValue];
}

+(GPKGUserCustomColumn *) createColumnWithName: (NSString *) name
                                   andDataType: (GPKGDataType) type
                                        andMax: (NSNumber *) max{
    return [self createColumnWithIndex:NO_INDEX andName:name andDataType:type andMax:max];
}

+(GPKGUserCustomColumn *) createColumnWithIndex: (int) index
                                        andName: (NSString *) name
                                    andDataType: (GPKGDataType) type
                                         andMax: (NSNumber *) max{
    return [self createColumnWithIndex:index andName:name andDataType:type andMax:max andNotNull:NO andDefaultValue:nil];
}

+(GPKGUserCustomColumn *) createColumnWithName: (NSString *) name
                                   andDataType: (GPKGDataType) type
                                        andMax: (NSNumber *) max
                                    andNotNull: (BOOL) notNull
                               andDefaultValue: (NSObject *) defaultValue{
    return [self createColumnWithIndex:NO_INDEX andName:name andDataType:type andMax:max andNotNull:notNull andDefaultValue:defaultValue];
}

+(GPKGUserCustomColumn *) createColumnWithIndex: (int) index
                                        andName: (NSString *) name
                                    andDataType: (GPKGDataType) type
                                         andMax: (NSNumber *) max
                                     andNotNull: (BOOL) notNull
                                andDefaultValue: (NSObject *) defaultValue{
    return [[GPKGUserCustomColumn alloc] initWithIndex:index andName:name andDataType:type andMax:max andNotNull:notNull andDefaultValue:defaultValue andPrimaryKey:NO andAutoincrement:NO];
}

+(GPKGUserCustomColumn *) createColumnWithTableColumn: (GPKGTableColumn *) tableColumn{
    return [[GPKGUserCustomColumn alloc] initWithTableColumn:tableColumn];
}

/**
 *  Initialize
 *
 *  @param index        index
 *  @param name         column name
 *  @param dataType     data type
 *  @param max          max value
 *  @param notNull      not null flag
 *  @param defaultValue default value
 *  @param primaryKey   primary key flag
 *  @param autoincrement autoincrement flag
 *
 *  @return new user column
 */
-(instancetype) initWithIndex: (int) index
                      andName: (NSString *) name
                  andDataType: (GPKGDataType) dataType
                       andMax: (NSNumber *) max
                   andNotNull: (BOOL) notNull
              andDefaultValue: (NSObject *) defaultValue
                andPrimaryKey: (BOOL) primaryKey
             andAutoincrement: (BOOL) autoincrement{
    self = [super initWithIndex:index andName:name andDataType:dataType andMax:max andNotNull:notNull andDefaultValue:defaultValue andPrimaryKey:primaryKey andAutoincrement:autoincrement];
    return self;
}

/**
 * Initialize
 *
 * @param tableColumn
 *            table column
 */
-(instancetype) initWithTableColumn: (GPKGTableColumn *) tableColumn{
    self = [super initWithTableColumn:tableColumn];
    return self;
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    GPKGUserCustomColumn *userCustomColumn = [super mutableCopyWithZone:zone];
    return userCustomColumn;
}

@end

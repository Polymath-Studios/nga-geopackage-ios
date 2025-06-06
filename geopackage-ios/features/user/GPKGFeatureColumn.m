//
//  GPKGFeatureColumn.m
//  geopackage-ios
//
//  Created by Brian Osborn on 5/26/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGFeatureColumn.h>
#import <GeoPackage/GPKGUserTable.h>

@implementation GPKGFeatureColumn

+(GPKGFeatureColumn *) createPrimaryKeyColumnWithName: (NSString *) name{
    return [self createPrimaryKeyColumnWithName:name andAutoincrement:DEFAULT_AUTOINCREMENT];
}

+(GPKGFeatureColumn *) createPrimaryKeyColumnWithName: (NSString *) name andAutoincrement: (BOOL) autoincrement{
    return [self createPrimaryKeyColumnWithIndex:NO_INDEX andName:name andAutoincrement:autoincrement];
}

+(GPKGFeatureColumn *) createPrimaryKeyColumnWithIndex: (int) index
                                               andName: (NSString *) name{
    return [self createPrimaryKeyColumnWithIndex:index andName:name andAutoincrement:DEFAULT_AUTOINCREMENT];
}

+(GPKGFeatureColumn *) createPrimaryKeyColumnWithIndex: (int) index andName: (NSString *) name andAutoincrement: (BOOL) autoincrement{
    return [[GPKGFeatureColumn alloc] initWithIndex:index andName:name andDataType:GPKG_DT_INTEGER andMax:nil andNotNull:YES andDefaultValue:nil andPrimaryKey:YES andAutoincrement:autoincrement andGeometryType:SF_NONE];
}

+(GPKGFeatureColumn *) createGeometryColumnWithName: (NSString *) name
                                    andGeometryType: (SFGeometryType) type{
    return [self createGeometryColumnWithIndex:NO_INDEX andName:name andGeometryType:type];
}

+(GPKGFeatureColumn *) createGeometryColumnWithIndex: (int) index andName: (NSString *) name
                                         andGeometryType: (SFGeometryType) type{
    return [self createGeometryColumnWithIndex:index andName:name andGeometryType:type andNotNull:NO andDefaultValue:nil];
}

+(GPKGFeatureColumn *) createGeometryColumnWithName: (NSString *) name
                                    andGeometryType: (SFGeometryType) type
                                         andNotNull: (BOOL) notNull
                                    andDefaultValue: (NSObject *) defaultValue{
    return [self createGeometryColumnWithIndex:NO_INDEX andName:name andGeometryType:type andNotNull:NO andDefaultValue:nil];
}

+(GPKGFeatureColumn *) createGeometryColumnWithIndex: (int) index
                                             andName: (NSString *) name
                                     andGeometryType: (SFGeometryType) type
                                          andNotNull: (BOOL) notNull
                                     andDefaultValue: (NSObject *) defaultValue{
    return [[GPKGFeatureColumn alloc] initWithIndex:index andName:name andDataType:GPKG_DT_BLOB andMax:nil andNotNull:notNull andDefaultValue:defaultValue andPrimaryKey:NO andAutoincrement:NO andGeometryType:type];
}

+(GPKGFeatureColumn *) createColumnWithName: (NSString *) name
                                andDataType: (GPKGDataType) type{
    return [self createColumnWithIndex:NO_INDEX andName:name andDataType:type];
}

+(GPKGFeatureColumn *) createColumnWithIndex: (int) index
                                     andName: (NSString *) name
                                 andDataType: (GPKGDataType) type{
    return [self createColumnWithIndex:index andName:name andDataType:type andNotNull:NO andDefaultValue:nil];
}

+(GPKGFeatureColumn *) createColumnWithName: (NSString *) name
                                andDataType: (GPKGDataType) type
                                 andNotNull: (BOOL) notNull{
    return [self createColumnWithIndex:NO_INDEX andName:name andDataType:type andNotNull:notNull];
}

+(GPKGFeatureColumn *) createColumnWithIndex: (int) index
                                     andName: (NSString *) name
                                 andDataType: (GPKGDataType) type
                                  andNotNull: (BOOL) notNull{
    return [self createColumnWithIndex:index andName:name andDataType:type andNotNull:notNull andDefaultValue:nil];
}

+(GPKGFeatureColumn *) createColumnWithName: (NSString *) name
                                andDataType: (GPKGDataType) type
                                 andNotNull: (BOOL) notNull
                            andDefaultValue: (NSObject *) defaultValue{
    return [self createColumnWithIndex:NO_INDEX andName:name andDataType:type andNotNull:notNull andDefaultValue:defaultValue];
}

+(GPKGFeatureColumn *) createColumnWithIndex: (int) index
                                     andName: (NSString *) name
                                 andDataType: (GPKGDataType) type
                                  andNotNull: (BOOL) notNull
                             andDefaultValue: (NSObject *) defaultValue{
    return [self createColumnWithIndex:index andName:name andDataType:type andMax:nil andNotNull:notNull andDefaultValue:defaultValue];
}

+(GPKGFeatureColumn *) createColumnWithName: (NSString *) name
                                andDataType: (GPKGDataType) type
                                     andMax: (NSNumber *) max{
    return [self createColumnWithIndex:NO_INDEX andName:name andDataType:type andMax:max];
}

+(GPKGFeatureColumn *) createColumnWithIndex: (int) index
                                     andName: (NSString *) name
                                 andDataType: (GPKGDataType) type
                                      andMax: (NSNumber *) max{
    return [self createColumnWithIndex:index andName:name andDataType:type andMax:max andNotNull:NO andDefaultValue:nil];
}

+(GPKGFeatureColumn *) createColumnWithName: (NSString *) name
                                andDataType: (GPKGDataType) type
                                     andMax: (NSNumber *) max
                                 andNotNull: (BOOL) notNull
                            andDefaultValue: (NSObject *) defaultValue{
    return [self createColumnWithIndex:NO_INDEX andName:name andDataType:type andMax:max andNotNull:notNull andDefaultValue:defaultValue];
}

+(GPKGFeatureColumn *) createColumnWithIndex: (int) index
                                     andName: (NSString *) name
                                 andDataType: (GPKGDataType) type
                                      andMax: (NSNumber *) max
                                  andNotNull: (BOOL) notNull
                             andDefaultValue: (NSObject *) defaultValue{
    return [[GPKGFeatureColumn alloc] initWithIndex:index andName:name andDataType:type andMax:max andNotNull:notNull andDefaultValue:defaultValue andPrimaryKey:NO andAutoincrement:NO andGeometryType:SF_NONE];
}

+(GPKGFeatureColumn *) createColumnWithTableColumn: (GPKGTableColumn *) tableColumn{
    return [[GPKGFeatureColumn alloc] initWithTableColumn:tableColumn];
}

-(instancetype) initWithIndex: (int) index
                      andName: (NSString *) name
                  andDataType: (GPKGDataType) dataType
                       andMax: (NSNumber *) max
                   andNotNull: (BOOL) notNull
              andDefaultValue: (NSObject *) defaultValue
                andPrimaryKey: (BOOL) primaryKey
             andAutoincrement: (BOOL) autoincrement
              andGeometryType: (SFGeometryType) geometryType{
    self = [super initWithIndex:index andName:name andType:[self typeNameForName:name withDataType:dataType andGeometryType:geometryType] andDataType:dataType andMax:max andNotNull:notNull andDefaultValue:defaultValue andPrimaryKey:primaryKey andAutoincrement:autoincrement];
    if(self != nil){
        self.geometryType = geometryType;
    }
    return self;
}

-(instancetype) initWithTableColumn: (GPKGTableColumn *) tableColumn{
    self = [super initWithTableColumn:tableColumn];
    if(self != nil){
        self.geometryType = [self geometryTypeOfTableColumn:tableColumn];
    }
    return self;
}

-(NSString *) typeNameForName: (NSString *) name withDataType: (GPKGDataType) dataType andGeometryType: (SFGeometryType) geometryType{
    NSString *type = nil;
    if(geometryType != SF_NONE && geometryType >= 0){
        type = [SFGeometryTypes name:geometryType];
    }else {
        type = [GPKGUserColumn nameOfDataType:dataType forColumn:name];
    }
    return type;
}

-(SFGeometryType) geometryTypeOfTableColumn: (GPKGTableColumn *) tableColumn{
    SFGeometryType geometryType = SF_NONE;
    if([tableColumn isDataType:GPKG_DT_BLOB]){
        geometryType = [SFGeometryTypes fromName:tableColumn.type];
    }
    return geometryType;
}

-(BOOL) isGeometry{
    return self.geometryType != SF_NONE && self.geometryType >= 0;
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    GPKGFeatureColumn *featureColumn = [super mutableCopyWithZone:zone];
    featureColumn.geometryType = _geometryType;
    return featureColumn;
}

@end

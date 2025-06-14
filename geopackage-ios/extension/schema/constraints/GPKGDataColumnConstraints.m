//
//  GPKGDataColumnConstraints.m
//  geopackage-ios
//
//  Created by Brian Osborn on 5/19/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGDataColumnConstraints.h>
#import <GeoPackage/GPKGUtils.h>

NSString * const GPKG_DCC_TABLE_NAME = @"gpkg_data_column_constraints";
NSString * const GPKG_DCC_COLUMN_CONSTRAINT_NAME = @"constraint_name";
NSString * const GPKG_DCC_COLUMN_CONSTRAINT_TYPE = @"constraint_type";
NSString * const GPKG_DCC_COLUMN_VALUE = @"value";
NSString * const GPKG_DCC_COLUMN_MIN = @"min";
NSString * const GPKG_DCC_COLUMN_MIN_IS_INCLUSIVE = @"min_is_inclusive";
NSString * const GPKG_DCC_COLUMN_MAX = @"max";
NSString * const GPKG_DCC_COLUMN_MAX_IS_INCLUSIVE = @"max_is_inclusive";
NSString * const GPKG_DCC_COLUMN_DESCRIPTION = @"description";

NSString * const GPKG_DCCT_RANGE_NAME =@"range";
NSString * const GPKG_DCCT_ENUM_NAME =@"enum";
NSString * const GPKG_DCCT_GLOB_NAME =@"glob";

@implementation GPKGDataColumnConstraints

-(GPKGDataColumnConstraintType) dataColumnConstraintType{
    GPKGDataColumnConstraintType value = -1;
    
    if(self.constraintType != nil){
        NSDictionary *constraintTypes = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInteger:GPKG_DCCT_RANGE], GPKG_DCCT_RANGE_NAME,
                                   [NSNumber numberWithInteger:GPKG_DCCT_ENUM], GPKG_DCCT_ENUM_NAME,
                                   [NSNumber numberWithInteger:GPKG_DCCT_GLOB], GPKG_DCCT_GLOB_NAME,
                                   nil
                                   ];
        NSNumber *enumValue = [GPKGUtils objectForKey:self.constraintType inDictionary:constraintTypes];
        if(enumValue != nil){
            value = (GPKGDataColumnConstraintType)[enumValue intValue];
        }
    }
    
    return value;
}

-(void) setConstraintType:(NSString *)constraintType{
    _constraintType = constraintType;
    GPKGDataColumnConstraintType type = [self dataColumnConstraintType];
    [self setDataColumnConstraintType:type];
}

-(void) setDataColumnConstraintType: (GPKGDataColumnConstraintType) constraintType{
    switch(constraintType){
        case GPKG_DCCT_RANGE:
            _constraintType = GPKG_DCCT_RANGE_NAME;
            break;
        case GPKG_DCCT_ENUM:
            _constraintType = GPKG_DCCT_ENUM_NAME;
            break;
        case GPKG_DCCT_GLOB:
            _constraintType = GPKG_DCCT_GLOB_NAME;
            break;
    }
    switch(constraintType){
        case GPKG_DCCT_RANGE:
            _value = nil;
            break;
        case GPKG_DCCT_ENUM:
        case GPKG_DCCT_GLOB:
            _min = nil;
            _max = nil;
            _minIsInclusive = nil;
            _maxIsInclusive = nil;
            break;
    }
}

-(void) setValue:(NSString *)value{
    if(self.constraintType != nil && value != nil && [self dataColumnConstraintType] == GPKG_DCCT_RANGE){
        [NSException raise:@"Illegal State" format:@"The value must be null for range constraints"];
    }
    _value = value;
}

-(void) setMin:(NSDecimalNumber *)min{
    [self validateRangeValueWithColumn:GPKG_DCC_COLUMN_MIN andValue:min];
    _min = min;
}

-(void) setMinValue:(double)min{
    [self setMin:[[NSDecimalNumber alloc] initWithDouble:min]];
}

-(void) setMinIsInclusive:(NSNumber *)minIsInclusive{
    [self validateRangeValueWithColumn:GPKG_DCC_COLUMN_MIN_IS_INCLUSIVE andValue:minIsInclusive];
    _minIsInclusive = minIsInclusive;
}

-(void) setMinIsInclusiveValue:(BOOL)minIsInclusive{
    [self setMinIsInclusive:[NSNumber numberWithBool:minIsInclusive]];
}

-(void) setMax:(NSDecimalNumber *)max{
    [self validateRangeValueWithColumn:GPKG_DCC_COLUMN_MAX andValue:max];
    _max = max;
}

-(void) setMaxValue:(double)max{
    [self setMax:[[NSDecimalNumber alloc] initWithDouble:max]];
}

-(void) setMaxIsInclusive:(NSNumber *)maxIsInclusive{
    [self validateRangeValueWithColumn:GPKG_DCC_COLUMN_MAX_IS_INCLUSIVE andValue:maxIsInclusive];
    _maxIsInclusive = maxIsInclusive;
}

-(void) setMaxIsInclusiveValue:(BOOL)maxIsInclusive{
    [self setMaxIsInclusive:[NSNumber numberWithBool:maxIsInclusive]];
}

-(void) validateRangeValueWithColumn: (NSString *) column andValue: (NSObject *) value{
    if(self.constraintType != nil && value != nil && [self dataColumnConstraintType] != GPKG_DCCT_RANGE){
        [NSException raise:@"Illegal State" format:@"The %@ must be null for enum and glob constraints", column];
    }
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    GPKGDataColumnConstraints *dataColumnConstraints = [[GPKGDataColumnConstraints alloc] init];
    dataColumnConstraints.constraintName = _constraintName;
    dataColumnConstraints.constraintType = _constraintType;
    dataColumnConstraints.value = _value;
    dataColumnConstraints.min = _min;
    dataColumnConstraints.minIsInclusive = _minIsInclusive;
    dataColumnConstraints.max = _max;
    dataColumnConstraints.maxIsInclusive = _maxIsInclusive;
    dataColumnConstraints.theDescription = _theDescription;
    return dataColumnConstraints;
}

@end

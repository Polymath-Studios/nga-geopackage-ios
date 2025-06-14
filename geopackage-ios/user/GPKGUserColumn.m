//
//  GPKGUserColumn.m
//  geopackage-ios
//
//  Created by Brian Osborn on 5/20/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGUserColumn.h>
#import <GeoPackage/GPKGRawConstraint.h>
#import <GeoPackage/GPKGSqlUtils.h>

@interface GPKGUserColumn()

/**
 * List of column constraints
 */
@property (nonatomic, strong) GPKGConstraints *constraints;

@end

@implementation GPKGUserColumn

-(instancetype) initWithIndex: (int) index
                      andName: (NSString *) name
                  andDataType: (GPKGDataType) dataType
                       andMax: (NSNumber *) max
                   andNotNull: (BOOL) notNull
              andDefaultValue: (NSObject *) defaultValue
                andPrimaryKey: (BOOL) primaryKey
                andAutoincrement: (BOOL) autoincrement{
    return [self initWithIndex:index andName:name andType:[GPKGUserColumn nameOfDataType:dataType forColumn:name] andDataType:dataType andMax:max andNotNull:notNull andDefaultValue:defaultValue andPrimaryKey:primaryKey andAutoincrement:autoincrement];
}

-(instancetype) initWithIndex: (int) index
                      andName: (NSString *) name
                      andType: (NSString *) type
                  andDataType: (GPKGDataType) dataType
                       andMax: (NSNumber *) max
                   andNotNull: (BOOL) notNull
              andDefaultValue: (NSObject *) defaultValue
                andPrimaryKey: (BOOL) primaryKey
                andAutoincrement: (BOOL) autoincrement{
    self = [super init];
    if(self != nil){
        _index = index;
        _name = name;
        _max = max;
        _notNull = notNull;
        _defaultValue = defaultValue;
        _primaryKey = primaryKey;
        _autoincrement = autoincrement;
        _type = type;
        _dataType = dataType;
        _constraints = [[GPKGConstraints alloc] init];
        
        [GPKGUserColumn validateDataType:dataType forColumn:name];
        [self validateMax];
        
        [self addDefaultConstraints];
    }
    return self;
}

-(instancetype) initWithTableColumn: (GPKGTableColumn *) tableColumn{
    return [self initWithIndex:[tableColumn index] andName:[tableColumn name] andType:[tableColumn type] andDataType:[tableColumn dataType] andMax:[tableColumn max] andNotNull:[tableColumn notNull] || [tableColumn primaryKey] andDefaultValue:[tableColumn defaultValue] andPrimaryKey:[tableColumn primaryKey] andAutoincrement:[tableColumn primaryKey] && DEFAULT_AUTOINCREMENT];
}

/**
 * Copy Initialize
 *
 * @param userColumn
 *            user column
 */
-(instancetype) initWithUserColumn: (GPKGUserColumn *) userColumn{
    self = [super init];
    if(self != nil){
        _index = userColumn.index;
        _name = userColumn.name;
        _max = userColumn.max;
        _notNull = userColumn.notNull;
        _defaultValue = userColumn.defaultValue;
        _primaryKey = userColumn.primaryKey;
        _autoincrement = userColumn.autoincrement;
        _type = userColumn.type;
        _dataType = userColumn.dataType;
        _constraints = [userColumn.constraints mutableCopy];
        if(userColumn.schema != nil){
            _schema = [userColumn.schema mutableCopy];
        }
    }
    return self;
}

+(NSString *) nameOfDataType: (GPKGDataType) dataType forColumn: (NSString *) name{
    [self validateDataType:dataType forColumn:name];
    return [GPKGDataTypes name:dataType];
}

/**
 * Validate the data type
 *
 * @param name
 *            column name
 *
 * @param dataType
 *            data type
 */
+(void) validateDataType: (GPKGDataType) dataType forColumn: (NSString *) name{
    if((int)dataType < 0){
        NSLog(@"Column is missing a data type: %@", name);
    }
}

-(BOOL) hasIndex{
    return self.index > NO_INDEX;
}

-(void) setIndex: (int) index{
    if ([self hasIndex]) {
        if (index != _index) {
            [NSException raise:@"Modified Index" format:@"User Column with a valid index may not be changed. Column Name: %@, Index: %d, Attempted Index: %d", _name, _index, index];
        }
    } else {
        _index = index;
    }
}

-(void) resetIndex{
    _index = NO_INDEX;
}

-(BOOL) isNamed: (NSString *) name{
    return [self.name isEqualToString:name];
}

-(BOOL) hasMax{
    return self.max != nil;
}

-(void) setNotNull: (BOOL) notNull{
    if(_notNull != notNull){
        if(notNull){
            [self addNotNullConstraint];
        }else{
            [self removeNotNullConstraint];
        }
    }
    _notNull = notNull;
}

-(BOOL) hasDefaultValue{
    return self.defaultValue != nil;
}

-(void) setDefaultValue: (NSObject *) defaultValue{
    [self removeDefaultValueConstraint];
    if(defaultValue != nil){
        [self addDefaultValueConstraint:defaultValue];
    }
    _defaultValue = defaultValue;
}

-(void) setPrimaryKey: (BOOL) primaryKey{
    if(_primaryKey != primaryKey){
        if(primaryKey){
            [self addPrimaryKeyConstraint];
        }else{
            [self removeAutoincrementConstraint];
            [self removePrimaryKeyConstraint];
        }
    }
    _primaryKey = primaryKey;
}

-(void) setAutoincrement: (BOOL) autoincrement{
    if(_autoincrement != autoincrement){
        if(autoincrement){
            [self addAutoincrementConstraint];
        }else{
            [self removeAutoincrementConstraint];
        }
    }
    _autoincrement = autoincrement;
}

-(void) setUnique: (BOOL) unique{
    if(_unique != unique){
        if(unique){
            [self addUniqueConstraint];
        }else{
            [self removeUniqueConstraint];
        }
    }
    _unique = unique;
}

-(BOOL) hasConstraints{
    return [self.constraints has];
}

-(BOOL) hasConstraintsOfType: (GPKGConstraintType) type{
    return [self.constraints hasType:type];
}

-(GPKGConstraints *) constraints{
    return _constraints;
}

-(NSArray<GPKGConstraint *> *) constraintsOfType: (GPKGConstraintType) type{
    return [self.constraints ofType:type];
}

-(NSArray<GPKGConstraint *> *) clearConstraints{
    return [self clearConstraintsWithReset:YES];
}

-(NSArray<GPKGConstraint *> *) clearConstraintsWithReset: (BOOL) reset{

    if (reset) {
        _primaryKey = NO;
        _unique = NO;
        _notNull = NO;
        _defaultValue = nil;
        _autoincrement = NO;
    }

    return [self.constraints clear];
}

-(NSArray<GPKGConstraint *> *) clearConstraintsOfType: (GPKGConstraintType) type{
    
    switch (type) {
        case GPKG_CT_PRIMARY_KEY:
            _primaryKey = NO;
            break;
        case GPKG_CT_UNIQUE:
            _unique = NO;
            break;
        case GPKG_CT_NOT_NULL:
            _notNull = NO;
            break;
        case GPKG_CT_DEFAULT:
            _defaultValue = nil;
            break;
        case GPKG_CT_AUTOINCREMENT:
            _autoincrement = NO;
            break;
        default:
            break;
    }
    
    return [self.constraints clearType:type];
}

-(void) addDefaultConstraints{
    if ([self notNull]) {
        [self addNotNullConstraint];
    }
    if ([self hasDefaultValue]) {
        [self addDefaultValueConstraint:self.defaultValue];
    }
    if ([self primaryKey]) {
        [self addPrimaryKeyConstraint];
    }
    if ([self autoincrement]) {
        [self addAutoincrementConstraint];
    }
}

-(void) addConstraint: (GPKGConstraint *) constraint{
    
    if(constraint.order == nil){
        [self setConstraintOrder:constraint];
    }
    
    [self.constraints add:constraint];
    
    switch (constraint.type) {
        case GPKG_CT_PRIMARY_KEY:
            _primaryKey = YES;
            break;
        case GPKG_CT_UNIQUE:
            _unique = YES;
            break;
        case GPKG_CT_NOT_NULL:
            _notNull = YES;
            break;
        case GPKG_CT_DEFAULT:
            break;
        case GPKG_CT_AUTOINCREMENT:
            _autoincrement = YES;
            break;
        default:
            break;
    }
    
}

-(void) setConstraintOrder: (GPKGConstraint *) constraint{
    
    NSNumber *order = nil;
    
    switch (constraint.type) {
        case GPKG_CT_PRIMARY_KEY:
            order = [NSNumber numberWithInt:PRIMARY_KEY_CONSTRAINT_ORDER];
            break;
        case GPKG_CT_UNIQUE:
            order = [NSNumber numberWithInt:UNIQUE_CONSTRAINT_ORDER];
            break;
        case GPKG_CT_NOT_NULL:
            order = [NSNumber numberWithInt:NOT_NULL_CONSTRAINT_ORDER];
            break;
        case GPKG_CT_DEFAULT:
            order = [NSNumber numberWithInt:DEFAULT_VALUE_CONSTRAINT_ORDER];
            break;
        case GPKG_CT_AUTOINCREMENT:
            order = [NSNumber numberWithInt:AUTOINCREMENT_CONSTRAINT_ORDER];
            break;
        default:
            break;
    }
    
    [constraint setOrder:order];
}

-(void) addConstraintSql: (NSString *) constraint{
    [self addConstraint:[[GPKGRawConstraint alloc] initWithSql:constraint]];
}

-(void) addConstraintType: (GPKGConstraintType) type withSql: (NSString *) constraint{
    [self addConstraintType:type withOrder:nil andSql:constraint];
}

-(void) addConstraintType: (GPKGConstraintType) type withOrder: (NSNumber *) order andSql: (NSString *) constraint{
    [self addConstraint:[[GPKGRawConstraint alloc] initWithType:type andOrder:order andSql:constraint]];
}

-(void) addConstraintType: (GPKGConstraintType) type withOrderInt: (int) order andSql: (NSString *) constraint{
    [self addConstraintType:type withOrder:[NSNumber numberWithInt:order] andSql:constraint];
}

-(void) addConstraintsArray: (NSArray<GPKGConstraint *> *) constraints{
    for (GPKGConstraint *constraint in constraints) {
        [self addConstraint:constraint];
    }
}

-(void) addColumnConstraints: (GPKGColumnConstraints *) constraints{
    [self addConstraints:constraints.constraints];
}

-(void) addConstraints: (GPKGConstraints *) constraints{
    [self addConstraintsArray:[constraints all]];
}

-(void) addNotNullConstraint{
    [self addConstraintType:GPKG_CT_NOT_NULL withOrderInt:NOT_NULL_CONSTRAINT_ORDER andSql:@"NOT NULL"];
}

-(void) removeNotNullConstraint{
    [self clearConstraintsOfType:GPKG_CT_NOT_NULL];
}

-(void) addDefaultValueConstraint: (NSObject *) defaultValue{
    [self addConstraintType:GPKG_CT_DEFAULT withOrderInt:DEFAULT_VALUE_CONSTRAINT_ORDER andSql:[NSString stringWithFormat:@"DEFAULT %@", [GPKGSqlUtils columnDefaultValue:defaultValue withType:[self dataType]]]];
}

-(void) removeDefaultValueConstraint{
    [self clearConstraintsOfType:GPKG_CT_DEFAULT];
}

-(void) addPrimaryKeyConstraint{
    [self addConstraintType:GPKG_CT_PRIMARY_KEY withOrderInt:PRIMARY_KEY_CONSTRAINT_ORDER andSql:@"PRIMARY KEY"];
}

-(void) removePrimaryKeyConstraint{
    [self clearConstraintsOfType:GPKG_CT_PRIMARY_KEY];
}

-(void) addAutoincrementConstraint{
    [self addConstraintType:GPKG_CT_AUTOINCREMENT withOrderInt:AUTOINCREMENT_CONSTRAINT_ORDER andSql:@"AUTOINCREMENT"];
}

-(void) removeAutoincrementConstraint{
    [self clearConstraintsOfType:GPKG_CT_AUTOINCREMENT];
}

-(void) addUniqueConstraint{
    [self addConstraintType:GPKG_CT_UNIQUE withOrderInt:UNIQUE_CONSTRAINT_ORDER andSql:@"UNIQUE"];
}

-(void) removeUniqueConstraint{
    [self clearConstraintsOfType:GPKG_CT_UNIQUE];
}

-(NSString *) buildConstraintSql: (GPKGConstraint *) constraint{
    NSString *sql = nil;
    if(DEFAULT_PK_NOT_NULL || !self.primaryKey || constraint.type != GPKG_CT_NOT_NULL){
        sql = [constraint buildSql];
    }
    return sql;
}

-(BOOL) hasSchema{
    return _schema != nil;
}

-(void) validateMax{
    
    if(self.max != nil){
        if((int)self.dataType < 0){
            NSLog(@"Column max set on a column without a data type. column: %@, max: %@", self.name, self.max);
        }else if(self.dataType != GPKG_DT_TEXT && self.dataType != GPKG_DT_BLOB){
            [NSException raise:@"Illegal State" format:@"Column max is only supported for TEXT and BLOB columns. column: %@, max: %@, type: %@", self.name, self.max, [GPKGDataTypes name:self.dataType]];
        }
    }
    
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    GPKGUserColumn *userColumn = [[[self class] allocWithZone:zone] initWithUserColumn:self];
    return userColumn;
}

@end

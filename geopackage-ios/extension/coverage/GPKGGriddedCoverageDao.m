//
//  GPKGGriddedCoverageDao.m
//  geopackage-ios
//
//  Created by Brian Osborn on 11/10/16.
//  Copyright © 2016 NGA. All rights reserved.
//

#import "GPKGGriddedCoverageDao.h"
#import "GPKGTileMatrixSetDao.h"
#import "GPKGUtils.h"

@implementation GPKGGriddedCoverageDao

+(GPKGGriddedCoverageDao *) createWithDatabase: (GPKGConnection *) database{
    return [[GPKGGriddedCoverageDao alloc] initWithDatabase:database];
}

-(instancetype) initWithDatabase: (GPKGConnection *) database{
    self = [super initWithDatabase:database];
    if(self != nil){
        self.tableName = GPKG_CDGC_TABLE_NAME;
        self.idColumns = @[GPKG_CDGC_COLUMN_PK];
        self.autoIncrementId = YES;
        self.columnNames = @[GPKG_CDGC_COLUMN_ID, GPKG_CDGC_COLUMN_TILE_MATRIX_SET_NAME, GPKG_CDGC_COLUMN_DATATYPE, GPKG_CDGC_COLUMN_SCALE, GPKG_CDGC_COLUMN_OFFSET, GPKG_CDGC_COLUMN_PRECISION, GPKG_CDGC_COLUMN_DATA_NULL, GPKG_CDGC_COLUMN_GRID_CELL_ENCODING, GPKG_CDGC_COLUMN_UOM, GPKG_CDGC_COLUMN_FIELD_NAME, GPKG_CDGC_COLUMN_QUANTITY_DEFINITION];
        [self initializeColumnIndex];
    }
    return self;
}

-(NSObject *) createObject{
    return [[GPKGGriddedCoverage alloc] init];
}

-(void) setValueInObject: (NSObject*) object withColumnIndex: (int) columnIndex withValue: (NSObject *) value{
    
    GPKGGriddedCoverage *setObject = (GPKGGriddedCoverage*) object;
    
    switch(columnIndex){
        case 0:
            setObject.id = (NSNumber *) value;
            break;
        case 1:
            setObject.tileMatrixSetName = (NSString *) value;
            break;
        case 2:
            setObject.datatype = (NSString *) value;
            break;
        case 3:
            setObject.scale = [GPKGUtils decimalNumberFromNumber:(NSNumber *) value];
            break;
        case 4:
            setObject.offset = [GPKGUtils decimalNumberFromNumber:(NSNumber *) value];
            break;
        case 5:
            setObject.precision = [GPKGUtils decimalNumberFromNumber:(NSNumber *) value];
            break;
        case 6:
            setObject.dataNull = [GPKGUtils decimalNumberFromNumber:(NSNumber *) value];
            break;
        case 7:
            setObject.gridCellEncoding = (NSString *) value;
            break;
        case 8:
            setObject.uom = (NSString *) value;
            break;
        case 9:
            setObject.fieldName = (NSString *) value;
            break;
        case 10:
            setObject.quantityDefinition = (NSString *) value;
            break;
        default:
            [NSException raise:@"Illegal Column Index" format:@"Unsupported column index: %d", columnIndex];
            break;
    }
    
}

-(NSObject *) valueFromObject: (NSObject*) object withColumnIndex: (int) columnIndex{
    
    NSObject * value = nil;
    
    GPKGGriddedCoverage *griddedCoverage = (GPKGGriddedCoverage*) object;
    
    switch(columnIndex){
        case 0:
            value = griddedCoverage.id;
            break;
        case 1:
            value = griddedCoverage.tileMatrixSetName;
            break;
        case 2:
            value = griddedCoverage.datatype;
            break;
        case 3:
            value = griddedCoverage.scale;
            break;
        case 4:
            value = griddedCoverage.offset;
            break;
        case 5:
            value = griddedCoverage.precision;
            break;
        case 6:
            value = griddedCoverage.dataNull;
            break;
        case 7:
            value = griddedCoverage.gridCellEncoding;
            break;
        case 8:
            value = griddedCoverage.uom;
            break;
        case 9:
            value = griddedCoverage.fieldName;
            break;
        case 10:
            value = griddedCoverage.quantityDefinition;
            break;
        default:
            [NSException raise:@"Illegal Column Index" format:@"Unsupported column index: %d", columnIndex];
            break;
    }
    
    return value;
}

-(long long) insert: (NSObject *) object{
    long long id = [super insert:object];
    [self setId:object withIdValue:[NSNumber numberWithLongLong:id]];
    return id;
}

-(GPKGGriddedCoverage *) queryByTileMatrixSet: (GPKGTileMatrixSet *) tileMatrixSet{
    return [self queryByTileMatrixSetName:tileMatrixSet.tableName];
}

-(GPKGGriddedCoverage *) queryByTileMatrixSetName: (NSString *) tileMatrixSetName{
    GPKGResultSet * results = [self queryForEqWithField:GPKG_CDGC_COLUMN_TILE_MATRIX_SET_NAME andValue:tileMatrixSetName];
    GPKGGriddedCoverage * griddedCoverage = (GPKGGriddedCoverage *)[self firstObject:results];
    return griddedCoverage;
}

-(int) deleteByTileMatrixSet: (GPKGTileMatrixSet *) tileMatrixSet{
    return [self deleteByTableName:tileMatrixSet.tableName];
}

-(int) deleteByTableName: (NSString *) tableName{
    NSString * where = [self buildWhereWithField:GPKG_CDGC_COLUMN_TILE_MATRIX_SET_NAME andValue:tableName];
    NSArray * whereArgs = [self buildWhereArgsWithValue:tableName];
    int count = [self deleteWhere:where andWhereArgs:whereArgs];
    return count;
}

-(GPKGTileMatrixSet *) tileMatrixSet: (GPKGGriddedCoverage *) griddedCoverage{
    GPKGTileMatrixSetDao * dao = [self tileMatrixSetDao];
    GPKGTileMatrixSet *tileMatrixSet = (GPKGTileMatrixSet *)[dao queryForIdObject:griddedCoverage.tileMatrixSetName];
    return tileMatrixSet;
}

-(GPKGTileMatrixSetDao *) tileMatrixSetDao{
    return [[GPKGTileMatrixSetDao alloc] initWithDatabase:self.database];
}

@end

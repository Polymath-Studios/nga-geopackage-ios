//
//  GPKGGeoPackage.m
//  geopackage-ios
//
//  Created by Brian Osborn on 5/8/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "GPKGGeoPackage.h"
#import "GPKGGeometryColumnsDao.h"
#import "GPKGFeatureTableReader.h"
#import "GPKGTileTableReader.h"
#import "GPKGUtils.h"
#import "GPKGGeoPackageExtensions.h"
#import "GPKGCrsWktExtension.h"
#import "GPKGSchemaExtension.h"
#import "GPKGMetadataExtension.h"
#import "GPKGSqlUtils.h"
#import "GPKGAttributesTableReader.h"
#import "GPKGRTreeIndexExtension.h"
#import "GPKGFeatureIndexManager.h"
#import "GPKGAlterTable.h"
#import "GPKGUserCustomTableReader.h"

@interface GPKGGeoPackage()

@property (nonatomic, strong) GPKGGeoPackageTableCreator *tableCreator;

@end

@implementation GPKGGeoPackage

-(instancetype) initWithConnection: (GPKGConnection *) database andWritable: (BOOL) writable andMetadataDb: (GPKGMetadataDb *) metadataDb{
    self = [super init];
    if(self != nil){
        self.database = database;
        self.name = database.name;
        self.path = database.filename;
        self.writable = writable;
        self.metadataDb = metadataDb;
        self.tableCreator = [[GPKGGeoPackageTableCreator alloc] initWithDatabase:database];
    }
    return self;
}

-(void) close{
    [self.database close];
}

-(GPKGGeoPackageTableCreator *) tableCreator{
    return _tableCreator;
}

-(NSString *) applicationId{
    return [self.database applicationId];
}

-(NSNumber *) applicationIdNumber{
    return [self.database applicationIdNumber];
}

-(NSString *) applicationIdHex{
    return [self.database applicationIdHex];
}

-(NSNumber *) userVersion{
    return [self.database userVersion];
}

-(NSNumber *) userVersionMajor{
    return [self.database userVersionMajor];
}

-(NSNumber *) userVersionMinor{
    return [self.database userVersionMinor];
}

-(NSNumber *) userVersionPatch{
    return [self.database userVersionPatch];
}

-(NSArray<NSString *> *) featureTables{
    return [self tablesByType:GPKG_CDT_FEATURES];
}

-(NSArray<NSString *> *) tileTables{
    return [self tablesByType:GPKG_CDT_TILES];
}

-(NSArray<NSString *> *) attributesTables{
    return [self tablesByType:GPKG_CDT_ATTRIBUTES];
}

-(NSArray<NSString *> *) tablesByType: (enum GPKGContentsDataType) type{
    return [self tablesByTypeName:[GPKGContentsDataTypes name:type]];
}

-(NSArray<NSString *> *) tablesByTypes: (NSArray *) types{
    // TODO
}

-(NSArray<NSString *> *) tablesByTypeName: (NSString *) type{
    GPKGContentsDao * contentsDao = [self contentsDao];
    return [contentsDao tablesOfTypeName:type];
}

-(NSArray<NSString *> *) tablesByTypeNames: (NSArray<NSString *> *) types{
    // TODO
}

-(NSArray<GPKGContents *> *) contentsByType: (enum GPKGContentsDataType) type{
    // TODO
}

-(NSArray<GPKGContents *> *) contentsByTypes: (NSArray *) types{
    // TODO
}

-(NSArray<GPKGContents *> *) contentsByTypeName: (NSString *) type{
    // TODO
}

-(NSArray<GPKGContents *> *) contentsByTypeNames: (NSArray<NSString *> *) types{
    // TODO
}

-(NSArray<NSString *> *) tables{
    GPKGContentsDao *contentsDao = [self contentsDao];
    NSArray *tableNames = [contentsDao tables];
    return tableNames;
}

-(BOOL) isFeatureTable: (NSString *) table{
    return [self isTable:table ofType:GPKG_CDT_FEATURES];
}

-(BOOL) isTileTable: (NSString *) table{
    return [self isTable:table ofType:GPKG_CDT_TILES];
}

-(BOOL) isAttributeTable: (NSString *) table{
    return [self isTable:table ofType:GPKG_CDT_ATTRIBUTES];
}

-(BOOL) isTable: (NSString *) table ofType: (enum GPKGContentsDataType) type{
    return [self isTable:table ofTypeName:[GPKGContentsDataTypes name:type]];
}

-(BOOL) isTable: (NSString *) table ofTypes: (NSArray<NSNumber *> *) types{
    // TODO
}

-(BOOL) isTable: (NSString *) table ofTypeName: (NSString *) type{
    return [type isEqualToString:[self typeOfTable:table]];
}

-(BOOL) isTable: (NSString *) table ofTypeNames: (NSArray<NSString *> *) types{
    // TODO
}

-(BOOL) isContentsTable: (NSString *) table{
    return [self contentsOfTable:table] != nil;
}

-(BOOL) isTable: (NSString *) table{
    return [self.database tableExists:table];
}

-(BOOL) isView: (NSString *) view{
    // TODO
}

-(BOOL) isTableOrView: (NSString *) name{
    // TODO
}

-(GPKGContents *) contentsOfTable: (NSString *) table{
    GPKGContentsDao *contentsDao = [self contentsDao];
    GPKGContents *contents = (GPKGContents *)[contentsDao queryForIdObject:table];
    return contents;
}

-(NSString *) typeOfTable: (NSString *) table{
    NSString *tableType = nil;
    GPKGContents *contents = [self contentsOfTable:table];
    if(contents != nil){
        tableType = contents.dataType;
    }
    return tableType;
}

-(enum GPKGContentsDataType) dataTypeOfTable: (NSString *) table{
    enum GPKGContentsDataType tableType = -1;
    GPKGContents *contents = [self contentsOfTable:table];
    if(contents != nil){
        tableType = [contents contentsDataType];
    }
    return tableType;
}

-(int) featureTableCount{
    int count = 0;
    GPKGGeometryColumnsDao *dao = [self geometryColumnsDao];
    if([dao tableExists]){
        count = [dao count];
    }
    return count;
}

-(int) tileTableCount{
    int count = 0;
    GPKGTileMatrixSetDao *dao = [self tileMatrixSetDao];
    if([dao tableExists]){
        count = [dao count];
    }
    return count;
}

-(int) tableCount{
    int count = [self featureTableCount] + [self tileTableCount];
    return count;
}

-(GPKGBoundingBox *) contentsBoundingBoxInProjection: (SFPProjection *) projection{
    GPKGContentsDao *contentsDao = [self contentsDao];
    GPKGBoundingBox *boundingBox = [contentsDao boundingBoxInProjection:projection];
    return boundingBox;
}

-(GPKGBoundingBox *) boundingBoxInProjection: (SFPProjection *) projection{
    return [self boundingBoxInProjection:projection andManual:NO];
}

-(GPKGBoundingBox *) boundingBoxInProjection: (SFPProjection *) projection andManual: (BOOL) manual{
    
    GPKGBoundingBox *boundingBox = [self contentsBoundingBoxInProjection:projection];
    
    NSArray<NSString *> *tables = [self tables];
    for(NSString *table in tables){
        GPKGBoundingBox *tableBoundingBox = [self boundingBoxOfTable:table inProjection:projection andManual:manual];
        
        if(tableBoundingBox != nil){
            if(boundingBox != nil){
                boundingBox = [boundingBox union:tableBoundingBox];
            }else{
                boundingBox = tableBoundingBox;
            }
        }
    }
    
    return boundingBox;
}

-(GPKGBoundingBox *) tableBoundingBoxInProjection: (SFPProjection *) projection{
    // TODO
}

-(GPKGBoundingBox *) tableBoundingBoxInProjection: (SFPProjection *) projection andManual: (BOOL) manual{
    // TODO
}

-(GPKGBoundingBox *) contentsBoundingBoxOfTable: (NSString *) table{
    GPKGContentsDao *contentsDao = [self contentsDao];
    GPKGBoundingBox *boundingBox = [contentsDao boundingBoxOfTable:table];
    return boundingBox;
}

-(GPKGBoundingBox *) contentsBoundingBoxOfTable: (NSString *) table inProjection: (SFPProjection *) projection{
    GPKGContentsDao *contentsDao = [self contentsDao];
    GPKGBoundingBox *boundingBox = [contentsDao boundingBoxOfTable:table inProjection:projection];
    return boundingBox;
}

-(GPKGBoundingBox *) boundingBoxOfTable: (NSString *) table{
    return [self boundingBoxOfTable:table inProjection:nil];
}

-(GPKGBoundingBox *) boundingBoxOfTable: (NSString *) table inProjection: (SFPProjection *) projection{
    return [self boundingBoxOfTable:table inProjection:projection andManual:NO];
}

-(GPKGBoundingBox *) boundingBoxOfTable: (NSString *) table andManual: (BOOL) manual{
    return [self boundingBoxOfTable:table inProjection:nil andManual:manual];
}

-(GPKGBoundingBox *) boundingBoxOfTable: (NSString *) table inProjection: (SFPProjection *) projection andManual: (BOOL) manual{
    
    GPKGBoundingBox *boundingBox = [self contentsBoundingBoxOfTable:table inProjection:projection];
    
    GPKGBoundingBox *tableBoundingBox = nil;
    NSString *tableType = [self typeOfTable:table];
    enum GPKGContentsDataType dataType = [GPKGContentsDataTypes fromName:tableType];
    if((int)dataType >= 0){
        switch (dataType) {
            case GPKG_CDT_FEATURES:
                tableBoundingBox = [self featureBoundingBoxOfTable:table inProjection:projection andManual:manual];
                break;
            case GPKG_CDT_TILES:
            case GPKG_CDT_GRIDDED_COVERAGE:
                {
                    GPKGTileMatrixSetDao *tileMatrixSetDao = [self tileMatrixSetDao];
                    GPKGTileMatrixSet *tileMatrixSet = (GPKGTileMatrixSet *)[tileMatrixSetDao queryForIdObject:table];
                    tableBoundingBox = [tileMatrixSetDao boundingBoxOfTileMatrixSet:tileMatrixSet inProjection:projection];
                }
                break;
            default:
                break;
        }
    }
    
    if (tableBoundingBox != nil) {
        if (boundingBox == nil) {
            boundingBox = tableBoundingBox;
        } else {
            boundingBox = [boundingBox union:tableBoundingBox];
        }
    }
    
    return boundingBox;
}

-(GPKGBoundingBox *) tableBoundingBoxOfTable: (NSString *) table{
    // TODO
}

-(GPKGBoundingBox *) tableBoundingBoxOfTable: (NSString *) table inProjection: (SFPProjection *) projection{
    // TODO
}

-(GPKGBoundingBox *) tableBoundingBoxOfTable: (NSString *) table andManual: (BOOL) manual{
    // TODO
}

-(GPKGBoundingBox *) tableBoundingBoxOfTable: (NSString *) table inProjection: (SFPProjection *) projection andManual: (BOOL) manual{
    // TODO
}

-(SFPProjection *) contentsProjectionOfTable: (NSString *) table{
    // TODO
}

-(SFPProjection *) projectionOfTable: (NSString *) table{
    // TODO
}

-(GPKGBoundingBox *) featureBoundingBoxOfTable: (NSString *) table inProjection: (SFPProjection *) projection andManual: (BOOL) manual{
    
    GPKGBoundingBox *boundingBox = nil;
    
    GPKGFeatureIndexManager *indexManager = [[GPKGFeatureIndexManager alloc] initWithGeoPackage:self andFeatureTable:table];
    
    @try{
        if (manual || [indexManager isIndexed]) {
            boundingBox = [indexManager boundingBoxInProjection:projection];
        }
    }@finally{
        [indexManager close];
    }
    
    return boundingBox;
}

-(GPKGSpatialReferenceSystemDao *) spatialReferenceSystemDao{
    GPKGSpatialReferenceSystemDao * dao = [[GPKGSpatialReferenceSystemDao alloc] initWithDatabase:self.database];
    [dao setCrsWktExtension:[[GPKGCrsWktExtension alloc] initWithGeoPackage:self]];
    return dao;
}

-(GPKGContentsDao *) contentsDao{
    return [[GPKGContentsDao alloc] initWithDatabase:self.database];
}

-(GPKGGeometryColumnsDao *) geometryColumnsDao{
    // If the GeoPackage is writable and has a RTree Index
    // extension, create the SQL functions
    if(self.writable) {
        GPKGRTreeIndexExtension *rtree = [[GPKGRTreeIndexExtension alloc] initWithGeoPackage:self];
        [rtree createFunctions];
    }
    return [[GPKGGeometryColumnsDao alloc] initWithDatabase:self.database];
}

-(BOOL) createGeometryColumnsTable{
    [self verifyWritable];
    
    BOOL created = false;
    GPKGGeometryColumnsDao * dao = [self geometryColumnsDao];
    if(![dao tableExists]){
        created = [self.tableCreator createGeometryColumns] > 0;
    }
    
    return created;
}

-(void) createFeatureTable: (GPKGFeatureTable *) table{
    [self createUserTable:table];
}

-(GPKGFeatureTable *) createFeatureTableWithMetadata: (GPKGFeatureTableMetadata *) metadata{
    // TODO and delete following methods
}

-(GPKGGeometryColumns *) createFeatureTableWithGeometryColumns: (GPKGGeometryColumns *) geometryColumns
                                                andBoundingBox: (GPKGBoundingBox *) boundingBox
                                                      andSrsId: (NSNumber *) srsId{
    return [self createFeatureTableWithGeometryColumns:geometryColumns andIdColumnName:nil andAdditionalColumns:nil andBoundingBox:boundingBox andSrsId:srsId];
}

-(GPKGGeometryColumns *) createFeatureTableWithGeometryColumns: (GPKGGeometryColumns *) geometryColumns
                                               andIdColumnName: (NSString *) idColumnName
                                                andBoundingBox: (GPKGBoundingBox *) boundingBox
                                                      andSrsId: (NSNumber *) srsId{
    return [self createFeatureTableWithGeometryColumns:geometryColumns andIdColumnName:idColumnName andAdditionalColumns:nil andBoundingBox:boundingBox andSrsId:srsId];
}

-(GPKGGeometryColumns *) createFeatureTableWithGeometryColumns: (GPKGGeometryColumns *) geometryColumns
                                          andAdditionalColumns: (NSArray *) additionalColumns
                                                andBoundingBox: (GPKGBoundingBox *) boundingBox
                                                      andSrsId: (NSNumber *) srsId{
    return [self createFeatureTableWithGeometryColumns:geometryColumns andIdColumnName:nil andAdditionalColumns:additionalColumns andBoundingBox:boundingBox andSrsId:srsId];
}

-(GPKGGeometryColumns *) createFeatureTableWithGeometryColumns: (GPKGGeometryColumns *) geometryColumns
                                               andIdColumnName: (NSString *) idColumnName
                                          andAdditionalColumns: (NSArray *) additionalColumns
                                                andBoundingBox: (GPKGBoundingBox *) boundingBox
                                                      andSrsId: (NSNumber *) srsId{
    
    if(idColumnName == nil){
        idColumnName = @"id";
    }
    
    NSMutableArray * columns = [[NSMutableArray alloc] init];
    [columns addObject:[GPKGFeatureColumn createPrimaryKeyColumnWithName:idColumnName]];
    [columns addObject:[GPKGFeatureColumn createGeometryColumnWithName:geometryColumns.columnName
                                                        andGeometryType:[geometryColumns geometryType]]];
    
    if(additionalColumns != nil){
        [columns addObjectsFromArray:additionalColumns];
    }
    
    return [self createFeatureTableWithGeometryColumns:geometryColumns andBoundingBox:boundingBox andSrsId:srsId andColumns:columns];
}

-(GPKGGeometryColumns *) createFeatureTableWithGeometryColumns: (GPKGGeometryColumns *) geometryColumns
                                                andBoundingBox: (GPKGBoundingBox *) boundingBox
                                                      andSrsId: (NSNumber *) srsId
                                                    andColumns: (NSArray *) columns{
    
    // Get the SRS
    GPKGSpatialReferenceSystem * srs = [self srs:srsId];
    
    // Create the Geometry Columns table
    [self createGeometryColumnsTable];
    
    // Create the user feature table
    GPKGFeatureTable * table = [[GPKGFeatureTable alloc] initWithGeometryColumns:geometryColumns andColumns:columns];
    [self createFeatureTable:table];
    
    @try {
        // Create the contents
        GPKGContents * contents = [[GPKGContents alloc] init];
        [contents setTableName:geometryColumns.tableName];
        [contents setDataType:GPKG_CDT_FEATURES_NAME];
        [contents setIdentifier:geometryColumns.tableName];
        // [contents setLastChange:[NSDate date]];
        if(boundingBox != nil){
            [contents setMinX:boundingBox.minLongitude];
            [contents setMinY:boundingBox.minLatitude];
            [contents setMaxX:boundingBox.maxLongitude];
            [contents setMaxY:boundingBox.maxLatitude];
        }
        [contents setSrs:srs];
        [[self contentsDao] create:contents];
        
        [table setContents:contents];
        
        // Create new geometry columns
        [geometryColumns setContents:contents];
        [geometryColumns setSrs:srs];
        [[self geometryColumnsDao] create:geometryColumns];
    }
    @catch (NSException *e) {
        [self deleteTableQuietly:geometryColumns.tableName];
        @throw e;
    }
    
    return geometryColumns;
}

-(GPKGTileMatrixSetDao *) tileMatrixSetDao{
    return [[GPKGTileMatrixSetDao alloc] initWithDatabase:self.database];
}

-(BOOL) createTileMatrixSetTable{
    [self verifyWritable];
    
    BOOL created = false;
    GPKGTileMatrixSetDao * dao = [self tileMatrixSetDao];
    if(![dao tableExists]){
        created = [self.tableCreator createTileMatrixSet] > 0;
    }
    
    return created;
}

-(GPKGTileMatrixDao *) tileMatrixDao{
    return [[GPKGTileMatrixDao alloc] initWithDatabase:self.database];
}

-(BOOL) createTileMatrixTable{
    [self verifyWritable];
    
    BOOL created = false;
    GPKGTileMatrixDao * dao = [self tileMatrixDao];
    if(![dao tableExists]){
        created = [self.tableCreator createTileMatrix] > 0;
    }
    
    return created;
}

-(void) createTileTable: (GPKGTileTable *) table{
    [self createUserTable:table];
}

-(GPKGTileTable *) createTileTableWithMetadata: (GPKGTileTableMetadata *) metadata{
    // TODO and delete following methods
}

-(GPKGTileMatrixSet *) createTileTableWithTableName: (NSString *) tableName
                             andContentsBoundingBox: (GPKGBoundingBox *) contentsBoundingBox
                                   andContentsSrsId: (NSNumber *) contentsSrsId
                        andTileMatrixSetBoundingBox: (GPKGBoundingBox *) tileMatrixSetBoundingBox
                              andTileMatrixSetSrsId: (NSNumber *) tileMatrixSetSrsId{
    return [self createTileTableWithType:GPKG_CDT_TILES andTableName:tableName andContentsBoundingBox:contentsBoundingBox andContentsSrsId:contentsSrsId andTileMatrixSetBoundingBox:tileMatrixSetBoundingBox andTileMatrixSetSrsId:tileMatrixSetSrsId];
}

-(GPKGTileMatrixSet *) createTileTableWithType: (enum GPKGContentsDataType) type
                                  andTableName: (NSString *) tableName
                        andContentsBoundingBox: (GPKGBoundingBox *) contentsBoundingBox
                              andContentsSrsId: (NSNumber *) contentsSrsId
                   andTileMatrixSetBoundingBox: (GPKGBoundingBox *) tileMatrixSetBoundingBox
                         andTileMatrixSetSrsId: (NSNumber *) tileMatrixSetSrsId{
    
    GPKGTileMatrixSet * tileMatrixSet = nil;
    
    // Get the SRS
    GPKGSpatialReferenceSystem * contentsSrs = [self srs:contentsSrsId];
    GPKGSpatialReferenceSystem * tileMatrixSetSrs = [self srs:tileMatrixSetSrsId];
    
    // Create the Tile Matrix Set and Tile Matrix tables
    [self createTileMatrixSetTable];
    [self createTileMatrixTable];
    
    // Create the user tile table
    NSArray * columns = [GPKGTileTable createRequiredColumns];
    GPKGTileTable * table = [[GPKGTileTable alloc] initWithTable:tableName andColumns:columns];
    [self createTileTable:table];
    
    @try {
        // Create the contents
        GPKGContents * contents = [[GPKGContents alloc] init];
        [contents setTableName:tableName];
        [contents setContentsDataType:type];
        [contents setIdentifier:tableName];
        // [contents setLastChange:[NSDate date]];
        [contents setMinX:contentsBoundingBox.minLongitude];
        [contents setMinY:contentsBoundingBox.minLatitude];
        [contents setMaxX:contentsBoundingBox.maxLongitude];
        [contents setMaxY:contentsBoundingBox.maxLatitude];
        [contents setSrs:contentsSrs];
        [[self contentsDao] create:contents];
        
        [table setContents:contents];
        
        // Create new matrix tile set
        tileMatrixSet = [[GPKGTileMatrixSet alloc] init];
        [tileMatrixSet setContents:contents];
        [tileMatrixSet setSrs:tileMatrixSetSrs];
        [tileMatrixSet setMinX:tileMatrixSetBoundingBox.minLongitude];
        [tileMatrixSet setMinY:tileMatrixSetBoundingBox.minLatitude];
        [tileMatrixSet setMaxX:tileMatrixSetBoundingBox.maxLongitude];
        [tileMatrixSet setMaxY:tileMatrixSetBoundingBox.maxLatitude];
        [[self tileMatrixSetDao] create:tileMatrixSet];
    }
    @catch (NSException *e) {
        [self deleteTableQuietly:tableName];
        @throw e;
    }
    
    return tileMatrixSet;
}

-(void) createAttributesTable: (GPKGAttributesTable *) table{
    [self createUserTable:table];
}

-(GPKGAttributesTable *) createAttributesTableWithMetadata: (GPKGAttributesTableMetadata *) metadata{
    // TODO and delete following methods
}

-(GPKGAttributesTable *) createAttributesTableWithTableName: (NSString *) tableName
                                       andAdditionalColumns: (NSArray *) additionalColumns{
    return [self createAttributesTableWithTableName:tableName andIdColumnName:nil andAdditionalColumns:additionalColumns];
}

-(GPKGAttributesTable *) createAttributesTableWithTableName: (NSString *) tableName
                                       andAdditionalColumns: (NSArray *) additionalColumns
                                       andConstraints: (NSArray<GPKGConstraint *> *) constraints{
    return [self createAttributesTableWithTableName:tableName andIdColumnName:nil andAdditionalColumns:additionalColumns andConstraints:constraints];
}

-(GPKGAttributesTable *) createAttributesTableWithTableName: (NSString *) tableName
                                            andIdColumnName: (NSString *) idColumnName
                                       andAdditionalColumns: (NSArray *) additionalColumns{
    return [self createAttributesTableWithTableName:tableName andIdColumnName:idColumnName andAdditionalColumns:additionalColumns andConstraints:nil];
}

-(GPKGAttributesTable *) createAttributesTableWithTableName: (NSString *) tableName
                                            andIdColumnName: (NSString *) idColumnName
                                       andAdditionalColumns: (NSArray *) additionalColumns
                                       andConstraints: (NSArray<GPKGConstraint *> *) constraints{
    
    if(idColumnName == nil){
        idColumnName = @"id";
    }
    
    NSMutableArray * columns = [[NSMutableArray alloc] init];
    [columns addObject:[GPKGFeatureColumn createPrimaryKeyColumnWithName:idColumnName]];
    
    if(additionalColumns != nil){
        [columns addObjectsFromArray:additionalColumns];
    }
    
    return [self createAttributesTableWithTableName:tableName andColumns:columns andConstraints:constraints];
}

-(GPKGAttributesTable *) createAttributesTableWithTableName: (NSString *) tableName
                                                 andColumns: (NSArray *) columns{
    return [self createAttributesTableWithTableName:tableName andColumns:columns andConstraints:nil];
}
    
-(GPKGAttributesTable *) createAttributesTableWithTableName: (NSString *) tableName
                                                 andColumns: (NSArray *) columns
                                       andConstraints: (NSArray<GPKGConstraint *> *) constraints{
    
    // Build the user attributes table
    GPKGAttributesTable * table = [[GPKGAttributesTable alloc] initWithTable:tableName andColumns:columns];
    
    // Add constraints
    if(constraints != nil){
        [table addConstraints:constraints];
    }
    
    // Create the user attributes table
    [self createAttributesTable:table];
    
    @try {
        
        // Create the contents
        GPKGContents * contents = [[GPKGContents alloc] init];
        [contents setTableName:tableName];
        [contents setDataType:GPKG_CDT_ATTRIBUTES_NAME];
        [contents setIdentifier:tableName];
        // [contents setLastChange:[NSDate date]];
        [[self contentsDao] create:contents];
        
        [table setContents:contents];
    }
    @catch (NSException *e) {
        [self deleteTableQuietly:tableName];
        @throw e;
    }
    
    return table;
}

-(GPKGDataColumnsDao *) dataColumnsDao{
    return [[GPKGDataColumnsDao alloc] initWithDatabase:self.database];
}

-(BOOL) createDataColumnsTable{
    [self verifyWritable];
    
    BOOL created = false;
    GPKGDataColumnsDao * dao = [self dataColumnsDao];
    if(![dao tableExists]){
        created = [self.tableCreator createDataColumns] > 0;
    }
    
    return created;
}

-(GPKGDataColumnConstraintsDao *) dataColumnConstraintsDao{
    return [[GPKGDataColumnConstraintsDao alloc] initWithDatabase:self.database];
}

-(BOOL) createDataColumnConstraintsTable{
    [self verifyWritable];
    
    BOOL created = false;
    GPKGDataColumnConstraintsDao * dao = [self dataColumnConstraintsDao];
    if(![dao tableExists]){
        created = [self.tableCreator createDataColumnConstraints] > 0;
        if(created){
            GPKGSchemaExtension * schemaExtension = [[GPKGSchemaExtension alloc] initWithGeoPackage:self];
            [schemaExtension extensionCreate];
        }
    }
    
    return created;
}

-(GPKGMetadataDao *) metadataDao{
    return [[GPKGMetadataDao alloc] initWithDatabase:self.database];
}

-(BOOL) createMetadataTable{
    [self verifyWritable];
    
    BOOL created = false;
    GPKGMetadataDao * dao = [self metadataDao];
    if(![dao tableExists]){
        created = [self.tableCreator createMetadata] > 0;
        if(created){
            GPKGMetadataExtension * metadataExtension = [[GPKGMetadataExtension alloc] initWithGeoPackage:self];
            [metadataExtension extensionCreate];
        }
    }
    
    return created;
}

-(GPKGMetadataReferenceDao *) metadataReferenceDao{
    return [[GPKGMetadataReferenceDao alloc] initWithDatabase:self.database];
}

-(BOOL) createMetadataReferenceTable{
    [self verifyWritable];
    
    BOOL created = false;
    GPKGMetadataReferenceDao * dao = [self metadataReferenceDao];
    if(![dao tableExists]){
        created = [self.tableCreator createMetadataReference] > 0;
    }
    
    return created;
}

-(GPKGExtensionsDao *) extensionsDao{
    return [[GPKGExtensionsDao alloc] initWithDatabase:self.database];
}

-(BOOL) createExtensionsTable{
    [self verifyWritable];
    
    BOOL created = false;
    GPKGExtensionsDao * dao = [self extensionsDao];
    if(![dao tableExists]){
        created = [self.tableCreator createExtensions] > 0;
    }
    
    return created;
}

-(void) deleteTable: (NSString *) tableName{
    [self verifyWritable];
    
    [GPKGGeoPackageExtensions deleteTableExtensionsWithGeoPackage:self andTable:tableName];
    
    GPKGContentsDao * contentsDao = [self contentsDao];
    [contentsDao deleteTable:tableName];
}

-(void) deleteTableQuietly: (NSString *) tableName{
    [self verifyWritable];
    
    @try{
        [self deleteTable:tableName];
    }@catch(NSException * e){
        // eat
    }
}

-(GPKGTableIndexDao *) tableIndexDao{
    return [[GPKGTableIndexDao alloc] initWithDatabase:self.database];
}

-(BOOL) createTableIndexTable{
    [self verifyWritable];
    
    BOOL created = false;
    GPKGTableIndexDao * dao = [self tableIndexDao];
    if(![dao tableExists]){
        created = [self.tableCreator createTableIndex] > 0;
    }
    
    return created;
}

-(GPKGGeometryIndexDao *) geometryIndexDao{
    return [[GPKGGeometryIndexDao alloc] initWithDatabase:self.database];
}

-(BOOL) createGeometryIndexTable{
    [self verifyWritable];
    
    BOOL created = false;
    GPKGGeometryIndexDao * dao = [self geometryIndexDao];
    if(![dao tableExists]){
        created = [self.tableCreator createGeometryIndex] > 0;
    }
    
    return created;
}

-(BOOL) indexGeometryIndexTable{
    [self verifyWritable];
    
    BOOL indexed = NO;
    GPKGGeometryIndexDao *dao = [self geometryIndexDao];
    if([dao tableExists]){
        indexed = [self.tableCreator indexGeometryIndex] > 0;
    }
    return indexed;
}

-(BOOL) unindexGeometryIndexTable{
    [self verifyWritable];
    
    BOOL unindexed = NO;
    GPKGGeometryIndexDao *dao = [self geometryIndexDao];
    if([dao tableExists]){
        unindexed = [self.tableCreator unindexGeometryIndex] > 0;
    }
    return unindexed;
}

-(GPKGFeatureTileLinkDao *) featureTileLinkDao{
    return [[GPKGFeatureTileLinkDao alloc] initWithDatabase:self.database];
}

-(BOOL) createFeatureTileLinkTable{
    [self verifyWritable];
    
    BOOL created = false;
    GPKGFeatureTileLinkDao * dao = [self featureTileLinkDao];
    if(![dao tableExists]){
        created = [self.tableCreator createFeatureTileLink] > 0;
    }
    
    return created;
}

-(void) verifyWritable{
    if(!self.writable){
        [NSException raise:@"Read Only" format:@"GeoPackage file is not writable. Name: %@%@", self.name, (self.path != nil ? [NSString stringWithFormat:@", Path: %@", self.path] : @"")];
    }
}

-(GPKGFeatureDao *) featureDaoWithGeometryColumns: (GPKGGeometryColumns *) geometryColumns{
    if(geometryColumns == nil){
        [NSException raise:@"Illegal Argument" format:@"Non null Geometry Columns is required to create Feature DAO"];
    }
    
    // Read the existing table and create the dao
    GPKGFeatureTableReader * tableReader = [[GPKGFeatureTableReader alloc] initWithGeometryColumns:geometryColumns];
    GPKGFeatureTable * featureTable = [tableReader readFeatureTableWithConnection:self.database];
    [featureTable setContents:[[self geometryColumnsDao] contents:geometryColumns]];
    GPKGFeatureDao * dao = [[GPKGFeatureDao alloc] initWithDatabase:self.database andTable:featureTable andGeometryColumns:geometryColumns andMetadataDb:self.metadataDb];
    
    // If the GeoPackage is writable and the feature table has a RTree Index
    // extension, create the SQL functions
    if(self.writable) {
        GPKGRTreeIndexExtension *rtree = [[GPKGRTreeIndexExtension alloc] initWithGeoPackage:self];
        [rtree createFunctionsWithFeatureTable:featureTable];
    }
    
    return dao;
}

-(GPKGFeatureDao *) featureDaoWithContents: (GPKGContents *) contents{
    if(contents == nil){
        [NSException raise:@"Illegal Argument" format:@"Non null Contents is required to create Feature DAO"];
    }
    GPKGContentsDao * dao = [self contentsDao];
    GPKGGeometryColumns * geometryColumns = [dao geometryColumns:contents];
    return [self featureDaoWithGeometryColumns:geometryColumns];
}

-(GPKGFeatureDao *) featureDaoWithTableName: (NSString *) tableName{
    GPKGGeometryColumnsDao * dao = [self geometryColumnsDao];
    GPKGGeometryColumns * geometryColumns = [dao queryForTableName:tableName];
    if(geometryColumns == nil){
        [NSException raise:@"No Feature Table" format:@"No Feature Table exists for table name: %@", tableName];
    }
    return [self featureDaoWithGeometryColumns:geometryColumns];
}

-(GPKGTileDao *) tileDaoWithTileMatrixSet: (GPKGTileMatrixSet *) tileMatrixSet{
    if(tileMatrixSet == nil){
        [NSException raise:@"Illegal Argument" format:@"Non null Tile Matrix Set is required to create Tile DAO"];
    }
    
    // Get the Tile Matrix collection, order by zoom level ascending & pixel
    // size descending per requirement 51
    NSMutableArray * tileMatrices = [[NSMutableArray alloc] init];
    GPKGTileMatrixDao * tileMatrixDao = [self tileMatrixDao];
    GPKGResultSet * results = [tileMatrixDao queryForEqWithField:GPKG_TM_COLUMN_TABLE_NAME andValue:tileMatrixSet.tableName andGroupBy:nil andHaving:nil
                  andOrderBy:[NSString stringWithFormat:@"%@ ASC, %@ DESC, %@ DESC", GPKG_TM_COLUMN_ZOOM_LEVEL, GPKG_TM_COLUMN_PIXEL_X_SIZE, GPKG_TM_COLUMN_PIXEL_Y_SIZE]];
    @try{
        while([results moveToNext]){
            GPKGTileMatrix * tileMatrix = (GPKGTileMatrix *)[tileMatrixDao object:results];
            [GPKGUtils addObject:tileMatrix toArray:tileMatrices];
        }
    }@finally{
        [results close];
    }
    
    // Read the existing table and create the dao
    GPKGTileTableReader * tableReader = [[GPKGTileTableReader alloc] initWithTable:tileMatrixSet.tableName];
    GPKGTileTable * tileTable = [tableReader readTileTableWithConnection:self.database];
    [tileTable setContents:[[self tileMatrixSetDao] contents:tileMatrixSet]];
    GPKGTileDao * dao = [[GPKGTileDao alloc] initWithDatabase:self.database andTable:tileTable andTileMatrixSet:tileMatrixSet andTileMatrices:tileMatrices];
    return dao;
}

-(GPKGTileDao *) tileDaoWithContents: (GPKGContents *) contents{
    if(contents == nil){
        [NSException raise:@"Illegal Argument" format:@"Non null Contents is required to create Tile DAO"];
    }
    GPKGContentsDao * dao = [self contentsDao];
    GPKGTileMatrixSet * tileMatrixSet = [dao tileMatrixSet:contents];
    return [self tileDaoWithTileMatrixSet:tileMatrixSet];
}

-(GPKGTileDao *) tileDaoWithTableName: (NSString *) tableName{
    
    GPKGTileMatrixSetDao * dao = [self tileMatrixSetDao];
    
    GPKGTileMatrixSet *tileMatrixSet = nil;
    
    GPKGResultSet * tileMatrixSetList = nil;
    @try{
        tileMatrixSetList = [dao queryForEqWithField:GPKG_TMS_COLUMN_TABLE_NAME andValue:tableName];
        if([tileMatrixSetList moveToNext]){
            tileMatrixSet = (GPKGTileMatrixSet *)[dao object: tileMatrixSetList];
            if([tileMatrixSetList moveToNext]){
                [NSException raise:@"Multiple Tile Matrix Sets" format:@"Unexpected state. More than one Tile Matrix Set matched for table name: %@, count: %d", tableName, [tileMatrixSetList count]];
            }
        }
    }@finally{
        if(tileMatrixSetList != nil){
            [tileMatrixSetList close];
        }
    }
    
    if(tileMatrixSet == nil){
        [NSException raise:@"No Tile Matrix Set" format:@"No Tile Table exists for table name: %@", tableName];
    }
    
    return [self tileDaoWithTileMatrixSet:tileMatrixSet];
}

-(GPKGAttributesDao *) attributesDaoWithContents: (GPKGContents *) contents{
    if(contents == nil){
        [NSException raise:@"Illegal Argument" format:@"Non null Contents is required to create Attributes DAO"];
    }
    if([contents contentsDataType] != GPKG_CDT_ATTRIBUTES){
        [NSException raise:@"Illegal Argument" format:@"Contents is required to be of type Attributes. Actual: %@", contents.dataType];
    }
    
    // Read the existing table and create the dao
    GPKGAttributesTableReader * tableReader = [[GPKGAttributesTableReader alloc] initWithTable:contents.tableName];
    GPKGAttributesTable * attributesTable = [tableReader readAttributesTableWithConnection:self.database];
    [attributesTable setContents:contents];
    GPKGAttributesDao * dao = [[GPKGAttributesDao alloc] initWithDatabase:self.database andTable:attributesTable];
    
    return dao;
}

-(GPKGAttributesDao *) attributesDaoWithTableName: (NSString *) tableName{

    GPKGContentsDao * dao = [self contentsDao];
    GPKGContents * contents = (GPKGContents *)[dao queryForIdObject:tableName];
    if(contents == nil){
        [NSException raise:@"No Contents" format:@"No Contents Table entry exists for table name: %@", tableName];
    }
    return [self attributesDaoWithContents:contents];
}

-(GPKGUserCustomDao *) userCustomDaoWithTableName: (NSString *) tableName{
    GPKGUserCustomTable *table = [GPKGUserCustomTableReader readTableWithConnection:self.database andTableName:tableName];
    return [self userCustomDaoWithTable:table];
}

-(GPKGUserCustomDao *) userCustomDaoWithTable: (GPKGUserCustomTable *) table{
    return [[GPKGUserCustomDao alloc] initWithDatabase:self.database andTable:table];
}

-(void) execSQL: (NSString *) sql{
    [self.database exec:sql];
}

-(void) beginTransaction{
    [self.database beginTransaction];
}

-(void) commitTransaction{
    [self.database commitTransaction];
}

-(void) rollbackTransaction{
    [self.database rollbackTransaction];
}

-(BOOL) inTransaction{
    return [self.database inTransaction];
}

-(BOOL) enableForeignKeys{
    return [self.database enableForeignKeys];
}

-(BOOL) foreignKeys{
    return [self.database foreignKeys];
}

-(BOOL) foreignKeysAsOn: (BOOL) on{
    return [self.database foreignKeysAsOn:on];
}

-(void) dropTable: (NSString *) table{
    [self.tableCreator dropTable:table];
}

-(void) renameTable: (NSString *) tableName toTable: (NSString *) newTableName{
    if((int)[self dataTypeOfTable:tableName] != -1){
        [self copyTable:tableName toTable:newTableName];
        [self deleteTable:tableName];
    }else{
        [GPKGAlterTable renameTable:tableName toTable:newTableName withConnection:self.database];
    }
}

-(void) copyTable: (NSString *) tableName toTable: (NSString *) newTableName{
    [self copyTable:tableName toTable:newTableName andTransfer:YES andExtensions:YES];
}

-(void) copyTableNoExtensions: (NSString *) tableName toTable: (NSString *) newTableName{
    [self copyTable:tableName toTable:newTableName andTransfer:YES andExtensions:NO];
}

-(void) copyTableAsEmpty: (NSString *) tableName toTable: (NSString *) newTableName{
    [self copyTable:tableName toTable:newTableName andTransfer:NO andExtensions:NO];
}

/**
 * Copy the table
 *
 * @param tableName
 *            table name
 * @param newTableName
 *            new table name
 * @param transferContent
 *            transfer content flag
 * @param extensions
 *            extensions copy flag
 */
-(void) copyTable: (NSString *) tableName toTable: (NSString *) newTableName andTransfer: (BOOL) transferContent andExtensions: (BOOL) extensions{
    
    enum GPKGContentsDataType dataType = [self dataTypeOfTable:tableName];
    if((int)dataType != -1){
        switch(dataType){
                
            case GPKG_CDT_ATTRIBUTES:
                [self copyAttributeTable:tableName toTable:newTableName andTransfer:transferContent];
                break;
                
            case GPKG_CDT_FEATURES:
                [self copyFeatureTable:tableName toTable:newTableName andTransfer:transferContent];
                break;
                
            case GPKG_CDT_TILES:
            case GPKG_CDT_GRIDDED_COVERAGE:
                [self copyTileTable:tableName toTable:newTableName andTransfer:transferContent];
                break;
                
            default:
                [NSException raise:@"Unsupported data type" format:@"Unsupported data type: %@", [GPKGContentsDataTypes name:dataType]];
        }
    }else{
        [self copyUserTable:tableName toTable:newTableName andTransfer:transferContent andValidate:NO];
    }
    
    // Copy extensions
    if(extensions){
        [GPKGGeoPackageExtensions copyTableExtensionsWithGeoPackage:self andTable:tableName andNewTable:newTableName];
    }
    
}

/**
 * Copy the attribute table
 *
 * @param tableName
 *            table name
 * @param newTableName
 *            new table name
 * @param transferContent
 *            transfer content flag
 */
-(void) copyAttributeTable: (NSString *) tableName toTable: (NSString *) newTableName andTransfer: (BOOL) transferContent{
    [self copyUserTable:tableName toTable:newTableName andTransfer:transferContent];
}

/**
 * Copy the feature table
 *
 * @param tableName
 *            table name
 * @param newTableName
 *            new table name
 * @param transferContent
 *            transfer content flag
 */
-(void) copyFeatureTable: (NSString *) tableName toTable: (NSString *) newTableName andTransfer: (BOOL) transferContent{
    
    GPKGGeometryColumnsDao *geometryColumnsDao = [self geometryColumnsDao];
    GPKGGeometryColumns *geometryColumns = [geometryColumnsDao queryForTableName:tableName];
    if(geometryColumns == nil){
        [NSException raise:@"No Geometry Columns" format:@"No geometry columns for table: %@", tableName];
    }
    
    GPKGContents *contents = [self copyUserTable:tableName toTable:newTableName andTransfer:transferContent];
    
    [geometryColumns setContents:contents];
    [geometryColumnsDao create:geometryColumns];
}

/**
 * Copy the tile table
 *
 * @param tableName
 *            table name
 * @param newTableName
 *            new table name
 * @param transferContent
 *            transfer content flag
 */
-(void) copyTileTable: (NSString *) tableName toTable: (NSString *) newTableName andTransfer: (BOOL) transferContent{
    
    GPKGTileMatrixSetDao *tileMatrixSetDao = [self tileMatrixSetDao];
    GPKGTileMatrixSet *tileMatrixSet = (GPKGTileMatrixSet *)[tileMatrixSetDao queryForIdObject:tableName];
    if(tileMatrixSet == nil){
        [NSException raise:@"No Tile Matrix Set" format:@"No tile matrix set for table: %@", tableName];
    }
    
    GPKGContents *contents = [self copyUserTable:tableName toTable:newTableName andTransfer:transferContent];
    
    [tileMatrixSet setContents:contents];
    [tileMatrixSetDao create:tileMatrixSet];
    
    GPKGTileMatrixDao *tileMatrixDao = [self tileMatrixDao];
    GPKGResultSet *tileMatrices = [tileMatrixDao queryForEqWithField:GPKG_TM_COLUMN_TABLE_NAME andValue:tableName];
    @try{
        while([tileMatrices moveToNext]){
            GPKGTileMatrix * tileMatrix = (GPKGTileMatrix *)[tileMatrixDao object:tileMatrices];
            [tileMatrix setContents:contents];
            [tileMatrixDao create:tileMatrix];
        }
    }@finally{
        [tileMatrices close];
    }
    
}

/**
 * Copy the user table
 *
 * @param tableName
 *            table name
 * @param newTableName
 *            new table name
 * @param transferContent
 *            transfer user table content flag
 * @return copied contents
 */
-(GPKGContents *) copyUserTable: (NSString *) tableName toTable: (NSString *) newTableName andTransfer: (BOOL) transferContent{
    return [self copyUserTable:tableName toTable:newTableName andTransfer:transferContent andValidate:YES];
}

/**
 * Copy the user table
 *
 * @param tableName
 *            table name
 * @param newTableName
 *            new table name
 * @param transferContent
 *            transfer user table content flag
 * @param validateContents
 *            true to validate a contents was copied
 * @return copied contents
 */
-(GPKGContents *) copyUserTable: (NSString *) tableName toTable: (NSString *) newTableName andTransfer: (BOOL) transferContent andValidate: (BOOL) validateContents{
    
    [GPKGAlterTable copyTableName:tableName toTable:newTableName andTransfer:transferContent withConnection:self.database];
    
    GPKGContents *contents = [self copyContentsFromTable:tableName toTable:newTableName];
    
    if(contents == nil && validateContents){
        [NSException raise:@"No Table Contents" format:@"No table contents found for table: %@", tableName];
    }
    
    return contents;
}

/**
 * Copy the contents
 *
 * @param tableName
 *            table name
 * @param newTableName
 *            new table name
 * @return copied contents
 */
-(GPKGContents *) copyContentsFromTable: (NSString *) tableName toTable: (NSString *) newTableName{
    
    GPKGContents *contents = [self contentsOfTable:tableName];
    
    if(contents != nil){
        
        [contents setTableName:newTableName];
        [contents setIdentifier:newTableName];
        
        [[self contentsDao] create:contents];
        
    }
    
    return contents;
}

-(void) vacuum{
    [GPKGSqlUtils vacuumWithConnection:self.database];
}

-(GPKGResultSet *) rawQuery: (NSString *) sql andArgs: (NSArray *) args{
    return [self.database rawQuery:sql andArgs:args];
}

-(GPKGResultSet *) foreignKeyCheck{
    return [self foreignKeyCheckOnTable:nil];
}

-(GPKGResultSet *) foreignKeyCheckOnTable: (NSString *) tableName{
    GPKGResultSet *resultSet = [self rawQuery:[GPKGSqlUtils foreignKeyCheckSQLOnTable:tableName] andArgs:nil];
    if(![resultSet moveToNext]){
        [resultSet close];
        resultSet = nil;
    }
    return resultSet;
}

-(GPKGResultSet *) integrityCheck{
    return [self integrityCheck:[self rawQuery:[GPKGSqlUtils integrityCheckSQL] andArgs:nil]];
}

-(GPKGResultSet *) quickCheck{
    return [self integrityCheck:[self rawQuery:[GPKGSqlUtils quickCheckSQL] andArgs:nil]];
}

/**
 *  Check the result set returned from the integrity check to see if things are "ok"
 *
 *  @param resultSet result set
 *
 *  @return nil if ok, else the open result set
 */
-(GPKGResultSet *) integrityCheck: (GPKGResultSet *) resultSet{
    if([resultSet moveToNext]){
        NSString * value = [resultSet stringWithIndex:0];
        if([value isEqualToString:@"ok"]){
            [resultSet close];
            resultSet = nil;
        }
    }
    return resultSet;
}

-(GPKGSpatialReferenceSystem *) srs: (NSNumber *) srsId{
    GPKGSpatialReferenceSystemDao * dao = [self spatialReferenceSystemDao];
    GPKGSpatialReferenceSystem * srs = (GPKGSpatialReferenceSystem *)[dao queryForIdObject:srsId];
    if(srs == nil){
        [NSException raise:@"No SRS" format:@"Spatial Reference System could not be found. SRS ID: %@", srsId];
    }
    return srs;
}

-(void) createUserTable: (GPKGUserTable *) table{
    [self verifyWritable];
    
    [self.tableCreator createUserTable:table];
}

@end

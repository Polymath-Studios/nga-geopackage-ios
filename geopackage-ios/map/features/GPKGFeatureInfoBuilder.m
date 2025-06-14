//
//  GPKGFeatureInfoBuilder.m
//  geopackage-ios
//
//  Created by Brian Osborn on 11/1/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import <GeoPackage/GPKGFeatureInfoBuilder.h>
#import <GeoPackage/GPKGProperties.h>
#import <GeoPackage/GPKGPropertyConstants.h>
#import <SimpleFeatures/SimpleFeatures.h>
#import <GeoPackage/GPKGDataColumnsDao.h>
#import <GeoPackage/GPKGFeatureIndexListResults.h>
#import <GeoPackage/GPKGMapShapeConverter.h>
#import <GeoPackage/GPKGMapUtils.h>

@interface GPKGFeatureInfoBuilder ()

@property (nonatomic, strong) GPKGFeatureDao *featureDao;
@property (nonatomic, strong) GPKGFeatureTableStyles *featureStyles;
@property (nonatomic) SFGeometryType geometryType;
@property (nonatomic, strong) NSMutableSet<NSNumber *> *ignoreGeometryTypes;

@end

@implementation GPKGFeatureInfoBuilder

-(instancetype) initWithFeatureDao: (GPKGFeatureDao *) featureDao{
    self = [self initWithFeatureDao:featureDao andStyles:nil];
    return self;
}

-(instancetype) initWithFeatureDao: (GPKGFeatureDao *) featureDao andStyles: (GPKGFeatureTableStyles *) featureStyles{
    self = [self initWithFeatureDao:featureDao andStyles:featureStyles andGeodesic:NO];
    return self;
}

-(instancetype) initWithFeatureDao: (GPKGFeatureDao *) featureDao andGeodesic: (BOOL) geodesic{
    self = [self initWithFeatureDao:featureDao andStyles:nil andGeodesic:geodesic];
    return self;
}

-(instancetype) initWithFeatureDao: (GPKGFeatureDao *) featureDao andStyles: (GPKGFeatureTableStyles *) featureStyles andGeodesic: (BOOL) geodesic{
    self = [super init];
    if(self != nil){
        
        self.featureDao = featureDao;
        self.featureStyles = featureStyles;
        self.geodesic = geodesic;
        
        self.geometryType = [featureDao geometryType];
        
        self.ignoreGeometryTypes = [NSMutableSet set];
        
        self.name = [NSString stringWithFormat:@"%@ - %@", featureDao.databaseName, featureDao.tableName];
        
        self.maxPointDetailedInfo = [[GPKGProperties numberValueOfBaseProperty:GPKG_PROP_FEATURE_OVERLAY_QUERY andProperty:GPKG_PROP_FEATURE_QUERY_MAX_POINT_DETAILED_INFO] intValue];
        self.maxFeatureDetailedInfo = [[GPKGProperties numberValueOfBaseProperty:GPKG_PROP_FEATURE_OVERLAY_QUERY andProperty:GPKG_PROP_FEATURE_QUERY_MAX_FEATURE_DETAILED_INFO] intValue];
        
        self.detailedInfoPrintPoints = [GPKGProperties boolValueOfBaseProperty:GPKG_PROP_FEATURE_OVERLAY_QUERY andProperty:GPKG_PROP_FEATURE_QUERY_DETAILED_INFO_PRINT_POINTS];
        self.detailedInfoPrintFeatures = [GPKGProperties boolValueOfBaseProperty:GPKG_PROP_FEATURE_OVERLAY_QUERY andProperty:GPKG_PROP_FEATURE_QUERY_DETAILED_INFO_PRINT_FEATURES];
    }
    return self;
}

-(SFGeometryType) geometryType{
    return _geometryType;
}

-(void) ignoreGeometryType: (SFGeometryType) geometryType{
    [self.ignoreGeometryTypes addObject:[NSNumber numberWithInteger:geometryType]];
}

-(NSString *) buildResultsInfoMessageAndCloseWithFeatureIndexResults: (GPKGFeatureIndexResults *) results{
    return [self buildResultsInfoMessageAndCloseWithFeatureIndexResults:results andProjection:nil];
}

-(NSString *) buildResultsInfoMessageAndCloseWithFeatureIndexResults: (GPKGFeatureIndexResults *) results andProjection: (PROJProjection *) projection{
    return [self buildResultsInfoMessageAndCloseWithFeatureIndexResults:results andTolerance:nil andPoint:nil andProjection:projection];
}

-(NSString *) buildResultsInfoMessageAndCloseWithFeatureIndexResults: (GPKGFeatureIndexResults *) results andTolerance: (GPKGMapTolerance *) tolerance andPoint: (SFPoint *) point{
    return [self buildResultsInfoMessageAndCloseWithFeatureIndexResults:results andTolerance:tolerance andPoint:point andProjection:nil];
}

-(NSString *) buildResultsInfoMessageAndCloseWithFeatureIndexResults: (GPKGFeatureIndexResults *) results andTolerance: (GPKGMapTolerance *) tolerance andPoint: (SFPoint *) point andProjection: (PROJProjection *) projection{
    CLLocationCoordinate2D locationCoordinate;
    if(point != nil){
        locationCoordinate = CLLocationCoordinate2DMake([point.y doubleValue], [point.x doubleValue]);
    }else{
        locationCoordinate = kCLLocationCoordinate2DInvalid;
    }
    return [self buildResultsInfoMessageAndCloseWithFeatureIndexResults:results andTolerance:tolerance andLocationCoordinate:locationCoordinate andProjection:projection];
}

-(NSString *) buildResultsInfoMessageAndCloseWithFeatureIndexResults: (GPKGFeatureIndexResults *) results andTolerance: (GPKGMapTolerance *) tolerance andLocationCoordinate: (CLLocationCoordinate2D) locationCoordinate{
    return [self buildResultsInfoMessageAndCloseWithFeatureIndexResults:results andTolerance:tolerance andLocationCoordinate:locationCoordinate andProjection:nil];
}

-(NSString *) buildResultsInfoMessageAndCloseWithFeatureIndexResults: (GPKGFeatureIndexResults *) results andTolerance: (GPKGMapTolerance *) tolerance andLocationCoordinate: (CLLocationCoordinate2D) locationCoordinate andProjection: (PROJProjection *) projection{
    return [self buildResultsInfoMessageAndCloseWithFeatureIndexResults:results andTolerance:tolerance andLocationCoordinate:locationCoordinate andScale:1.0f andZoom:0.0 andMapView:nil andScreenPercentage:0.0 andProjection:projection];
}

-(NSString *) buildResultsInfoMessageAndCloseWithFeatureIndexResults: (GPKGFeatureIndexResults *) results andTolerance: (GPKGMapTolerance *) tolerance andLocationCoordinate: (CLLocationCoordinate2D) locationCoordinate andScale: (float) scale andZoom: (double) zoom andMapView: (MKMapView *) mapView andScreenPercentage: (float) screenClickPercentage{
    return [self buildResultsInfoMessageAndCloseWithFeatureIndexResults:results andTolerance:tolerance andLocationCoordinate:locationCoordinate andScale:scale andZoom:zoom andMapView:mapView andScreenPercentage:screenClickPercentage andProjection:nil];
}

-(NSString *) buildResultsInfoMessageAndCloseWithFeatureIndexResults: (GPKGFeatureIndexResults *) results andTolerance: (GPKGMapTolerance *) tolerance andLocationCoordinate: (CLLocationCoordinate2D) locationCoordinate andScale: (float) scale andZoom: (double) zoom andMapView: (MKMapView *) mapView andScreenPercentage: (float) screenClickPercentage andProjection: (PROJProjection *) projection{
    
    NSMutableString *message = nil;
    
    // Fine filter results so that the click location is within the tolerance of each feature row result
    GPKGFeatureIndexResults *filteredResults = [self fineFilterResults:results andTolerance:tolerance andLocation:locationCoordinate andScale:scale andZoom:zoom andMapView:mapView andScreenPercentage:screenClickPercentage];
    
    int featureCount = filteredResults.count;
    if(featureCount > 0){
        
        int maxFeatureInfo = 0;
        if(self.geometryType == SF_POINT){
            maxFeatureInfo = self.maxPointDetailedInfo;
        } else{
            maxFeatureInfo = self.maxFeatureDetailedInfo;
        }
        
        if(featureCount <= maxFeatureInfo){
            message = [NSMutableString string];
            [message appendFormat:@"%@\n", self.name];
            
            int featureNumber = 0;
            
            GPKGDataColumnsDao *dataColumnsDao = [self dataColumnsDao];
            
            for(GPKGFeatureRow *featureRow in filteredResults){
                
                featureNumber++;
                if(featureNumber > maxFeatureInfo){
                    break;
                }
                
                if(featureCount > 1){
                    if(featureNumber > 1){
                        [message appendString:@"\n"];
                    }else{
                        [message appendFormat:@"\n%d Features\n", featureCount];
                    }
                    [message appendFormat:@"\nFeature %d:\n", featureNumber];
                }
                
                int geometryColumn = [featureRow geometryColumnIndex];
                for(int i = 0; i < [featureRow columnCount]; i++){
                    if(i != geometryColumn){
                        NSObject *value = [featureRow valueWithIndex:i];
                        if(value != nil){
                            NSString *columnName = [featureRow columnNameWithIndex:i];
                            columnName = [self columnNameWithDataColumnsDao:dataColumnsDao andFeatureRow:featureRow andColumnName:columnName];
                            [message appendFormat:@"\n%@: %@", columnName, value];
                        }
                    }
                }
                
                GPKGGeometryData *geomData = [featureRow geometry];
                if(geomData != nil && geomData.geometry != nil){
                    
                    BOOL printFeatures = NO;
                    if(geomData.geometry.geometryType == SF_POINT){
                        printFeatures = self.detailedInfoPrintPoints;
                    } else{
                        printFeatures = self.detailedInfoPrintFeatures;
                    }
                    
                    if(printFeatures){
                        if(projection != nil){
                            [self projectGeometry:geomData inProjection:projection];
                        }
                        [message appendFormat:@"\n\n%@", [SFGeometryPrinter geometryString:geomData.geometry]];
                    }
                }
            }
        }else{
            message = [NSMutableString string];
            [message appendFormat:@"%@\n\t%d features", self.name, featureCount];
            if(CLLocationCoordinate2DIsValid(locationCoordinate)){
                [message appendString:@" near location:\n"];
                SFPoint *point = [SFPoint pointWithXValue:locationCoordinate.longitude andYValue:locationCoordinate.latitude];
                [message appendFormat:@"%@", [SFGeometryPrinter geometryString:point]];
            }
        }
    }
    
    [results close];
    
    return message;
}

-(GPKGFeatureTableData *) buildTableDataAndCloseWithFeatureIndexResults: (GPKGFeatureIndexResults *) results andTolerance: (GPKGMapTolerance *) tolerance andPoint: (SFPoint *) point{
    return [self buildTableDataAndCloseWithFeatureIndexResults:results andTolerance:tolerance andPoint:point andProjection:nil];
}

-(GPKGFeatureTableData *) buildTableDataAndCloseWithFeatureIndexResults: (GPKGFeatureIndexResults *) results andTolerance: (GPKGMapTolerance *) tolerance andPoint: (SFPoint *) point andProjection: (PROJProjection *) projection{
    CLLocationCoordinate2D locationCoordinate;
    if(point != nil){
        locationCoordinate = CLLocationCoordinate2DMake([point.y doubleValue], [point.x doubleValue]);
    }else{
        locationCoordinate = kCLLocationCoordinate2DInvalid;
    }
    return [self buildTableDataAndCloseWithFeatureIndexResults:results andTolerance:tolerance andLocationCoordinate:locationCoordinate andProjection:projection];
}

-(GPKGFeatureTableData *) buildTableDataAndCloseWithFeatureIndexResults: (GPKGFeatureIndexResults *) results andTolerance: (GPKGMapTolerance *) tolerance andLocationCoordinate: (CLLocationCoordinate2D) locationCoordinate{
    return [self buildTableDataAndCloseWithFeatureIndexResults:results andTolerance:tolerance andLocationCoordinate:locationCoordinate andProjection:nil];
}

-(GPKGFeatureTableData *) buildTableDataAndCloseWithFeatureIndexResults: (GPKGFeatureIndexResults *) results andTolerance: (GPKGMapTolerance *) tolerance andLocationCoordinate: (CLLocationCoordinate2D) locationCoordinate andProjection: (PROJProjection *) projection{
    return [self buildTableDataAndCloseWithFeatureIndexResults:results andTolerance:tolerance andLocationCoordinate:locationCoordinate andScale:1.0f andZoom:0.0 andMapView:nil andScreenPercentage:0.0f andProjection:projection];
}

-(GPKGFeatureTableData *) buildTableDataAndCloseWithFeatureIndexResults: (GPKGFeatureIndexResults *) results andTolerance: (GPKGMapTolerance *) tolerance andLocationCoordinate: (CLLocationCoordinate2D) locationCoordinate andScale: (float) scale andZoom: (double) zoom andMapView: (MKMapView *) mapView andScreenPercentage: (float) screenClickPercentage{
    return [self buildTableDataAndCloseWithFeatureIndexResults:results andTolerance:tolerance andLocationCoordinate:locationCoordinate andScale:scale andZoom:zoom andMapView:mapView andScreenPercentage:screenClickPercentage andProjection:nil];
}

-(GPKGFeatureTableData *) buildTableDataAndCloseWithFeatureIndexResults: (GPKGFeatureIndexResults *) results andTolerance: (GPKGMapTolerance *) tolerance andLocationCoordinate: (CLLocationCoordinate2D) locationCoordinate andScale: (float) scale andZoom: (double) zoom andMapView: (MKMapView *) mapView andScreenPercentage: (float) screenClickPercentage andProjection: (PROJProjection *) projection{
    
    GPKGFeatureTableData *tableData = nil;
    
    // Fine filter results so that the click location is within the tolerance of each feature row result
    GPKGFeatureIndexResults *filteredResults = [self fineFilterResults:results andTolerance:tolerance andLocation:locationCoordinate andScale:scale andZoom:zoom andMapView:mapView andScreenPercentage:screenClickPercentage];
    
    int featureCount = filteredResults.count;
    if(featureCount > 0){
        
        int maxFeatureInfo = 0;
        if(self.geometryType == SF_POINT){
            maxFeatureInfo = self.maxPointDetailedInfo;
        } else{
            maxFeatureInfo = self.maxFeatureDetailedInfo;
        }
        
        if(featureCount <= maxFeatureInfo){
            
            GPKGDataColumnsDao *dataColumnsDao = [self dataColumnsDao];
            
            NSMutableArray<GPKGFeatureRowData *> *rows = [NSMutableArray array];
            
            for(GPKGFeatureRow *featureRow in filteredResults){
                
                NSMutableDictionary *values = [NSMutableDictionary dictionary];
                NSString *idColumnName = nil;
                NSString *geometryColumnName = nil;
                
                int idColumn = [featureRow pkIndex];
                int geometryColumn = [featureRow geometryColumnIndex];
                for(int i = 0; i < [featureRow columnCount]; i++){
                    
                    NSObject *value = [featureRow valueWithIndex:i];
                    
                    NSString *columnName = [featureRow columnNameWithIndex:i];
                    
                    columnName = [self columnNameWithDataColumnsDao:dataColumnsDao andFeatureRow:featureRow andColumnName:columnName];
                    
                    if(i == idColumn){
                        idColumnName = columnName;
                    }else if(i == geometryColumn){
                        geometryColumnName = columnName;
                        if(projection != nil){
                            GPKGGeometryData *geomData = (GPKGGeometryData *) value;
                            if(geomData != nil){
                                [self projectGeometry:geomData inProjection:projection];
                            }
                        }
                    }
                    
                    if(value != nil){
                        [values setObject:value forKey:columnName];
                    }
                }
                
                GPKGFeatureRowData *featureRowData = [[GPKGFeatureRowData alloc] initWithValues:values andIdColumnName:idColumnName andGeometryColumnName:geometryColumnName];
                [rows addObject:featureRowData];
            }
            
            tableData = [[GPKGFeatureTableData alloc] initWithName:self.featureDao.tableName  andCount:featureCount andRows:rows];
        }else{
            tableData = [[GPKGFeatureTableData alloc] initWithName:self.featureDao.tableName  andCount:featureCount];
        }
    }
    
    [results close];
    
    return tableData;
}

-(void) projectGeometry: (GPKGGeometryData *) geometryData inProjection: (PROJProjection *) projection{
    
    if(geometryData.geometry != nil){
        
        GPKGSpatialReferenceSystemDao *srsDao = [[GPKGSpatialReferenceSystemDao alloc] initWithDatabase:self.featureDao.database];
        NSNumber *srsId = geometryData.srsId;
        GPKGSpatialReferenceSystem *srs = (GPKGSpatialReferenceSystem *) [srsDao queryForIdObject:srsId];
        
        if(![projection isEqualToAuthority:srs.organization andNumberCode:srs.organizationCoordsysId]){
            
            PROJProjection *geomProjection = [srs projection];
            SFPGeometryTransform *transform = [SFPGeometryTransform transformFromProjection:geomProjection andToProjection:projection];
            
            SFGeometry *projectedGeometry = [transform transformGeometry:geometryData.geometry];
            [transform destroy];
            [geometryData setGeometry:projectedGeometry];
            GPKGSpatialReferenceSystem *projectionSrs = [srsDao srsWithProjection:projection];
            [geometryData setSrsId:projectionSrs.srsId];
        }
        
    }
}

-(GPKGDataColumnsDao *) dataColumnsDao{
    
    GPKGDataColumnsDao *dataColumnsDao = [[GPKGDataColumnsDao alloc] initWithDatabase:self.featureDao.database];
    
    if(![dataColumnsDao tableExists]){
        dataColumnsDao = nil;
    }
    
    return dataColumnsDao;
}

-(NSString *) columnNameWithDataColumnsDao: (GPKGDataColumnsDao *) dataColumnsDao andFeatureRow: (GPKGFeatureRow *) featureRow andColumnName: (NSString *) columnName{
    
    NSString *newColumnName = columnName;
    
    if(dataColumnsDao != nil){
        GPKGDataColumns *dataColumn = [dataColumnsDao dataColumnByTableName:featureRow.table.tableName andColumnName:columnName];
        if(dataColumn != nil){
            newColumnName = dataColumn.name;
        }
    }
    
    return newColumnName;
}

/**
 * Fine filter the index results verifying the click location is within the tolerance of each feature row
 *
 * @param results               feature index results
 * @param tolerance             distance tolerance
 * @param clickLocation         click location
 * @param scale              scale factor
 * @param zoom                  current zoom level
 * @param mapView                  map view
 * @param screenClickPercentage screen click percentage between 0.0 and 1.0
 * @return filtered feature index results
 */
-(GPKGFeatureIndexResults *) fineFilterResults: (GPKGFeatureIndexResults *) results andTolerance: (GPKGMapTolerance *) tolerance andLocation: (CLLocationCoordinate2D) clickLocation andScale: (float) scale andZoom: (double) zoom andMapView: (MKMapView *) mapView andScreenPercentage: (float) screenClickPercentage{
    
    GPKGFeatureIndexResults *filteredResults = nil;
    
    if([self.ignoreGeometryTypes containsObject: [NSNumber numberWithInteger:self.geometryType]]){
        filteredResults = [[GPKGFeatureIndexListResults alloc] init];
    }else if([results count] == 0 || (!CLLocationCoordinate2DIsValid(clickLocation) && self.ignoreGeometryTypes.count == 0)){
        filteredResults = results;
    }else{
        
        NSMutableArray<GPKGFeatureRow *> *sortedResults = [NSMutableArray array];
        NSMutableArray<NSDecimalNumber *> *sortedDistances = [NSMutableArray array];
        
        GPKGMapShapeConverter *converter = [[GPKGMapShapeConverter alloc] initWithProjection:self.featureDao.projection];
        
        // Set the geodesic max distance for drawing geometries as geodesic lines
        if(_geodesic){
            double maxDistance = [GPKGMapUtils toleranceDistanceInMapView:mapView];
            [converter setGeodesicMaxDistanceAsDouble:maxDistance];
        }
        
        for (GPKGFeatureRow *featureRow in results) {
            
            GPKGGeometryData *geomData = [featureRow geometry];
            if (geomData != nil) {
                SFGeometry *geometry = geomData.geometry;
                if (geometry != nil) {
                    
                    if(![self.ignoreGeometryTypes containsObject: [NSNumber numberWithInteger:geometry.geometryType]]){
                    
                        NSDecimalNumber *distance = [[NSDecimalNumber alloc] initWithDouble:-1.0];
                        
                        if(CLLocationCoordinate2DIsValid(clickLocation)){
                        
                            GPKGMapShape *mapShape = [converter toShapeWithGeometry:geometry];
                            NSDecimalNumber *styleFiltered = [self fineFilterStyleWithRow:featureRow andGeometry:geometry andShape:mapShape andLocation:clickLocation andScale:scale andZoom:zoom andMapView:mapView andScreenPercentage:screenClickPercentage];
                            if(styleFiltered != nil && [styleFiltered doubleValue] == -2.0){
                                distance = [GPKGMapUtils distanceIfLocation:clickLocation onShape:mapShape withTolerance:tolerance];
                            }else{
                                distance = styleFiltered;
                            }

                        }
                        
                        if(distance != nil){
                            [self insertFeatureRow:featureRow withDistance:distance inRows:sortedResults andDistances:sortedDistances];
                        }
                        
                    }
                }
            }
            
        }
        
        [converter destroy];
        
        filteredResults = [[GPKGFeatureIndexListResults alloc] initWithFeatureRows:sortedResults];
    }
    
    return filteredResults;
}

-(void) insertFeatureRow: (GPKGFeatureRow *) featureRow withDistance: (NSDecimalNumber *) distance inRows: (NSMutableArray<GPKGFeatureRow *> *) rows andDistances: (NSMutableArray<NSDecimalNumber *> *) distances{
    
    NSUInteger insertLocation = [distances indexOfObject:distance inSortedRange:NSMakeRange(0, distances.count) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(NSDecimalNumber *distance1, NSDecimalNumber *distance2){
        
        NSComparisonResult compare = NSOrderedSame;
        if([distance1 doubleValue] >= 0){
            if([distance2 doubleValue] >= 0){
                compare = [distance1 compare:distance2];
            }else{
                compare = NSOrderedAscending;
            }
        }else if([distance2 doubleValue] >= 0){
            compare = NSOrderedDescending;
        }
        
        return compare;
    }];
    
    [rows insertObject:featureRow atIndex:insertLocation];
    [distances insertObject:distance atIndex:insertLocation];
}

/**
 * Fine filter the feature row with feature styles
 *
 * @param featureRow            feature row
 * @param geometry              geometry
 * @param mapShape              Map Shape
 * @param clickLocation         click location
 * @param scale               scale factor
 * @param zoom                  current zoom level
 * @param mapView                  map view
 * @param screenClickPercentage screen click percentage between 0.0 and 1.0
 * @return -2.0 when not style filtered, distance if passes fine filter, -1.0 when distance not calculated, nil if does not pass
 */
-(NSDecimalNumber *) fineFilterStyleWithRow: (GPKGFeatureRow *) featureRow andGeometry: (SFGeometry *) geometry andShape: (GPKGMapShape *) mapShape andLocation: (CLLocationCoordinate2D) clickLocation andScale: (float) scale andZoom: (double) zoom andMapView: (MKMapView *) mapView andScreenPercentage: (float) screenClickPercentage{
    
    NSDecimalNumber *distance = [[NSDecimalNumber alloc] initWithDouble:-2.0];
    
    if(_featureStyles != nil && mapView != nil){
        
        GPKGPixelBounds *pixelBounds = nil;
        
        GPKGIconRow *iconRow = [_featureStyles iconWithFeature:featureRow];
        if(iconRow != nil){
            
            pixelBounds = [GPKGFeatureStyleExtension calculatePixelBoundsWithIconRow:iconRow andScale:scale];
            
        }else{
            GPKGStyleRow *styleRow = [_featureStyles styleWithFeature:featureRow];
            if(styleRow != nil){
                pixelBounds = [GPKGFeatureStyleExtension calculatePixelBoundsWithStyleRow:styleRow andScale:scale];
            }
        }
        
        if(pixelBounds != nil){
            
            // Clear expanded pixel bounds in the click direction opposite of a point
            if(geometry.geometryType == SF_POINT){
                SFPoint *point = (SFPoint *) geometry;
                if([point.x doubleValue] < clickLocation.longitude){
                    [pixelBounds setRight:0];
                }else if([point.x doubleValue] > clickLocation.longitude){
                    [pixelBounds setLeft:0];
                }
                if([point.y doubleValue] < clickLocation.latitude){
                    [pixelBounds setUp:0];
                }else if([point.y doubleValue] > clickLocation.latitude){
                    [pixelBounds setDown:0];
                }
                if([pixelBounds area] == 0){
                    pixelBounds = nil;
                }
            }
            
            // Get the map click distance tolerance
            GPKGMapTolerance *tolerance = [GPKGMapUtils toleranceWithLocationCoordinate:clickLocation andScale:scale andZoom:zoom andPixelBounds:pixelBounds andMapView:mapView andScreenPercentage:screenClickPercentage];
            
            distance = [GPKGMapUtils distanceIfLocation:clickLocation onShape:mapShape withTolerance:tolerance];
            
        }
        
    }
    
    return distance;
}

@end

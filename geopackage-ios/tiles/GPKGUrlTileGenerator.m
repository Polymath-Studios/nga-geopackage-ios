//
//  GPKGUrlTileGenerator.m
//  geopackage-ios
//
//  Created by Brian Osborn on 6/18/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGUrlTileGenerator.h>
#import <GeoPackage/GPKGProperties.h>
#import <GeoPackage/GPKGPropertyConstants.h>
#import <GeoPackage/GPKGTileBoundingBoxUtils.h>
#import <GeoPackage/GPKGIOUtils.h>
#import <GeoPackage/GPKGNetworkUtils.h>

@interface GPKGUrlTileGenerator ()

@property (nonatomic, strong) NSString *tileUrl;
@property (nonatomic) BOOL urlHasXYZ;
@property (nonatomic) BOOL urlHasBoundingBox;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<NSString *> *> *httpHeader;

@end

@implementation GPKGUrlTileGenerator

-(instancetype) initWithGeoPackage: (GPKGGeoPackage *) geoPackage andTableName: (NSString *) tableName andTileUrl: (NSString *) tileUrl andBoundingBox: (GPKGBoundingBox *) boundingBox andProjection: (PROJProjection *) projection{
    self = [super initWithGeoPackage:geoPackage andTableName:tableName andBoundingBox:boundingBox andProjection:projection];
    [self initializeWithTileUrl:tileUrl];
    return self;
}

-(instancetype) initWithGeoPackage: (GPKGGeoPackage *) geoPackage andTableName: (NSString *) tableName andTileUrl: (NSString *) tileUrl andZoom: (int) zoomLevel andBoundingBox: (GPKGBoundingBox *) boundingBox andProjection: (PROJProjection *) projection{
    self = [super initWithGeoPackage:geoPackage andTableName:tableName andZoom:zoomLevel andBoundingBox:boundingBox andProjection:projection];
    [self initializeWithTileUrl:tileUrl];
    return self;
}

-(instancetype) initWithGeoPackage: (GPKGGeoPackage *) geoPackage andTableName: (NSString *) tableName andTileUrl: (NSString *) tileUrl andMinZoom: (int) minZoom andMaxZoom: (int) maxZoom andBoundingBox: (GPKGBoundingBox *) boundingBox andProjection: (PROJProjection *) projection{
    self = [super initWithGeoPackage:geoPackage andTableName:tableName andMinZoom:minZoom andMaxZoom:maxZoom andBoundingBox:boundingBox andProjection:projection];
    [self initializeWithTileUrl:tileUrl];
    return self;
}

-(instancetype) initWithGeoPackage: (GPKGGeoPackage *) geoPackage andTableName: (NSString *) tableName andTileUrl: (NSString *) tileUrl andZoomLevels: (NSArray<NSNumber *> *) zoomLevels andBoundingBox: (GPKGBoundingBox *) boundingBox andProjection: (PROJProjection *) projection{
    self = [super initWithGeoPackage:geoPackage andTableName:tableName andZoomLevels:zoomLevels andBoundingBox:boundingBox andProjection:projection];
    [self initializeWithTileUrl:tileUrl];
    return self;
}

-(instancetype) initializeWithTileUrl: (NSString *) tileUrl{

    if(self != nil){
        
        self.tileUrl = [GPKGIOUtils decodeUrl:tileUrl];
        
        self.urlHasXYZ = [self hasXYZ:tileUrl];
        self.urlHasBoundingBox = [self hasBoundingBox:tileUrl];

        if(!self.urlHasXYZ && !self.urlHasBoundingBox){
            [NSException raise:@"Invalid URL" format:@"URL does not contain x,y,z or bounding box variables: %@", tileUrl];
        }
    }
    return self;
}

-(NSDictionary<NSString *, NSArray<NSString *> *> *) httpHeader{
    return _httpHeader;
}

-(NSArray<NSString *> *) httpHeaderValuesforField: (NSString *) field{
    NSArray<NSString *> *fieldValues = nil;
    if(_httpHeader != nil){
        fieldValues = [_httpHeader objectForKey:field];
    }
    return fieldValues;
}

-(void) addValue: (NSString *) value forHTTPHeaderField: (NSString *) field{
    if(_httpHeader == nil){
        _httpHeader = [NSMutableDictionary dictionary];
    }
    NSMutableArray<NSString *> *values = [_httpHeader objectForKey:field];
    if(values == nil){
        values = [NSMutableArray array];
        [_httpHeader setObject:values forKey:field];
    }
    [values addObject:value];
}

-(void) addValues: (NSArray<NSString *> *) values forHTTPHeaderField: (NSString *) field{
    for(NSString *value in values){
        [self addValue:value forHTTPHeaderField:field];
    }
}

-(BOOL) hasXYZ: (NSString *) url{
    
    NSString *replacedUrl = [self replaceXYZWithUrl:url andZ:0 andX:0 andY:0];
    BOOL hasXYZ = ![replacedUrl isEqualToString:url];
    
    return hasXYZ;
}

-(NSString *) replaceXYZWithUrl: (NSString *) url andZ: (int) z andX: (int) x andY: (int) y{
    
    url = [url stringByReplacingOccurrencesOfString:
           [GPKGProperties valueOfBaseProperty:GPKG_PROP_TILE_GENERATOR_VARIABLE andProperty:GPKG_PROP_TILE_GENERATOR_VARIABLE_Z]
                                         withString:[NSString stringWithFormat:@"%d",z]];
    url = [url stringByReplacingOccurrencesOfString:
           [GPKGProperties valueOfBaseProperty:GPKG_PROP_TILE_GENERATOR_VARIABLE andProperty:GPKG_PROP_TILE_GENERATOR_VARIABLE_X]
                                         withString:[NSString stringWithFormat:@"%d",x]];
    url = [url stringByReplacingOccurrencesOfString:
           [GPKGProperties valueOfBaseProperty:GPKG_PROP_TILE_GENERATOR_VARIABLE andProperty:GPKG_PROP_TILE_GENERATOR_VARIABLE_Y]
                                         withString:[NSString stringWithFormat:@"%d",y]];
    return url;
}

-(BOOL) hasBoundingBox: (NSString *) url{
    
    NSString *replacedUrl = [self replaceBoundingBoxWithUrl:url andBoundingBox:self.boundingBox];
    BOOL hasBoundingBox = ![replacedUrl isEqualToString:url];
    
    return hasBoundingBox;
}

-(NSString *) replaceBoundingBoxWithUrl: (NSString *) url andZ: (int) z andX: (int) x andY: (int) y{
    
    GPKGBoundingBox *boundingBox = nil;
    
    if([self.projection isUnit:PROJ_UNIT_DEGREES]){
        boundingBox = [GPKGTileBoundingBoxUtils projectedBoundingBoxFromWGS84WithProjection:self.projection andX:x andY:y andZoom:z];
    } else{
        boundingBox = [GPKGTileBoundingBoxUtils projectedBoundingBoxWithProjection:self.projection andX:x andY:y andZoom:z];
    }
    
    url = [self replaceBoundingBoxWithUrl:url andBoundingBox:boundingBox];
    
    return url;
}

-(NSString *) replaceBoundingBoxWithUrl: (NSString *) url andBoundingBox: (GPKGBoundingBox *) boundingBox{
    
    url = [url stringByReplacingOccurrencesOfString:
           [GPKGProperties valueOfBaseProperty:GPKG_PROP_TILE_GENERATOR_VARIABLE andProperty:GPKG_PROP_TILE_GENERATOR_VARIABLE_MIN_LAT]
                                         withString:[boundingBox.minLatitude stringValue]];
    url = [url stringByReplacingOccurrencesOfString:
           [GPKGProperties valueOfBaseProperty:GPKG_PROP_TILE_GENERATOR_VARIABLE andProperty:GPKG_PROP_TILE_GENERATOR_VARIABLE_MAX_LAT]
                                         withString:[boundingBox.maxLatitude stringValue]];
    url = [url stringByReplacingOccurrencesOfString:
           [GPKGProperties valueOfBaseProperty:GPKG_PROP_TILE_GENERATOR_VARIABLE andProperty:GPKG_PROP_TILE_GENERATOR_VARIABLE_MIN_LON]
                                         withString:[boundingBox.minLongitude stringValue]];
    url = [url stringByReplacingOccurrencesOfString:
           [GPKGProperties valueOfBaseProperty:GPKG_PROP_TILE_GENERATOR_VARIABLE andProperty:GPKG_PROP_TILE_GENERATOR_VARIABLE_MAX_LON]
                                         withString:[boundingBox.maxLongitude stringValue]];
    
    return url;
}

-(void) preTileGeneration{

}

-(NSData *) createTileWithZ: (int) z andX: (int) x andY: (int) y{
    
    NSString *zoomUrl = self.tileUrl;
    
    // Replace x, y, and z
    if(self.urlHasXYZ){
        int yRequest = y;
        
        // If TMS, flip the y value
        if(self.tms){
            yRequest = [GPKGTileBoundingBoxUtils yAsOppositeTileFormatWithZoom:z andY:y];
        }
        
        zoomUrl = [self replaceXYZWithUrl:zoomUrl andZ:z andX:x andY:yRequest];
    }
    
    // Replace bounding box
    if(self.urlHasBoundingBox){
        zoomUrl = [self replaceBoundingBoxWithUrl:zoomUrl andZ:z andX:x andY:y];
    }
    
    NSURL *url =  [NSURL URLWithString:zoomUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    if(_httpMethod != nil){
        request.HTTPMethod = _httpMethod;
    }
    
    if(_httpHeader != nil){
        for(NSString *field in [_httpHeader allKeys]){
            NSArray<NSString *> *values = [_httpHeader objectForKey:field];
            for(NSString *value in values){
                [request addValue:value forHTTPHeaderField:field];
            }
        }
    }
    
    NSData *data = [GPKGNetworkUtils sendSynchronousWithRedirectsRequest:request withUrl:zoomUrl];
    
    return data;
}

@end

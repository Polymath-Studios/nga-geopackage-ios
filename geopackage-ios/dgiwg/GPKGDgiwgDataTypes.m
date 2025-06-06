//
//  GPKGDgiwgDataTypes.m
//  geopackage-ios
//
//  Created by Brian Osborn on 11/9/22.
//  Copyright © 2022 NGA. All rights reserved.
//

#import <GeoPackage/GPKGDgiwgDataTypes.h>

@implementation GPKGDgiwgDataTypes

+(GPKGContentsDataType) dataType: (GPKGDgiwgDataType) dataType{
    GPKGContentsDataType type = -1;
    
    switch(dataType){
        case GPKG_DGIWG_DT_FEATURES_2D:
        case GPKG_DGIWG_DT_FEATURES_3D:
            type = GPKG_CDT_FEATURES;
            break;
        case GPKG_DGIWG_DT_TILES_2D:
        case GPKG_DGIWG_DT_TILES_3D:
            type = GPKG_CDT_TILES;
            break;
    }
    
    return type;
}

+(NSString *) name: (GPKGDgiwgDataType) dataType{
    NSString *name = nil;
    
    switch(dataType){
        case GPKG_DGIWG_DT_FEATURES_2D:
            name = @"FEATURES_2D";
            break;
        case GPKG_DGIWG_DT_FEATURES_3D:
            name = @"FEATURES_3D";
            break;
        case GPKG_DGIWG_DT_TILES_2D:
            name = @"TILES_2D";
            break;
        case GPKG_DGIWG_DT_TILES_3D:
            name = @"TILES_3D";
            break;
    }
    
    return name;
}

+(int) dimension: (GPKGDgiwgDataType) dataType{
    int dimension = -1;
    
    switch(dataType){
        case GPKG_DGIWG_DT_FEATURES_2D:
        case GPKG_DGIWG_DT_TILES_2D:
            dimension = 2;
            break;
        case GPKG_DGIWG_DT_FEATURES_3D:
        case GPKG_DGIWG_DT_TILES_3D:
            dimension = 3;
            break;
    }
    
    return dimension;
}

+(BOOL) isFeatures: (GPKGDgiwgDataType) dataType{
    return [self dataType:dataType] == GPKG_CDT_FEATURES;
}

+(BOOL) isTiles: (GPKGDgiwgDataType) dataType{
    return [self dataType:dataType] == GPKG_CDT_TILES;
}

+(BOOL) is2D: (GPKGDgiwgDataType) dataType{
    return [self dimension:dataType] == 2;
}

+(BOOL) is3D: (GPKGDgiwgDataType) dataType{
    return [self dimension:dataType] == 3;
}

+(int) z: (GPKGDgiwgDataType) dataType{
    return [self dimension:dataType] - 2;
}

+(NSArray<NSNumber *> *) dataTypes: (GPKGContentsDataType) type{
    NSMutableArray<NSNumber *> *types = [NSMutableArray array];
    
    for(int dataType = 0; dataType <= GPKG_DGIWG_DT_TILES_3D; dataType++) {
        if([self dataType:dataType] == type){
            [types addObject:[NSNumber numberWithInt:dataType]];
        }
    }
    
    return types;
}

@end

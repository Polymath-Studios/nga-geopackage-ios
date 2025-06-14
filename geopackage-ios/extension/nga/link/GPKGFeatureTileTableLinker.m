//
//  GPKGFeatureTileTableLinker.m
//  geopackage-ios
//
//  Created by Brian Osborn on 2/4/16.
//  Copyright © 2016 NGA. All rights reserved.
//

#import <GeoPackage/GPKGFeatureTileTableLinker.h>
#import <GeoPackage/GPKGProperties.h>
#import <GeoPackage/GPKGFeatureTileLinkTableCreator.h>
#import <GeoPackage/GPKGNGAExtensions.h>

NSString * const GPKG_EXTENSION_FEATURE_TILE_LINK_NAME_NO_AUTHOR = @"feature_tile_link";
NSString * const GPKG_PROP_EXTENSION_FEATURE_TILE_LINK_DEFINITION = @"geopackage.extensions.feature_tile_link";

@interface GPKGFeatureTileTableLinker ()

@property (nonatomic, strong) NSString *extensionName;
@property (nonatomic, strong) NSString *extensionDefinition;
@property (nonatomic, strong) GPKGFeatureTileLinkDao *featureTileLinkDao;

@end

@implementation GPKGFeatureTileTableLinker

-(instancetype) initWithGeoPackage: (GPKGGeoPackage *) geoPackage{
    self = [super initWithGeoPackage:geoPackage];
    if(self != nil){
        self.extensionName = [GPKGExtensions buildExtensionNameWithAuthor:GPKG_NGA_EXTENSION_AUTHOR andExtensionName:GPKG_EXTENSION_FEATURE_TILE_LINK_NAME_NO_AUTHOR];
        self.extensionDefinition = [GPKGProperties valueOfProperty:GPKG_PROP_EXTENSION_FEATURE_TILE_LINK_DEFINITION];
        self.featureTileLinkDao = [self featureTileLinkDao];
    }
    return self;
}

-(GPKGFeatureTileLinkDao *) dao{
    return _featureTileLinkDao;
}

-(NSString *) extensionName{
    return _extensionName;
}

-(NSString *) extensionDefinition{
    return _extensionDefinition;
}

-(void) linkWithFeatureTable: (NSString *) featureTable andTileTable: (NSString *) tileTable{
    
    if(![self isLinkedWithFeatureTable:featureTable andTileTable:tileTable]){
        [self extensionCreate];
        
        if(![self.featureTileLinkDao tableExists]){
            [self createFeatureTileLinkTable];
        }
        
        GPKGFeatureTileLink *link = [[GPKGFeatureTileLink alloc] init];
        [link setFeatureTableName:featureTable];
        [link setTileTableName:tileTable];
        
        [self.featureTileLinkDao create:link];
    }

}

-(BOOL) isLinkedWithFeatureTable: (NSString *) featureTable andTileTable: (NSString *) tileTable{
    GPKGFeatureTileLink *link = [self linkFromFeatureTable:featureTable andTileTable:tileTable];
    return link != nil;
}

-(GPKGFeatureTileLink *) linkFromFeatureTable: (NSString *) featureTable andTileTable: (NSString *) tileTable{
    GPKGFeatureTileLink *link = nil;
    
    if([self featureTileLinksActive]){
        link = [self.featureTileLinkDao queryForFeatureTable:featureTable andTileTable:tileTable];
    }
    
    return link;
}

-(GPKGResultSet *) queryForFeatureTable: (NSString *) featureTable{
    
    GPKGResultSet *links = nil;
    
    if([self featureTileLinksActive]){
        links = [self.featureTileLinkDao queryForFeatureTableName:featureTable];
    }
    
    return links;
}

-(GPKGResultSet *) queryForTileTable: (NSString *) tileTable{
    
    GPKGResultSet *links = nil;
    
    if([self featureTileLinksActive]){
        links = [self.featureTileLinkDao queryForTileTableName:tileTable];
    }
    
    return links;
}

-(BOOL) deleteLinkWithFeatureTable: (NSString *) featureTable andTileTable: (NSString *) tileTable{
    
    BOOL deleted = NO;
    
    if([self.featureTileLinkDao tableExists]){
        deleted = [self.featureTileLinkDao deleteByFeatureTable:featureTable andTileTable:tileTable] > 0;
    }
    
    return deleted;
}

-(int) deleteLinksWithTable: (NSString *) table{
    
    int deleted = 0;
    
    if([self.featureTileLinkDao tableExists]){
        deleted = [self.featureTileLinkDao deleteByTableName:table];
    }
    
    return deleted;
}

-(GPKGExtensions *) extensionCreate{
    GPKGExtensions *extension = [self extensionCreateWithName:self.extensionName andTableName:nil andColumnName:nil andDefinition:self.extensionDefinition andScope:GPKG_EST_READ_WRITE];
    return extension;
}

-(BOOL) has{
    return [self extension] != nil;
}

-(GPKGExtensions *) extension{
    GPKGExtensions *extension = [self extensionWithName:self.extensionName andTableName:nil  andColumnName:nil];
    return extension;
}

-(GPKGFeatureTileLinkDao *) featureTileLinkDao{
    return [GPKGFeatureTileTableLinker featureTileLinkDaoWithGeoPackage:self.geoPackage];
}

+(GPKGFeatureTileLinkDao *) featureTileLinkDaoWithGeoPackage: (GPKGGeoPackage *) geoPackage{
    return [GPKGFeatureTileLinkDao createWithDatabase:geoPackage.database];
}

+(GPKGFeatureTileLinkDao *) featureTileLinkDaoWithDatabase: (GPKGConnection *) database{
    return [GPKGFeatureTileLinkDao createWithDatabase:database];
}

-(BOOL) createFeatureTileLinkTable{
    [self verifyWritable];
    
    BOOL created = NO;
    if(![self.featureTileLinkDao tableExists]){
        GPKGFeatureTileLinkTableCreator *tableCreator = [[GPKGFeatureTileLinkTableCreator alloc] initWithDatabase:self.geoPackage.database];
        created = [tableCreator createFeatureTileLink] > 0;
    }
    
    return created;
}

-(BOOL) featureTileLinksActive{
    
    BOOL active = NO;
    
    if([self has]){
        active = [self.featureTileLinkDao tableExists];
    }
    
    return active;
}

-(GPKGFeatureTileLink *) linkFromResultSet: (GPKGResultSet *) results{
    return (GPKGFeatureTileLink *)[self.featureTileLinkDao object:results];
}

-(NSArray<NSString *> *) tileTablesForFeatureTable: (NSString *) featureTable{
    
    NSMutableArray<NSString *> *tileTables = [NSMutableArray array];
    
    GPKGResultSet *results = [self queryForFeatureTable:featureTable];
    @try {
        while([results moveToNext]){
            GPKGFeatureTileLink *link = [self linkFromResultSet:results];
            [tileTables addObject:link.tileTableName];
        }
    }
    @finally {
        [results close];
    }
    
    return tileTables;
}

-(NSArray<NSString *> *) featureTablesForTileTable: (NSString *) tileTable{
    
    NSMutableArray<NSString *> *featureTables = [NSMutableArray array];
    
    GPKGResultSet *results = [self queryForTileTable:tileTable];
    @try {
        while([results moveToNext]){
            GPKGFeatureTileLink *link = [self linkFromResultSet:results];
            [featureTables addObject:link.featureTableName];
        }
    }
    @finally {
        [results close];
    }
    
    return featureTables;
}

-(NSArray<GPKGTileDao *> *) tileDaosForFeatureTable: (NSString *) featureTable{
    
    NSMutableArray<GPKGTileDao *> *tileDaos = [NSMutableArray array];
    
    NSArray<NSString *> *tileTables = [self tileTablesForFeatureTable:featureTable];
    for(NSString *tileTable in tileTables){
        if ([self.geoPackage isTileTable:tileTable]) {
            GPKGTileDao *tileDao = [self.geoPackage tileDaoWithTableName:tileTable];
            [tileDaos addObject:tileDao];
        }
    }
    
    return tileDaos;
}

-(NSArray<GPKGFeatureDao *> *) featureDaosForTileTable: (NSString *) tileTable{
    
    NSMutableArray<GPKGFeatureDao *> *featureDaos = [NSMutableArray array];
    
    NSArray<NSString *> *featureTables = [self featureTablesForTileTable:tileTable];
    for(NSString *featureTable in featureTables){
        if ([self.geoPackage isFeatureTable:featureTable]) {
            GPKGFeatureDao *featureDao = [self.geoPackage featureDaoWithTableName:featureTable];
            [featureDaos addObject:featureDao];
        }
    }
    
    return featureDaos;
}

@end

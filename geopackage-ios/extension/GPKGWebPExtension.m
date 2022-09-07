//
//  GPKGWebPExtension.m
//  geopackage-ios
//
//  Created by Brian Osborn on 5/4/16.
//  Copyright © 2016 NGA. All rights reserved.
//

#import "GPKGWebPExtension.h"
#import "GPKGGeoPackageConstants.h"
#import "GPKGProperties.h"

NSString * const GPKG_WEBP_EXTENSION_NAME = @"webp";
NSString * const GPKG_PROP_WEBP_EXTENSION_DEFINITION = @"geopackage.extensions.webp";

@implementation GPKGWebPExtension

-(instancetype) initWithGeoPackage: (GPKGGeoPackage *) geoPackage{
    self = [super initWithGeoPackage:geoPackage];
    if(self != nil){
        self.extensionName = [GPKGExtensions buildDefaultAuthorExtensionName:GPKG_WEBP_EXTENSION_NAME];
        self.definition = [GPKGProperties valueOfProperty:GPKG_PROP_WEBP_EXTENSION_DEFINITION];
    }
    return self;
}

-(GPKGExtensions *) extensionCreateWithTableName: (NSString *) tableName{
    
    GPKGExtensions *extension = [self extensionCreateWithName:self.extensionName andTableName:tableName andColumnName:GPKG_TC_COLUMN_TILE_DATA andDefinition:self.definition andScope:GPKG_EST_READ_WRITE];
    
    return extension;
}

-(BOOL) hasWithTableName: (NSString *) tableName{
    
    BOOL exists = [self hasWithExtensionName:self.extensionName andTableName:tableName andColumnName:GPKG_TC_COLUMN_TILE_DATA];
    
    return exists;
}

@end

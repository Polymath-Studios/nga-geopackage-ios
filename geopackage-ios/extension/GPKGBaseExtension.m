//
//  GPKGBaseExtension.m
//  geopackage-ios
//
//  Created by Brian Osborn on 5/3/16.
//  Copyright © 2016 NGA. All rights reserved.
//

#import "GPKGBaseExtension.h"

@implementation GPKGBaseExtension

-(instancetype) initWithGeoPackage: (GPKGGeoPackage *) geoPackage{
    self = [super init];
    if(self != nil){
        self.geoPackage = geoPackage;
        self.extensionsDao = [geoPackage extensionsDao];
    }
    return self;
}

-(instancetype) initWithDatabase: (GPKGConnection *) database{
    self = [super init];
    if(self != nil){
        self.extensionsDao = [GPKGExtensionsDao createWithDatabase:database];
    }
    return self;
}

-(GPKGExtensions *) extensionCreateWithName: (NSString *) extensionName andTableName: (NSString *) tableName andColumnName: (NSString *) columnName andDefinition: (NSString *) definition andScope: (enum GPKGExtensionScopeType) scopeType{
    
    GPKGExtensions *extension = [self extensionWithName:extensionName andTableName:tableName andColumnName:columnName];
    
    if(extension == nil){
        if(![self.extensionsDao tableExists]){
            if(self.geoPackage == nil){
                [NSException raise:@"No GeoPackage" format:@"Extension must be created with a GeoPackage in order to create the extensions table"];
            }
            [self.geoPackage createExtensionsTable];
        }
        
        extension = [[GPKGExtensions alloc] init];
        [extension setTableName:tableName];
        [extension setColumnName:columnName];
        [extension setExtensionName:extensionName];
        [extension setDefinition:definition];
        [extension setExtensionScopeType:scopeType];
        
        [self.extensionsDao create:extension];
    }
    
    return extension;
}

-(GPKGResultSet *) extensionsWithName: (NSString *) extensionName{
    
    GPKGResultSet *extensions = nil;
    if([self.extensionsDao tableExists]){
        extensions = [self.extensionsDao queryByExtension:extensionName];
    }
    return extensions;
}

-(BOOL) hasWithExtensionName: (NSString *) extensionName{
    
    GPKGResultSet *extensions = [self extensionsWithName:extensionName];
    BOOL has = extensions.count > 0;
    [extensions close];
    return has;
}

-(GPKGResultSet *) extensionsWithName: (NSString *) extensionName andTableName: (NSString *) tableName{
    
    GPKGResultSet *extensions = nil;
    if([self.extensionsDao tableExists]){
        extensions = [self.extensionsDao queryByExtension:extensionName andTable:tableName];
    }
    return extensions;
}

-(BOOL) hasWithExtensionName: (NSString *) extensionName andTableName: (NSString *) tableName{
    
    GPKGResultSet *extensions = [self extensionsWithName:extensionName andTableName:tableName];
    BOOL has = extensions.count > 0;
    [extensions close];
    return has;
}

-(GPKGExtensions *) extensionWithName: (NSString *) extensionName andTableName: (NSString *) tableName andColumnName: (NSString *) columnName{
    
    GPKGExtensions *extension = nil;
    if([self.extensionsDao tableExists]){
        extension = [self.extensionsDao queryByExtension:extensionName andTable:tableName andColumnName:columnName];
    }
    return extension;
}

-(BOOL) hasWithExtensionName: (NSString *) extensionName andTableName: (NSString *) tableName andColumnName: (NSString *) columnName{
    
    GPKGExtensions *extension = [self extensionWithName:extensionName andTableName:tableName andColumnName:columnName];
    return extension != nil;
}

-(void) verifyWritable{
    if(self.geoPackage != nil){
        [self.geoPackage verifyWritable];
    }
}

@end

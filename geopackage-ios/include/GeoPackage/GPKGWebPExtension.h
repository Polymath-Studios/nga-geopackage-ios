//
//  GPKGWebPExtension.h
//  geopackage-ios
//
//  Created by Brian Osborn on 5/4/16.
//  Copyright © 2016 NGA. All rights reserved.
//

#import <GeoPackage/GPKGBaseExtension.h>

extern NSString * const GPKG_WEBP_EXTENSION_NAME;

/**
 *  WebP Extension
 * <p>
 * <a href="https://www.geopackage.org/spec/#extension_tiles_webp">https://www.geopackage.org/spec/#extension_tiles_webp</a>
 */
@interface GPKGWebPExtension : GPKGBaseExtension

/**
 *  Extension name
 */
@property (nonatomic, strong) NSString *extensionName;

/**
 *  Extension definition URL
 */
@property (nonatomic, strong) NSString *definition;

/**
 *  Initialize
 *
 *  @param geoPackage GeoPackage
 *
 *  @return new instance
 */
-(instancetype) initWithGeoPackage: (GPKGGeoPackage *) geoPackage;

/**
 *  Get or create the extension
 *
 *  @param tableName table name
 *
 *  @return extension
 */
-(GPKGExtensions *) extensionCreateWithTableName: (NSString *) tableName;

/**
 *  Determine if the GeoPackage has the extension
 *
 *  @param tableName table name
 *
 *  @return true if has extension
 */
-(BOOL) hasWithTableName: (NSString *) tableName;

@end

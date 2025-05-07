//
//  GPKGBundleHelper.h
//  GeoPackage
//
//  Created by Paul Solt on 5/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Helper for loading resources from Bundles to make resource loading compatible with SPM
/// and previous bundle loading logic. Checks SPM bundle, then main bundle, then bundle for class.
@interface GPKGBundleHelper : NSObject

/// Loads a resource from a bundle (i.e., myFile.txt)
+ (NSString *)pathForResource:(NSString *)resource;

+ (NSString *)resourcePath;

@end

NS_ASSUME_NONNULL_END

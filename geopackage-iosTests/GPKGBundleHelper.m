//
//  GPKGBundleHelper.m
//  GeoPackage
//
//  Created by Paul Solt on 5/9/25.
//

#import "GPKGBundleHelper.h"

@implementation GPKGBundleHelper

+ (NSString *)pathForResource:(NSString *)resource {
    NSString *filename = [resource stringByDeletingPathExtension];
    NSString *extension = [resource pathExtension];
    NSString *path = [SWIFTPM_MODULE_BUNDLE pathForResource:filename ofType:extension];

    if (!path) {
        NSLog(@"Error: Unable to find file in bundle: %@", resource);
    }
    return path;
}

+ (NSString *)resourcePath {
    return [SWIFTPM_MODULE_BUNDLE resourcePath];
}

@end

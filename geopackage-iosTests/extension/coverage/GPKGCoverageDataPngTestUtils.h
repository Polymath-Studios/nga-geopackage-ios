//
//  GPKGCoverageDataPngTestUtils.h
//  geopackage-ios
//
//  Created by Brian Osborn on 12/1/16.
//  Copyright © 2016 NGA. All rights reserved.
//

#import <GeoPackage/GeoPackage.h>
#import "GPKGCoverageDataValues.h"

@interface GPKGCoverageDataPngTestUtils : NSObject

+(void) testCoverageDataWithGeoPackage: (GPKGGeoPackage *) geoPackage andValues: (GPKGCoverageDataValues *) coverageDataValues andAlgorithm: (enum GPKGCoverageDataAlgorithm) algorithm andAllowNils: (BOOL) allowNils;

@end

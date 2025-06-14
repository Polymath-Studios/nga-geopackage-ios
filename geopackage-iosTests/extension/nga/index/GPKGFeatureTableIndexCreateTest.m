//
//  GPKGFeatureTableIndexCreateTest.m
//  geopackage-ios
//
//  Created by Brian Osborn on 10/19/15.
//  Copyright © 2015 NGA. All rights reserved.
//

#import "GPKGFeatureTableIndexCreateTest.h"
#import "GPKGFeatureTableIndexUtils.h"

@implementation GPKGFeatureTableIndexCreateTest

- (void)testIndexer {
    [GPKGFeatureTableIndexUtils testIndexWithGeoPackage:self.geoPackage andGeodesic:NO];
}

- (void)testIndexGeodesic {
    [GPKGFeatureTableIndexUtils testIndexWithGeoPackage:self.geoPackage andGeodesic:YES];
}

- (void)testDeleteAll {
    [GPKGFeatureTableIndexUtils testDeleteAllWithGeoPackage:self.geoPackage];
}

-(BOOL) allowEmptyFeatures{
    return NO;
}

@end

//
//  GPKGCreateGeoPackageTestCase.m
//  geopackage-ios
//
//  Created by Brian Osborn on 6/9/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "GPKGCreateGeoPackageTestCase.h"
#import "GPKGGeoPackage.h"
#import "GPKGTestSetupTeardown.h"

@implementation GPKGCreateGeoPackageTestCase

-(GPKGGeoPackage *) createGeoPackage{
    return [GPKGTestSetupTeardown setUpCreateWithFeatures:YES andAllowEmptyFeatures:[self allowEmptyFeatures] andTiles:YES];
}

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [GPKGTestSetupTeardown tearDownCreateWithGeoPackage:self.geoPackage];
    
    [super tearDown];
}

-(BOOL) allowEmptyFeatures{
    return YES;
}

@end

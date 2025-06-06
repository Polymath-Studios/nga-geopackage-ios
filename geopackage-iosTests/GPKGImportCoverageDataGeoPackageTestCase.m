//
//  GPKGImportCoverageDataGeoPackageTestCase.m
//  geopackage-ios
//
//  Created by Brian Osborn on 12/1/16.
//  Copyright © 2016 NGA. All rights reserved.
//

#import "GPKGImportCoverageDataGeoPackageTestCase.h"
#import "GPKGTestConstants.h"
#import "GPKGBundleHelper.h"

@import GeoPackage;

@implementation GPKGImportCoverageDataGeoPackageTestCase

-(GPKGGeoPackage *) createGeoPackage{
    
    GPKGGeoPackageManager *manager = [GPKGGeoPackageFactory manager];
    
    // Delete
    [manager delete:GPKG_TEST_IMPORT_COVERAGE_DATA_DB_NAME];
    
    NSString *filePath = [GPKGBundleHelper pathForResource:GPKG_TEST_IMPORT_COVERAGE_DATA_DB_FILE_NAME];
    
    // Import
    [manager importGeoPackageFromPath:filePath withName:GPKG_TEST_IMPORT_COVERAGE_DATA_DB_NAME];
    
    // Open
    GPKGGeoPackage *geoPackage = [manager open:GPKG_TEST_IMPORT_COVERAGE_DATA_DB_NAME];
    [manager close];
    if(geoPackage == nil){
        [NSException raise:@"Failed to Open" format:@"Failed to open database"];
    }
    
    return geoPackage;
}

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    // Close
    if (self.geoPackage != nil) {
        [self.geoPackage close];
    }
    
    [super tearDown];
}

@end

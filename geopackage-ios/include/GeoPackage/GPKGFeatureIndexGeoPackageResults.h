//
//  GPKGFeatureIndexGeoPackageResults.h
//  geopackage-ios
//
//  Created by Brian Osborn on 10/12/15.
//  Copyright © 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGFeatureTableIndex.h>
#import <GeoPackage/GPKGFeatureIndexResultSetResults.h>

/**
 * Feature Index Results to enumerate on feature rows
 * retrieved from GeoPackage index extension results
 */
@interface GPKGFeatureIndexGeoPackageResults : GPKGFeatureIndexResultSetResults

/**
 *  Initialize
 *
 *  @param featureTableIndex feature table index
 *  @param results result set
 *
 *  @return feature index geopackage results
 */
-(instancetype) initWithFeatureTableIndex: (GPKGFeatureTableIndex *) featureTableIndex andResults: (GPKGResultSet *) results;

@end

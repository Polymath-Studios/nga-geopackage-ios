//
//  GPKGFeatureIndexGeoPackageResults.m
//  geopackage-ios
//
//  Created by Brian Osborn on 10/12/15.
//  Copyright © 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGFeatureIndexGeoPackageResults.h>

@interface GPKGFeatureIndexGeoPackageResults ()

@property (nonatomic, strong) GPKGFeatureTableIndex *featureTableIndex;

@end

@implementation GPKGFeatureIndexGeoPackageResults

-(instancetype) initWithFeatureTableIndex: (GPKGFeatureTableIndex *) featureTableIndex andResults: (GPKGResultSet *) results{
    self = [super initWithResults:results];
    if(self != nil){
        self.featureTableIndex = featureTableIndex;
    }
    return self;
}

-(GPKGFeatureRow *) featureRow{
    return [self.featureTableIndex featureRowWithResultSet:[self results]];
}

-(NSNumber *) featureId{
    return [self.featureTableIndex geometryIndexWithResultSet:[self results]].geomId;
}

@end

//
//  GPKGFeatureIndexResultSetResults.m
//  geopackage-ios
//
//  Created by Brian Osborn on 10/25/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import <GeoPackage/GPKGFeatureIndexResultSetResults.h>

@interface GPKGFeatureIndexResultSetResults ()

@property (nonatomic, strong) GPKGResultSet *results;

@end

@implementation GPKGFeatureIndexResultSetResults

-(instancetype) initWithResults: (GPKGResultSet *) results{
    self = [super init];
    if(self != nil){
        self.results = results;
    }
    return self;
}

-(GPKGResultSet *) results{
    return _results;
}

-(int) count{
    return _results.count;
}

-(BOOL) moveToNext{
    return [self.results moveToNext];
}

-(void) close{
    [self.results close];
}

@end

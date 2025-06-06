//
//  GPKGTestGeoPackageProgress.h
//  geopackage-ios
//
//  Created by Brian Osborn on 10/19/15.
//  Copyright © 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GeoPackage/GeoPackage.h>

@interface GPKGTestGeoPackageProgress : NSObject<GPKGProgress>

@property (nonatomic, strong) NSNumber *maxValue;
@property (nonatomic) int progress;
@property (nonatomic) BOOL active;
@property (nonatomic, strong) NSString *error;

-(instancetype) init;

-(void) cancel;

@end

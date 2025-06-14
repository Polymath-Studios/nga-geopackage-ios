//
//  GPKGColumnValues.m
//  geopackage-ios
//
//  Created by Brian Osborn on 6/4/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <GeoPackage/GPKGColumnValues.h>
#import <GeoPackage/GPKGUtils.h>

@implementation GPKGColumnValues

-(instancetype) init{
    self = [super init];
    if(self != nil){
        self.values = [NSMutableDictionary dictionary];
        self.columns = [NSMutableArray array];
    }
    return self;
}

-(int) count{
    return (int)[self.values count];
}

-(void) addColumn: (NSString *) column withValue:(NSObject *) value{
    [GPKGUtils addObject:column toArray:self.columns];
    [GPKGUtils setObject:value forKey:column inDictionary:self.values];
}

-(NSObject *) value: (NSString *) column{
    return [GPKGUtils objectForKey:column inDictionary:self.values];
}

@end

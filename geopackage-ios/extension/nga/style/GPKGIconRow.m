//
//  GPKGIconRow.m
//  geopackage-ios
//
//  Created by Brian Osborn on 1/17/19.
//  Copyright © 2019 NGA. All rights reserved.
//

#import "GPKGIconRow.h"

@implementation GPKGIconRow

-(instancetype) init{
    self = [self initWithIconTable:[[GPKGIconTable alloc] init]];
    return self;
}

-(instancetype) initWithIconTable: (GPKGIconTable *) table andColumns: (GPKGUserColumns *) columns andValues: (NSMutableArray *) values{
    self = [super initWithMediaTable:table andColumns:columns andValues:values];
    return self;
}

-(instancetype) initWithIconTable: (GPKGIconTable *) table{
    self = [super initWithMediaTable:table];
    return self;
}

-(GPKGIconTable *) iconTable{
    return (GPKGIconTable *) [super mediaTable];
}

-(int) nameColumnIndex{
    return [[self userCustomColumns] columnIndexWithColumnName:GPKG_IT_COLUMN_NAME];
}

-(GPKGUserCustomColumn *) nameColumn{
    return (GPKGUserCustomColumn *)[[self userCustomColumns] columnWithColumnName:GPKG_IT_COLUMN_NAME];
}

-(NSString *) name{
    return (NSString *)[self valueWithIndex:[self nameColumnIndex]];
}

-(void) setName: (NSString *) name{
    [self setValueWithIndex:[self nameColumnIndex] andValue:name];
}

-(int) descriptionColumnIndex{
    return [[self userCustomColumns] columnIndexWithColumnName:GPKG_IT_COLUMN_DESCRIPTION];
}

-(GPKGUserCustomColumn *) descriptionColumn{
    return (GPKGUserCustomColumn *)[[self userCustomColumns] columnWithColumnName:GPKG_IT_COLUMN_DESCRIPTION];
}

-(NSString *) description{
    return (NSString *)[self valueWithIndex:[self descriptionColumnIndex]];
}

-(void) setDescription: (NSString *) description{
    [self setValueWithIndex:[self descriptionColumnIndex] andValue:description];
}

-(int) widthColumnIndex{
    return [[self userCustomColumns] columnIndexWithColumnName:GPKG_IT_COLUMN_WIDTH];
}

-(GPKGUserCustomColumn *) widthColumn{
    return (GPKGUserCustomColumn *)[[self userCustomColumns] columnWithColumnName:GPKG_IT_COLUMN_WIDTH];
}

-(NSDecimalNumber *) width{
    return (NSDecimalNumber *)[self valueWithIndex:[self widthColumnIndex]];
}

-(void) setWidth: (NSDecimalNumber *) width{
    if (width != nil && [width doubleValue] < 0.0) {
        [NSException raise:@"Invalid Value" format:@"Width must be greater than or equal to 0.0, invalid value: %@", width];
    }
    [self setValueWithIndex:[self widthColumnIndex] andValue:width];
}

-(void) setWidthValue: (double) width{
    [self setWidth:[[NSDecimalNumber alloc] initWithDouble:width]];
}

-(double) derivedWidth{
    
    double derivedWidth;
    
    NSDecimalNumber *width = [self width];
    if (width == nil) {
        derivedWidth = [self derivedDimensions][0];
    }else{
        derivedWidth = [width doubleValue];
    }
    
    return [width doubleValue];
}

-(int) heightColumnIndex{
    return [[self userCustomColumns] columnIndexWithColumnName:GPKG_IT_COLUMN_HEIGHT];
}

-(GPKGUserCustomColumn *) heightColumn{
    return (GPKGUserCustomColumn *)[[self userCustomColumns] columnWithColumnName:GPKG_IT_COLUMN_HEIGHT];
}

-(NSDecimalNumber *) height{
    return (NSDecimalNumber *)[self valueWithIndex:[self heightColumnIndex]];
}

-(void) setHeight: (NSDecimalNumber *) height{
    if (height != nil && [height doubleValue] < 0.0) {
        [NSException raise:@"Invalid Value" format:@"Height must be greater than or equal to 0.0, invalid value: %@", height];
    }
    [self setValueWithIndex:[self heightColumnIndex] andValue:height];
}

-(void) setHeightValue: (double) height{
    [self setHeight:[[NSDecimalNumber alloc] initWithDouble:height]];
}

-(double) derivedHeight{
    
    double derivedHeight;
    
    NSDecimalNumber *height = [self height];
    if (height == nil) {
        derivedHeight = [self derivedDimensions][1];
    }else{
        derivedHeight = [height doubleValue];
    }
    
    return [height doubleValue];
}

-(double *) derivedDimensions{
    
    double derivedWidth;
    double derivedHeight;
    
    NSDecimalNumber *width = [self width];
    NSDecimalNumber *height = [self height];
    
    if (width == nil || height == nil) {
        
        NSDictionary *imageSourceProperties = [self dataImageSourceProperties];
        int dataWidth = [[imageSourceProperties objectForKey:(NSString *)kCGImagePropertyPixelWidth] intValue];
        int dataHeight = [[imageSourceProperties objectForKey:(NSString *)kCGImagePropertyPixelHeight] intValue];
        
        if (width == nil) {
            derivedWidth = (double) dataWidth;
            
            if (height != nil) {
                derivedWidth *= ([height doubleValue] / dataHeight);
            }
        }else{
            derivedWidth = [width doubleValue];
        }
        
        if (height == nil) {
            derivedHeight = (double) dataHeight;
            
            if (width != nil) {
                derivedHeight *= ([width doubleValue] / dataWidth);
            }
        }else{
            derivedHeight = [height doubleValue];
        }
        
    }else{
        derivedWidth = [width doubleValue];
        derivedHeight = [height doubleValue];
    }
    
    double *derivedDimensions = calloc(2, sizeof(double));
    derivedDimensions[0] = derivedHeight;
    derivedDimensions[1] = derivedHeight;
    
    return derivedDimensions;
}

-(int) anchorUColumnIndex{
    return [[self userCustomColumns] columnIndexWithColumnName:GPKG_IT_COLUMN_ANCHOR_U];
}

-(GPKGUserCustomColumn *) anchorUColumn{
    return (GPKGUserCustomColumn *)[[self userCustomColumns] columnWithColumnName:GPKG_IT_COLUMN_ANCHOR_U];
}

-(NSDecimalNumber *) anchorU{
    return (NSDecimalNumber *)[self valueWithIndex:[self anchorUColumnIndex]];
}

-(void) setAnchorU: (NSDecimalNumber *) anchor{
    [self validateAnchor:anchor];
    [self setValueWithIndex:[self anchorUColumnIndex] andValue:anchor];
}

-(void) setAnchorUValue: (double) anchor{
    [self setAnchorU:[[NSDecimalNumber alloc] initWithDouble:anchor]];
}

-(double) anchorUOrDefault{
    double value = 0.5;
    NSDecimalNumber *anchorU = [self anchorU];
    if(anchorU != nil){
        value = [anchorU doubleValue];
    }
    return value;
}

-(int) anchorVColumnIndex{
    return [[self userCustomColumns] columnIndexWithColumnName:GPKG_IT_COLUMN_ANCHOR_V];
}

-(GPKGUserCustomColumn *) anchorVColumn{
    return (GPKGUserCustomColumn *)[[self userCustomColumns] columnWithColumnName:GPKG_IT_COLUMN_ANCHOR_V];
}

-(NSDecimalNumber *) anchorV{
    return (NSDecimalNumber *)[self valueWithIndex:[self anchorVColumnIndex]];
}

-(void) setAnchorV: (NSDecimalNumber *) anchor{
    [self validateAnchor:anchor];
    [self setValueWithIndex:[self anchorVColumnIndex] andValue:anchor];
}

-(void) setAnchorVValue: (double) anchor{
    [self setAnchorV:[[NSDecimalNumber alloc] initWithDouble:anchor]];
}

-(double) anchorVOrDefault{
    double value = 1.0;
    NSDecimalNumber *anchorV = [self anchorV];
    if(anchorV != nil){
        value = [anchorV doubleValue];
    }
    return value;
}

/**
 * Validate the anchor value
 *
 * @param anchor anchor
 */
-(void) validateAnchor: (NSDecimalNumber *) anchor{
    if (anchor != nil) {
        double anchorValue = [anchor doubleValue];
        if(anchorValue < 0.0 || anchorValue > 1.0){
            [NSException raise:@"Invalid Value" format:@"Anchor must be set inclusively between 0.0 and 1.0, invalid value: %@", anchor];
        }
    }
}

@end

//
//  Usage.h
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-05-10.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Usage : NSObject

@property (nonatomic, assign) float wifi;
@property (nonatomic, assign) float *wan;
@property (nonatomic, strong) NSDate *date;

@end

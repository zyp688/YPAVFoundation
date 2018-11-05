//
//  YPMeterTable.m
//  YPAVFundationDemo
//
//  Created by WorkZyp on 2018/11/5.
//  Copyright © 2018年 Zyp. All rights reserved.
//

#import "YPMeterTable.h"

#define MIN_DB -60.0f
#define TABLE_SIZE 300

@implementation YPMeterTable {
    float _scaleFactor;
    NSMutableArray *_meterTable;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        float dbResolution = MIN_DB / (TABLE_SIZE - 1);
        _meterTable = [NSMutableArray arrayWithCapacity:TABLE_SIZE];
        _scaleFactor = 1.0f / dbResolution;
        
        float minAmp = dbToAmp(MIN_DB);
        float ampRange = 1.0 - minAmp;
        float invAmpRange = 1.0 / ampRange;
        
        for (int i = 0; i < TABLE_SIZE; i ++) {
            float decibels = i * dbResolution;
            float amp = dbToAmp(decibels);
            float adjAmp = (amp - minAmp) * invAmpRange;
            _meterTable[i] = @(adjAmp);
            
        }
    }
    
    return self;
}

float dbToAmp(float dB) {
    return powf(10.0f, 0.05f * dB);
}

- (float)valueForPower:(float)power {
    if (power < MIN_DB) {
        return 0.0f;
    }else if (power >= 0.0f) {
        return 1.0f;
    }else {
        int index = (int)(power * _scaleFactor);
        return [_meterTable[index] floatValue];
    }
}

@end


@implementation YPLevelPair

- (YPLevelPair *)levelsWithLevel:(float)linearLevel peakLevel:(float)peakLevel {
    YPLevelPair *levelPair = [[YPLevelPair alloc] init];
    levelPair.level = linearLevel;
    levelPair.peakLevel = peakLevel;
    return levelPair;
}

@end

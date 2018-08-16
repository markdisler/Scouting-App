//
//  PropertyParser.m
//  ScoutApp2
//
//  Created by Mark on 7/26/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import "PropertyParser.h"

@implementation PropertyParser

+ (NSString *)createStringForProperties:(NSDictionary *)propDict {
    if (propDict) {
        NSMutableArray *keyValStringPairs = [NSMutableArray array];
        for (id key in propDict) {
            NSString *value = [propDict objectForKey:key];
            NSString *keyValRep = [NSString stringWithFormat:@"%@=%@", key, value];
            [keyValStringPairs addObject:keyValRep];
        }
        
        NSMutableString *stringRepresentation = [NSMutableString string];
        for (NSInteger i = 0; i < keyValStringPairs.count; i++) {
            NSString *appendPair = [keyValStringPairs objectAtIndex:i];
            if (i < keyValStringPairs.count - 1) {
                [stringRepresentation appendString:appendPair];
                [stringRepresentation appendString:@","];
            } else {
                [stringRepresentation appendString:appendPair];
            }
        }
        return stringRepresentation;
    } else {
        return @"";
    }
}

+ (NSDictionary *)parseDictionaryForProperties:(NSString *)propStr {
    if (![propStr isEqualToString:@""]) {
        NSArray *allPairs = [propStr componentsSeparatedByString:@","];
        NSMutableDictionary *propDict = [NSMutableDictionary dictionary];
        
        for (NSString *pair in allPairs) {
            NSArray *pairParts = [pair componentsSeparatedByString:@"="];
            NSString *key = [pairParts objectAtIndex:0];
            NSString *value = [pairParts objectAtIndex:1];
            [propDict setValue:value forKey:key];
        }
        
        return [propDict copy];
    }
    return nil;
}

@end

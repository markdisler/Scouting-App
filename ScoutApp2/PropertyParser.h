//
//  PropertyParser.h
//  ScoutApp2
//
//  Created by Mark on 7/26/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyParser : NSObject
+ (NSString *)createStringForProperties:(NSDictionary *)propDict;
+ (NSDictionary *)parseDictionaryForProperties:(NSString *)propStr;
@end

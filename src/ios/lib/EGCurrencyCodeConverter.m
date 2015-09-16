//
//  EGCurrencyCodeConverter.m
//  EGCreditCardHandler
//
//  Created by Nate Petersen on 8/25/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#import "EGCurrencyCodeConverter.h"

@implementation EGCurrencyCodeConverter

+ (NSDictionary*)alphaCodeMap
{
	static NSDictionary* map = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSBundle* bundle = [NSBundle bundleForClass:self];
		NSURL* url = [bundle URLForResource:@"currencyCodes" withExtension:@"json"];
		NSData* data = [NSData dataWithContentsOfURL:url];
		NSError* error = nil;
		map = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
		
		if (error) {
			NSLog(@"Failed to load currency data: %@", error);
		}
	});
	
	return map;
}

+ (NSString*)numericCodeForAlphaCode:(NSString*)alphaCode
{
	NSDictionary* map = [self alphaCodeMap];
	return map[alphaCode];
}

@end

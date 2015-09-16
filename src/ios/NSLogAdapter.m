//
//  NSLogAdapter.m
//  EGCreditCardPlugin
//
//  Created by Nate Petersen on 4/16/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#import "NSLogAdapter.h"

@interface NSLogAdapter ()

@property(nonatomic) EGLogLevel threshold;

@end

@implementation NSLogAdapter

- (instancetype)init
{
	self = [super init];
	
	if (self) {
		self.threshold = EGLogLevelInfo;
	}
	
	return self;
}

- (instancetype)initWithLogThreshold:(EGLogLevel)threshold
{
	self = [super init];
	
	if (self) {
		self.threshold = threshold;
	}
	
	return self;
}

- (void)logMessageWithLevel:(EGLogLevel)level file:(const char *)file function:(const char *)function lineNumber:(NSUInteger)lineNumber format:(NSString*)format, ...
{
	if (level <= self.threshold) {
		NSString* levelName = [NSLogAdapter stringForLogLevel:level];
	//	NSString* prefix = [NSString stringWithFormat:@"%@ | %s | %s:%d |", levelName, file, function, (int)lineNumber];
		NSString* prefix = [NSString stringWithFormat:@"%@ |", levelName];
		va_list args;
		va_start(args, format);
		NSString* content = [[NSString alloc] initWithFormat:format arguments:args];
		va_end(args);
		
		NSLog(@"%@ %@", prefix, content);
	}
}

+ (NSString*)stringForLogLevel:(EGLogLevel)level
{
	switch (level) {
		case EGLogLevelError:	return @"ERROR  ";
		case EGLogLevelWarn:	return @"WARN   ";
		case EGLogLevelInfo:	return @"INFO   ";
		case EGLogLevelDebug:	return @"DEBUG  ";
		case EGLogLevelVerbose:	return @"VERBOSE";
	}
}

@end

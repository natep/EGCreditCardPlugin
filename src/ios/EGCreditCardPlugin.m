//
//  EGCreditCardPlugin.m
//  EGCreditCardPlugin
//
//  Created by Nate Petersen on 9/10/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#import "EGCreditCardPlugin.h"
#import "EGCardReaderManager.h"
#import "EGTransactionResult.h"
#import "EGEMVTransactionResult.h"
#import "EGCardTransactionFactory.h"
#import "NSLogAdapter.h"
#import "EGCreditCardInfo.h"

enum {
	CARD_TYPE_ARG,
	REFUND_ARG,
	AMOUNT_ARG,
	CURRENCY_ARG
};

enum {
	MSRCardType = 1,
	NFCCardType = 2,
	EMVCardType = 3
};

@implementation EGCreditCardPlugin

+ (NSLogAdapter*)logger
{
	static NSLogAdapter* logger = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		logger = [[NSLogAdapter alloc] init];
	});
	
	return logger;
}

+ (EGCardReaderManager*)cardReader
{
	static EGCardReaderManager* cardReader = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		cardReader = [[EGCardReaderManager alloc] initWithLoggingDelegate:[self.class logger]];
	});
	
	return cardReader;
}

+ (NSNumberFormatter*)currencyFormatter
{
	static NSNumberFormatter* nf = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		// force US formatting
		NSLocale* locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
		nf = [[NSNumberFormatter alloc] init];
		nf.locale = locale;
		nf.numberStyle = NSNumberFormatterDecimalStyle;
		nf.generatesDecimalNumbers = YES;
	});
	
	return nf;
}

+ (NSDictionary*)emvPropertyMap
{
	static NSDictionary* map = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		map = @{
				@"eMVApplicationIdentifierField" : @"EMVApplicationIdentifierCard",
				@"eMVApplicationCryptogramField" : @"EMVApplicationCryptogram",
				@"eMVApplicationCurrencyCodeField" : @"EMVApplicationCurrencyCode",
				@"eMVApplicationInterchangeProfileField" : @"EMVApplicationInterchangeProfile",
				@"eMVApplicationTransactionCounterField" : @"EMVApplicationTransactionCounter",
				@"eMVApplicationUsageControlField" : @"EMVApplicationUsageControl",
				@"eMVApplicationVersionNumberField" : @"EMVApplicationVersionNumber",
				@"eMVAuthorizationResponseCodeField" : @"EMVAuthorisationResponseCode",
				@"eMVCardholderVerificationMethodResultsField" : @"EMVCardholderVerificationMethodResult",
				@"eMVCryptogramInformationDataField" : @"EMVCryptogramInformationData",
				@"eMVCryptogramTransactionTypeField" : @"EMVCryptogramTransactionType",
				@"eMVDedicatedFileNameField" : @"EMVDedicatedFileName",
				@"eMVInterfaceDeviceSerialNumberField" : @"EMVInterfaceDeviceSerialNumber",
				@"eMVIssuerActionCodeDefaultField" : @"EMVIssuerActionCodeDefault",
				@"eMVIssuerActionCodeDenialField" : @"EMVIssuerActionCodeDenial",
				@"eMVIssuerActionCodeOnlineField" : @"EMVIssuerActionCodeOnline",
				@"eMVIssuerApplicationDataField" : @"EMVIssuerApplicationData",
				@"eMVIssuerCountryCodeField" : @"EMVIssuerCountryCode",
				@"eMVIssuerScriptResultsField" : @"EMVIssuerScriptResults",
				@"eMVPanSequenceNumber" : @"EMVPanSequenceNumber",
				@"eMVServiceCode" : @"EMVServiceCode",
				@"eMVShortFileIdentifier" : @"EMVShortFileIdentifier",
				@"eMVTerminalCapabilitiesField" : @"EMVTerminalCapabilities",
				@"eMVTerminalCountryCodeField" : @"EMVTerminalCountryCode",
				@"eMVTerminalTypeField" : @"EMVTerminalType",
				@"eMVTerminalVerificationResultsField" : @"EMVTerminalVerificationResults",
				@"eMVTransactionAmountField" : @"EMVTransactionAmount",
				@"eMVTransactionCategoryCodeField" : @"EMVTransactionCategoryCode",
				@"eMVTransactionCurrencyCodeField" : @"EMVTransactionCurrencyCode",
				@"eMVTransactionDateField" : @"EMVTransactionDate",
				@"eMVTransactionSequenceCounterIDField" : @"EMVTransactionSequenceCounterID",
				@"eMVTransactionStatusInformationField" : @"EMVTransactionStatusInformation",
				@"eMVUnpredictableNumberField" : @"EMVUnpredictableNumber",
			};
	});
	
	return map;
}

- (void)processCreditCard:(CDVInvokedUrlCommand*)command
{
	EGCardReaderManager* reader = [self.class cardReader];
	
	NSLog(@"got params: %@", command.arguments);
	
	BOOL refund = [command.arguments[REFUND_ARG] boolValue];
	NSInteger cardType = [command.arguments[CARD_TYPE_ARG] integerValue];
	NSDecimalNumber* amount = (NSDecimalNumber*) [[self.class currencyFormatter] numberFromString:command.arguments[AMOUNT_ARG]];
	NSString* currency = command.arguments[CURRENCY_ARG];
	
	id<EGCardTransaction> transaction = [EGCardTransactionFactory transactionWithType:(refund ? EGCardTransactionTypeRefund : EGCardTransactionTypePurchase)
																			   amount:amount
																		 currencyCode:currency
																				items:nil
																		   seatNumber:nil
																			fareClass:nil
																  frequentFlyerStatus:nil];
	
	EGTransactionCallback callback = ^(id<EGTransactionResult> transactionResult, id<EGCreditCardInfo> cardInfo, NSError *error) {
		if (error) {
			CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
			[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
		} else {
			NSDictionary* dict = [self dictionaryFromTransactionResult:transactionResult cardInfo:cardInfo];
			CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
			[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
		}
	};
	
	switch (cardType) {
		case MSRCardType: {
			[reader performSwipeTransaction:transaction withCallback:callback];
			break;
		}
			
		case NFCCardType: {
			[reader performNFCTransaction:transaction withCallback:callback];
			break;
		}
			
		case EMVCardType: {
			[reader performEMVTransaction:transaction withCallback:callback];
		}
	}
}

- (void)cancelCreditCardProcessing:(CDVInvokedUrlCommand*)command
{
	EGCardReaderManager* reader = [self.class cardReader];
	[reader cancelTransaction];
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (NSDictionary*)dictionaryFromTransactionResult:(id<EGTransactionResult>)result cardInfo:(id<EGCreditCardInfo>)cardInfo
{
	NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
	dict[@"trackData"] = result.cardTrackData;
	
	if (cardInfo.cardholderName.length > 0) {
		dict[@"cardholderName"] = cardInfo.cardholderName;
	}
	
	if (cardInfo.cardNumber.length > 0) {
		dict[@"cardNumber"] = cardInfo.cardNumber;
	}
	
	if (cardInfo.expirationDate.length > 0) {
		dict[@"expirationDate"] = cardInfo.expirationDate;
	}
	
	dict[@"cardType"] = [self.class stringForCardType:cardInfo.cardType];
	
	if ([result conformsToProtocol:@protocol(EGEMVTransactionResult)]) {
		NSObject* emvResult = result;
		
		NSDictionary* propertyMap = [self.class emvPropertyMap];
		for (NSString* key in propertyMap) {
			id value = [emvResult valueForKey:key];
			
			if (value) {
				NSString* dictKey = propertyMap[key];
				dict[dictKey] = value;
			}
		}
	}
	
	return dict.copy;
}

+ (NSString*)stringForCardType:(EGCreditCardType)cardType
{
	
	switch (cardType) {
		case EGVisaCreditCardType:			return @"VISA";
		case EGMastercardCreditCardType:	return @"MASTERCARD";
		case EGAmexCreditCardType:			return @"AMEX";
		case EGDiscoverCreditCardType:		return @"DISCOVER";
		case EGDinersCreditCardType:		return @"DINERS";
		case EGJCBCreditCardType:			return @"JCB";
		case EGCarteBlancheCreditCardType:	return @"CARTEBLANCHE";
		case EGDankortCreditCardType:		return @"DANKORT";
		case EGUnknownCreditCardType:		return @"UNKNOWN";
	}
}

@end


/**
 * Reads a credit card using the Ingenico device, and returns the result.
 * See the note below for more information on the success response.
 *
 * @param {Number}	cardType		1 = MSR, 2 = NFC, 3 = EMV
 * @param {Boolean}	refund			If true, this is a refund, rather than a purchase.
 * @param {String}	amount			The total amount of the transaction. This number must be formatted in en_US style.
 * @param {String}	currencyCode	Currency code for the transaction, such as 'USD'.
 * @param {Function} successCallback	A callback executed upon success. It takes a single string argument: an object, whose key-values contain the credit card data.
 * @param {Function} errorCallback	A callback executed upon failure. It takes a single string argument: an error message.
 */
window.processCreditCard = function(cardType, refund, amount, currencyCode, successCallback, errorCallback) {
	cordova.exec(successCallback, errorCallback, "EGCreditCardPlugin", "processCreditCard", [cardType, refund, amount, currencyCode]);
};

/*
 * The success callback will be passed an object/dictionary/map containing all the card
 * data that was read. For non-EMV cards, these values will be present:
 *
 * trackData
 * cardholderName
 * expirationDate
 * cardNumber
 * cardType
 *
 * For EMV cards, these additional fields will also be present (though some may have a nil value):
 *
 * EMVApplicationIdentifierCard
 * EMVApplicationCryptogram
 * EMVApplicationCurrencyCode
 * EMVApplicationInterchangeProfile
 * EMVApplicationTransactionCounter
 * EMVApplicationUsageControl
 * EMVApplicationVersionNumber
 * EMVAuthorisationResponseCode
 * EMVCardholderVerificationMethodResult
 * EMVCryptogramInformationData
 * EMVCryptogramTransactionType
 * EMVDedicatedFileName
 * EMVInterfaceDeviceSerialNumber
 * EMVIssuerActionCodeDefault
 * EMVIssuerActionCodeDenial
 * EMVIssuerActionCodeOnline
 * EMVIssuerApplicationData
 * EMVIssuerCountryCode
 * EMVIssuerScriptResults
 * EMVPanSequenceNumber
 * EMVServiceCode
 * EMVShortFileIdentifier
 * EMVTerminalCapabilities
 * EMVTerminalCountryCode
 * EMVTerminalType
 * EMVTerminalVerificationResults
 * EMVTransactionAmount
 * EMVTransactionCategoryCode
 * EMVTransactionCurrencyCode
 * EMVTransactionDate
 * EMVTransactionSequenceCounterID
 * EMVTransactionStatusInformation
 * EMVUnpredictableNumber
 */
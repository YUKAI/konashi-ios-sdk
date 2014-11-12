//
//  Konashi+JavaScriptCore.h
//  Konashi
//
//  Created by Akira Matsuda on 10/21/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "Konashi.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol KonashiJavaScriptBindings2 <JSExport>

+ (KonashiResult) uartWriteString:(NSString *)string;
JSExportAs(i2cWriteString, + (KonashiResult) i2cWriteString:(NSString *)data address:(unsigned char)address);

@end

@interface Konashi (JavaScriptBindings) <KonashiJavaScriptBindings2>

+ (KonashiResult) uartWriteString:(NSString *)string;
+ (KonashiResult) i2cWriteString:(NSString *)data address:(unsigned char)address;

@end

@interface KNSJavaScriptVirtualMachine : NSObject

+ (JSValue *)evaluateScript:(NSString *)script;
+ (JSValue *)callFunctionWithKey:(NSString *)key args:(NSArray *)args;
+ (void)addBridgeHandlerWithKey:(NSString *)key hendler:(void (^)(JSValue* value))handler;
+ (void)setBridgeVariableWithKey:(NSString *)key variable:(id)obj;
+ (JSValue *)getBridgeVariableWithKey:(NSString *)key;

@end

@interface KNSWebView : UIView
{
	UIWebView *webView;
	KNSJavaScriptVirtualMachine *vm;
}

@end

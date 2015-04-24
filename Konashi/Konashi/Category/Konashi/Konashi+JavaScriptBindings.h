//
//  Konashi+JavaScriptCore.h
//  Konashi
//
//  Created by Akira Matsuda on 10/21/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "Konashi.h"
#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

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

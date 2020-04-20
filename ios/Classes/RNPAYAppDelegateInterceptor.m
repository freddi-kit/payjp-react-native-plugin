/*
 *
 * Copyright (c) 2020 PAY, Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
#import "RNPAYAppDelegateInterceptor.h"
#import <GoogleUtilities/GULAppDelegateSwizzler.h>
@import PAYJP;

@implementation RNPAYAppDelegateInterceptor

+ (instancetype)sharedInstance {
  static dispatch_once_t once;
  static RNPAYAppDelegateInterceptor *sharedInstance;
  dispatch_once(&once, ^{
    sharedInstance = [[RNPAYAppDelegateInterceptor alloc] init];
    [GULAppDelegateSwizzler proxyOriginalDelegate];
    [GULAppDelegateSwizzler registerAppDelegateInterceptor:sharedInstance];
  });
  return sharedInstance;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)URL
            options:(NSDictionary<NSString *, id> *)options {
  BOOL result =
      [[PAYJPThreeDSecureProcessHandler sharedHandler] completeThreeDSecureProcessWithUrl:URL];
  return result;
}

- (BOOL)application:(UIApplication *)application
              openURL:(NSURL *)URL
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation {
  BOOL result =
      [[PAYJPThreeDSecureProcessHandler sharedHandler] completeThreeDSecureProcessWithUrl:URL];
  return result;
}

@end

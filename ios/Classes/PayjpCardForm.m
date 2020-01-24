//
//  PayjpCardForm.m
//  DoubleConversion
//
//  Created by Tadashi Wakayanagi on 2020/01/23.
//

#import "PayjpCardForm.h"
@import PAYJP;

@interface PayjpCardForm()

@property (nonatomic, copy) void (^completionHandler)(NSError * _Nullable);

@end

@implementation PayjpCardForm

- (NSArray<NSString *> *)supportedEvents {
    return @[@"onCardFormCanceled",
             @"onCardFormCompleted",
             @"onCardFormProducedToken"];
}

- (dispatch_queue_t)methodQueue {
  return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(startCardForm:(NSString *)tenantId
                        resolve:(RCTPromiseResolveBlock)resolve
                         reject:(__unused RCTPromiseRejectBlock)reject) {
    dispatch_async([self methodQueue], ^{
        PAYCardFormViewController *cardForm = [PAYCardFormViewController createCardFormViewControllerWithStyle:nil
                                                                                                      tenantId:tenantId];
        cardForm.delegate = self;
        UIViewController *hostViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
        if ([hostViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController*)hostViewController;
            [navigationController pushViewController:cardForm animated:YES];
        } else {
            UINavigationController *navigationController = [UINavigationController.new initWithRootViewController:cardForm];
            navigationController.presentationController.delegate = cardForm;
            [hostViewController presentViewController:navigationController animated:YES completion:nil];
        }
        resolve([NSNull null]);
    });
}

RCT_EXPORT_METHOD(completeCard:(RCTPromiseResolveBlock)resolve
                        reject:(__unused RCTPromiseRejectBlock)reject) {
    NSLog(@"completeCardForm");
    if (self.completionHandler != nil) {
        self.completionHandler(nil);
    }
    self.completionHandler = nil;
    resolve([NSNull null]);
}

RCT_EXPORT_METHOD(showTokenProcessingError:(NSString *)message
                                   resolve:(RCTPromiseResolveBlock)resolve
                                    reject:(__unused RCTPromiseRejectBlock)reject) {
    NSLog(@"showTokenProcessingError %@", message);
    if (self.completionHandler != nil) {
        NSDictionary *info = @{NSLocalizedDescriptionKey : message};
        NSError *error = [NSError errorWithDomain:@"payjp" code:0 userInfo:info];
        self.completionHandler(error);
    }
    self.completionHandler = nil;
    resolve([NSNull null]);
}

- (void)cardFormViewController:(PAYCardFormViewController *)_
               didCompleteWith:(enum CardFormResult)result {
    switch (result) {
      case CardFormResultCancel:
        NSLog(@"CardFormResultCancel");
        break;
      case CardFormResultSuccess:
        NSLog(@"CardFormResultSuccess");
        dispatch_async([self methodQueue], ^{
          UIViewController *hostViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
          if ([hostViewController isKindOfClass:[UINavigationController class]]) {
              UINavigationController *navigationController = (UINavigationController*)hostViewController;
              [navigationController popViewControllerAnimated:YES];
          } else {
              [hostViewController dismissViewControllerAnimated:YES completion:nil];
          }
        });
        break;
    }
}

- (void)cardFormViewController:(PAYCardFormViewController *)_
                   didProduced:(PAYToken *)token
             completionHandler:(void (^)(NSError * _Nullable))completionHandler {
    NSLog(@"token = %@", token);
    self.completionHandler = completionHandler;
}

@end

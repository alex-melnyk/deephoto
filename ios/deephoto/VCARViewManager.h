#import <React/RCTBridgeModule.h>
#import "deephoto-Swift.h"

@interface VCARViewManager : NSObject <RCTBridgeModule>

+ (ViewController *)sharedInstance;

@end

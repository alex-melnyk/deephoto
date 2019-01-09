#import "VCARViewManager.h"
#import "deephoto-Swift.h"

#import <objc/runtime.h>

@implementation VCARViewManager

RCT_EXPORT_MODULE(ARViewManager);

+ (ViewController *)sharedInstance
{
  static ViewController * instance = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    instance = [storyboard instantiateInitialViewController];
  });
  return instance;
}

RCT_EXPORT_METHOD(setARMapping:(NSString *)picture video:(NSString*)video)
{
  ViewController *instance = [VCARViewManager sharedInstance];
  [instance setNewMappingWithPicture:picture andVideo:video];
}

@end

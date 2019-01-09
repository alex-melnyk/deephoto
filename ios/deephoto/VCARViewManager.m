#import "VCARViewManager.h"
#import "deephoto-Swift.h"

#import <objc/runtime.h>

@implementation VCARViewManager

RCT_EXPORT_MODULE(RNARViewManager);

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

RCT_EXPORT_METHOD(addARMapping:(NSString *)picturePath video:(NSString*)videoPath)
{
  ViewController *instance = [VCARViewManager sharedInstance];
  [instance setNewMappingWithPicture:picturePath andVideo:videoPath];
}

@end

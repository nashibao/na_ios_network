
#import <Foundation/Foundation.h>

#import <Availability.h>

#import "SVProgressHUD.h"


typedef enum NAProgressHUDMaskType: NSUInteger{
    NAProgressHUDMaskTypeDefault = 200, //デフォルト用オプション
    NAProgressHUDMaskTypeDisabled = 100, //表示しないオプション
    NAProgressHUDMaskTypeNone = SVProgressHUDMaskTypeNone, // allow user interactions while HUD is displayed
    NAProgressHUDMaskTypeClear = SVProgressHUDMaskTypeClear, // don't allow
    NAProgressHUDMaskTypeBlack = SVProgressHUDMaskTypeBlack, // don't allow and dim the UI in the back of the HUD
    NAProgressHUDMaskTypeGradient = SVProgressHUDMaskTypeGradient // don't allow and dim the UI with a a-la-alert-view bg gradient
} NAProgressHUDMaskType;

@interface NANetworkActivityIndicatorActivityObject : NSObject
@property (strong, nonatomic) NSString *identifier;
@property (nonatomic) NSInteger activityCount;
@property (strong, nonatomic) NSMutableArray *errors;
@property (nonatomic) NAProgressHUDMaskType defaultProgressHUDMaskType;
@end


/** indicator manager
 */
@interface NANetworkActivityIndicatorManager : NSObject

/** enable option : default = YES */
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

/** getter. to be YES when network count > 0 */
@property (readonly, nonatomic, assign) BOOL isNetworkActivityIndicatorVisible;
@property (nonatomic) NAProgressHUDMaskType currentProgressHUDMaskType;

/** error array.
 */
@property (strong, nonatomic) NSMutableArray *errors;
@property (strong, nonatomic) NSMutableDictionary *activityObjectWithIdentifiers;

@property (nonatomic) BOOL enableSVProgress;
@property (nonatomic) NAProgressHUDMaskType defaultProgressHUDMaskType;

+ (NANetworkActivityIndicatorManager *)sharedManager;

- (void)incrementActivityCount:(NSString *)identifier maskType:(NAProgressHUDMaskType)maskType option:(NSDictionary *)option;
- (void)decrementActivityCount:(NSString *)identifier;
- (void)decrementActivityCount:(NSString *)identifier error:(NSString *)error;
- (void)insert:(NSString *)identifier error:(NSString *)error option:(NSDictionary *)option;

@end

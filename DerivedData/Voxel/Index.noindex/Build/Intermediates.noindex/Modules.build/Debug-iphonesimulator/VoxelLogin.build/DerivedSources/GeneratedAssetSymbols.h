#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "mobileEditPen" asset catalog image resource.
static NSString * const ACImageNameMobileEditPen AC_SWIFT_PRIVATE = @"mobileEditPen";

/// The "mobileOtp" asset catalog image resource.
static NSString * const ACImageNameMobileOtp AC_SWIFT_PRIVATE = @"mobileOtp";

#undef AC_SWIFT_PRIVATE

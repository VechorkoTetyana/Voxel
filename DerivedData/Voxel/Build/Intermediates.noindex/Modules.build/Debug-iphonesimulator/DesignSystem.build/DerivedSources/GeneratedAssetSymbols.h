#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"DesignSystem";

/// The "accent" asset catalog color resource.
static NSString * const ACColorNameAccent AC_SWIFT_PRIVATE = @"accent";

/// The "background" asset catalog color resource.
static NSString * const ACColorNameBackground AC_SWIFT_PRIVATE = @"background";

/// The "text" asset catalog color resource.
static NSString * const ACColorNameText AC_SWIFT_PRIVATE = @"text";

/// The "textGray" asset catalog color resource.
static NSString * const ACColorNameTextGray AC_SWIFT_PRIVATE = @"textGray";

/// The "mobileEditPen" asset catalog image resource.
static NSString * const ACImageNameMobileEditPen AC_SWIFT_PRIVATE = @"mobileEditPen";

#undef AC_SWIFT_PRIVATE

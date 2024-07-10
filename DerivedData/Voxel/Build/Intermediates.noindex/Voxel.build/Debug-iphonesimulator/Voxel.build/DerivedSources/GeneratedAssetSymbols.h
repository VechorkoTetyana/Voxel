#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "Chevron Left" asset catalog image resource.
static NSString * const ACImageNameChevronLeft AC_SWIFT_PRIVATE = @"Chevron Left";

#undef AC_SWIFT_PRIVATE

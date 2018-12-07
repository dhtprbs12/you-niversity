#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "Board.pbobjc.h"
#import "Common.pbobjc.h"
#import "Main.pbobjc.h"
#import "Mentor.pbobjc.h"
#import "University.pbobjc.h"
#import "User.pbobjc.h"
#import "Main.pbrpc.h"

FOUNDATION_EXPORT double universityVersionNumber;
FOUNDATION_EXPORT const unsigned char universityVersionString[];


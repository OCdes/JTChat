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

#import "JTVoiceConverter.h"
#import "interf_dec.h"
#import "interf_enc.h"
#import "XKLIMAMRFileCodec.h"
#import "XKLIMVoiceConverter.h"

FOUNDATION_EXPORT double JTVoiceConvertVersionNumber;
FOUNDATION_EXPORT const unsigned char JTVoiceConvertVersionString[];


//
// Created by admin on 14.02.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <UIKit/UIKit.h>

@interface NSString (Awad)

/// Returns bounds of the string with a passed font.
/// Used mainly for width calculation.
/// Line break mode is set to NSLineBreakByWordWrapping
- (CGSize)awad_boundsWithFont:(UIFont *)font;
/// Returns bounds of the string with a passed font.
/// Used mainly for width calculation.
/// Line break mode is set to NSLineBreakByWordWrapping
- (CGSize)awad_boundsWithFont:(UIFont *)font maxWidth:(CGFloat)width;
/// Returns bounds of the string with a passed font.
/// Used mainly for height calculation.
/// If wordWrap is YES – line break mode is set to NSLineBreakByWordWrapping,
/// otherwise it is NSLineBreakByTruncatingTail
- (CGSize)awad_boundsWithFont:(UIFont *)font maxWidth:(CGFloat)width useWordWrap:(BOOL)wordWrap;
/// Returns bounds of the string with a passed font and constraining size.
/// If wordWrap is YES – line break mode is set to NSLineBreakByWordWrapping,
/// otherwise it is NSLineBreakByTruncatingTail
- (CGSize)awad_boundsWithFont:(UIFont *)font maxSize:(CGSize)size useWordWrap:(BOOL)wordWrap;

@end

@interface NSString (Awad_Drawing)

- (void)awad_drawClippingInCenterOfRect:(CGRect)rect withFont:(UIFont *)font;
- (void)awad_drawClippingInCenterOfRect:(CGRect)rect withFont:(UIFont *)font color:(UIColor *)color;

@end

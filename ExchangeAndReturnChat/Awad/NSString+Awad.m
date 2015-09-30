//
// Created by admin on 14.02.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSString+Awad.h"


@implementation NSString (Awad)

/// Returns bounds of the string with a passed font.
/// Used mainly for width calculation.
- (CGSize)awad_boundsWithFont:(UIFont *)font {
    return [self awad_boundsWithFont:font maxWidth:CGFLOAT_MAX useWordWrap:NO];
}
- (CGSize)awad_boundsWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth {
    return [self awad_boundsWithFont:font maxWidth:maxWidth useWordWrap:YES];
}
- (CGSize)awad_boundsWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth useWordWrap:(BOOL)wordWrap {
    return [self awad_boundsWithFont:font maxSize:CGSizeMake(maxWidth, CGFLOAT_MAX) useWordWrap:wordWrap];
}

- (CGSize)awad_boundsWithFont:(UIFont *)font maxSize:(CGSize)maxSize useWordWrap:(BOOL)wordWrap {
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithDictionary:@{NSFontAttributeName: font}];

    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    if (wordWrap) {
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    } else {
        paragraph.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    attributes[NSParagraphStyleAttributeName] = paragraph;

    return [self boundingRectWithSize:maxSize
                              options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                           attributes:attributes
                              context:nil].size;
}

@end


@implementation NSString (Awad_Drawing)

- (void)awad_drawClippingInCenterOfRect:(CGRect)rect withFont:(UIFont *)font {
    [self awad_drawClippingInCenterOfRect:rect withFont:font color:[UIColor whiteColor]];
}

- (void)awad_drawClippingInCenterOfRect:(CGRect)rect withFont:(UIFont *)font color:(UIColor *)color {
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByClipping;
    paragraph.alignment = NSTextAlignmentCenter;

    [self drawInRect:rect withAttributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraph, NSForegroundColorAttributeName: color}];
}

@end

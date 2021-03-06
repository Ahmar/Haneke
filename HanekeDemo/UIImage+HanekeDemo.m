//
//  UIImage+HanekeDemo.m
//  Haneke
//
//  Created by Hermes on 13/02/14.
//  Copyright (c) 2014 Hermes Pique. All rights reserved.
//

#import "UIImage+HanekeDemo.h"

@implementation UIImage (HanekeDemo)

- (UIImage*)demo_imageByCroppingRect:(CGRect)rect
{
    rect = CGRectMake(rect.origin.x * self.scale,
                      rect.origin.y * self.scale,
                      rect.size.width * self.scale,
                      rect.size.height * self.scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

- (UIImage*)demo_imageByDrawingColoredText:(NSString *)text
{
    const CGSize size = self.size;
    const CGFloat pointSize = MIN(size.width, size.height) / 2;
    UIFont *font = [UIFont boldSystemFontOfSize:pointSize];
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIColor *color = [UIImage demo_randomColor];
    NSDictionary *attributes = @{NSFontAttributeName : font, NSForegroundColorAttributeName : color};
    CGSize textSize = [text sizeWithAttributes:attributes];
    CGRect rect = CGRectMake((size.width - textSize.width) / 2, (size.height - textSize.height) / 2, textSize.width, textSize.height);
    [text drawInRect:rect withAttributes:attributes];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage*)demo_randomImageWithIndex:(NSUInteger)index
{
    // Photo by Paul Sableman, taken from http://www.flickr.com/photos/pasa/8636568094
    UIImage *sample = [UIImage imageNamed:@"sample.jpg"];
    NSString *indexString = [NSString stringWithFormat:@"%ld", (long)index + 1];
    
    CGFloat width = arc4random_uniform(sample.size.width - 100) + 1 + 100;
    CGFloat height = arc4random_uniform(sample.size.height - 100) + 1 + 100;
    CGFloat x = arc4random_uniform(sample.size.width - width + 1);
    CGFloat y = arc4random_uniform(sample.size.height - height + 1);
    CGRect cropRect = CGRectMake(x, y, width, height);
    UIImage *cropped = [sample demo_imageByCroppingRect:cropRect];
    return [cropped demo_imageByDrawingColoredText:indexString];
}

+ (UIColor*)demo_randomColor
{
    CGFloat r = arc4random_uniform(255 + 1) / 255.0;
    CGFloat g = arc4random_uniform(255 + 1) / 255.0;
    CGFloat b = arc4random_uniform(255 + 1) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

@end

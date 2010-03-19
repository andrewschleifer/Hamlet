#import <Cocoa/Cocoa.h>

@interface WordView : NSView
{
    NSString *stringValue;
	NSColor *foregroundColor;
	NSColor *backgroundColor;
}

@property(nonatomic, copy) NSString *stringValue;
@property(nonatomic, copy) NSColor *foregroundColor;
@property(nonatomic, copy) NSColor *backgroundColor;

@end

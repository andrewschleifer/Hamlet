#import <Cocoa/Cocoa.h>

@interface VRBigWordView : NSView
{
    NSString * stringValue;
	NSColor * foregroundColor;
	NSColor * backgroundColor;
}

-(NSString *)stringValue;
-(void)setStringValue:(NSString *)aWord;

-(NSColor *)foregroundColor;
-(void)setForegroundColor:(NSColor *)newColor;

-(NSColor *)backgroundColor;
-(void)setBackgroundColor:(NSColor *)newColor;

@end

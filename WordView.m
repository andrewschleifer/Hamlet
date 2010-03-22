#import "WordView.h"

@implementation WordView

@synthesize foregroundColor;
@synthesize backgroundColor;

#pragma mark -
#pragma mark Setup/Teardown

-(void)awakeFromNib
{
    foregroundColor = [NSColor blackColor];
    backgroundColor = [NSColor whiteColor];
}

-(void)dealloc
{
    [stringValue release];
    [foregroundColor release];
    [backgroundColor release];
    [super dealloc];
}

#pragma mark Accessor/Mutator

-(NSString*)stringValue
{
    return stringValue;
}

-(void)setStringValue:(NSString*)s
{
    if (stringValue != s)
    {
        [stringValue release];
        stringValue = [s copy];
        [self setNeedsDisplay: YES];
    }
}

#pragma mark Drawing

-(void)drawRect:(NSRect)rect
{
    const float fontSizeRatio = 1.2;

    NSRect bounds = [self bounds];
    [[self backgroundColor] set];
    NSRectFill(bounds);
    const float baseFontSize = 30.0;
    NSString *fontName = @"Times New Roman";

    NSAttributedString *attributedString = [[NSAttributedString alloc]
        initWithString:@"12CHARACTERS" attributes:[NSDictionary dictionaryWithObjectsAndKeys: 
            [NSFont fontWithName:fontName size:baseFontSize], NSFontAttributeName, nil]];

    NSSize stringSize = [attributedString size];
    [attributedString release]; 

    float biggestRatio = MAX(stringSize.width / NSWidth(bounds), stringSize.height / NSHeight(bounds));
    float fontSize = (baseFontSize / biggestRatio) / fontSizeRatio;

    attributedString = [[NSAttributedString alloc] initWithString:stringValue attributes:
        [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:fontName size:fontSize],
            NSFontAttributeName, [self foregroundColor], NSForegroundColorAttributeName, nil]];
    stringSize = [attributedString size];

    [attributedString drawInRect:NSMakeRect((NSWidth(bounds) - stringSize.width) / 2,
                                            (NSHeight(bounds) - stringSize.height) / 2 + stringSize.height / 15, stringSize.width, stringSize.height)];

    [attributedString release];
}

@end

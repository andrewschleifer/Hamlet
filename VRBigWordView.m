#import "VRBigWordView.h"

@implementation VRBigWordView

#pragma mark -
#pragma mark Setup/Teardown

+(void)initialize
{
	[self exposeBinding:@"stringValue"];
	[self exposeBinding:@"foregroundColor"];
	[self exposeBinding:@"backgroundColor"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	
	if (self)
	{
		if ([decoder allowsKeyedCoding])
		{
			[self setStringValue:[decoder decodeObjectForKey:@"stringValue"]];
			[self setForegroundColor:[decoder decodeObjectForKey:@"foregroundColor"]];
			[self setBackgroundColor:[decoder decodeObjectForKey:@"backgroundColor"]];
		}
		else
		{
			[self setStringValue:[decoder decodeObject]];
			[self setForegroundColor:[decoder decodeObject]];
			[self setBackgroundColor:[decoder decodeObject]];
		}
	}
	
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
	[super encodeWithCoder:coder];
	
	if([coder allowsKeyedCoding])
	{
		[coder encodeObject:[self stringValue] forKey:@"stringValue"];
		[coder encodeObject:[self foregroundColor] forKey:@"foregroundColor"];
		[coder encodeObject:[self backgroundColor] forKey:@"backgroundColor"];
	}
	else
	{
		[coder encodeObject:[self stringValue]];
		[coder encodeObject:[self foregroundColor]];
		[coder encodeObject:[self backgroundColor]];
	}
}

-(void)dealloc
{
	[stringValue release];
	[foregroundColor release];
	[backgroundColor release];
	[super dealloc];
}

#pragma mark Accessors

-(NSString *)stringValue;
{
	return stringValue;
}

-(void)setStringValue:(NSString *)aWord;
{
	[aWord retain];
    [stringValue release];
    stringValue = aWord;
    [self setNeedsDisplay:YES];
}

-(NSColor *)foregroundColor;
{
	return foregroundColor;
}

-(void)setForegroundColor:(NSColor *)newColor;
{
	[newColor retain];
    [foregroundColor release];
    foregroundColor = newColor;
    [self setNeedsDisplay:YES];
}

-(NSColor *)backgroundColor;
{
	return backgroundColor;
}

-(void)setBackgroundColor:(NSColor *)newColor;
{
	[newColor retain];
    [backgroundColor release];
    backgroundColor = newColor;
    [self setNeedsDisplay:YES];
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

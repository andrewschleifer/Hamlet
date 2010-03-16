#import "BookController.h"

@implementation BookController

#pragma mark -
#pragma mark Setup and Teardown

-(BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError;
{
	[self setPlaying:NO];
	
	NSMutableArray * newWords = [NSMutableArray array];
	NSString *fileContents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSScanner *fileScanner = [NSScanner scannerWithString:fileContents];
	[fileContents release];
	NSCharacterSet *acceptableCharacters = [[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet];
	while ([fileScanner isAtEnd] == NO)
	{
		NSString * nextWord;
		[fileScanner scanCharactersFromSet:acceptableCharacters intoString:&nextWord];
		[newWords addObject:[nextWord copy]];
	}
	[self setWords:newWords];
	
	[self setRate:0.3];
	
    return YES;
}

-(NSString *)windowNibName;
{
    return @"BookViewer";
}

-(BOOL)windowShouldClose:(id)sender
{
	[timer invalidate];
	return YES;
}

#pragma mark Accessors and Mutators

-(BOOL)playing;
{
	return playing;
}
-(void)setPlaying:(BOOL)newState;
{
	playing = newState;
}

-(NSArray *)words;
{
	return words;
}

-(void)setWords:(NSArray *)newWords;
{
	[newWords retain];
    [words release];
    words = newWords;
}

-(double)rate;
{
	return rate;
}

-(void)setRate:(double)newRate;
{
	rate = newRate;
}

#pragma mark Other?

-(IBAction)togglePlayAndPause:(id)sender;
{
	if ([self playing])
	{
		// pause
		[timer invalidate];
		[controlButton setTitle:@"Play"];
		[self setPlaying:NO];
	}
	else
	{
		// play
		timer = [NSTimer scheduledTimerWithTimeInterval:rate target:self selector:@selector(advance) userInfo:nil repeats:NO];
		[controlButton setTitle:@"Pause"];
        [self setPlaying:YES];
	}
}

-(void)advance;
{
	if(!playing)
		return;
	[wordController selectNext:self];
	timer = [NSTimer scheduledTimerWithTimeInterval:rate target:self selector:@selector(advance) userInfo:nil repeats:NO];
}

@end

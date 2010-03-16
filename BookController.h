#import <Cocoa/Cocoa.h>

@interface BookController : NSDocument {
	IBOutlet NSArrayController * wordController;
	IBOutlet NSButton * controlButton;
	IBOutlet BOOL playing;
	IBOutlet NSArray * words;
	IBOutlet double rate;
	NSTimer * timer;
}

-(BOOL)playing;
-(void)setPlaying:(BOOL)newState;

-(NSArray *)words;
-(void)setWords:(NSArray *)newWords;

-(double)rate;
-(void)setRate:(double)newRate;

-(IBAction)togglePlayAndPause:(id)sender;
-(void)advance;

@end

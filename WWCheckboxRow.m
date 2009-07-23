//
//  WWCheckboxRow.m
//  WWCardEditor
//
//  Created by Dan Grover on 7/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WWCheckboxRow.h"


@interface WWCheckboxRow()
@property(retain) NSButton *checkbox;
- (void) _layoutIfNeeded;
@end

#pragma mark -

@implementation WWCheckboxRow
@synthesize checkbox;

- (id)init{
    if (self = [super initWithFrame:NSZeroRect]){
		self.checkbox = [[[NSButton alloc] initWithFrame:NSZeroRect] autorelease];
		
		[checkbox setButtonType:NSSwitchButton];
		[checkbox setBezelStyle:NSRegularSquareBezelStyle];
		[self addSubview:checkbox];
		needsLayout = YES;
    }
	
    return self;
}

- (void)dealloc {
	self.checkbox = nil;
	
    [super dealloc];
}
						 
- (void) _layoutIfNeeded{
	if(needsLayout){
		NSLog(@"Laying out checkbox: %f",[parentEditor frame].size.width);
		[checkbox setFrame:NSMakeRect(0,0,[parentEditor frame].size.width,20)];
		needsLayout = NO;
	}
}

- (CGFloat) neededHeight{
	return 20;
}
						
#pragma mark -
#pragma mark Accessors

- (BOOL)isChecked {
	return [checkbox intValue];
}

- (void)setIsChecked:(BOOL)flag {
	[checkbox setIntValue:flag];
}

- (NSString *)label {
	return [checkbox title];
}

- (void)setLabel:(NSString *)aLabel {
	[checkbox setTitle:aLabel];
}

#pragma mark -

- (BOOL) isFlipped{
	return YES;
}

- (void)drawRect:(NSRect)rect {
	[self _layoutIfNeeded];
	[super drawRect:rect];
}

@end

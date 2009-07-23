//
//  WWCardEditorRow.m
//  WWCardEditor
//
//  Created by Dan Grover on 6/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WWCardEditorRow.h"
#import "WWCardEditor_Internals.h"

@implementation WWCardEditorRow
@synthesize parentEditor, parentRow, editMode;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		
    }
    return self;
}


- (CGFloat) neededHeight{
	return 0;
	//@throw [NSException exceptionWithName:@"WWCardEditorRow" reason:@"WWCardEditorRow had neededHeight called on it -- this should not be used directly" userInfo:nil];
}

- (void)drawRect:(NSRect)rect{
	[[NSColor redColor] set];
	//[NSBezierPath strokeRect:[self bounds]];
	[super drawRect:rect];
}


- (CGFloat) availableWidth{
	if(parentRow){
		return [parentRow availableWidth];
	}else{
		return [parentEditor frame].size.width;
	}
}

- (NSRectArray) requestedFocusRectArrayAndCount:(NSUInteger *)count{
	
	*count = 0;
	return nil;
}

- (BOOL) isFlipped{
	return YES;
}

@end

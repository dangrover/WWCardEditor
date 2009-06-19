//
//  WWFlowingFieldContainer.m
//  WWCardEditor
//
//  Created by Dan Grover on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WWFlowFieldRow.h"
#import "WWFlowFieldRowTextView.h"

#import "WWFlowFieldRow_Internals.h"

#pragma mark -

@implementation WWFlowFieldRow
@synthesize _textView, activeField;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		WWFlowFieldRowTextView *view = [[[WWFlowFieldRowTextView alloc] initWithFrame:NSMakeRect(0,0,frame.size.width,frame.size.height)] autorelease];
		view.container = self;
		self._textView = view;
		
		[_textView setDelegate:self];
		[_textView setContinuousSpellCheckingEnabled:NO];
		[_textView setEditable:YES];
		[_textView setDrawsBackground:NO];
		[_textView setTextContainerInset:NSMakeSize(0,0)];
		[_textView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
		[self setAutoresizesSubviews:YES];

		// TODO autoresize
		[self addSubview:_textView];
		
		// Default params
		self.editBoxPadding = WWFlowFieldContainer_DefaultEditBoxPadding;
		[self setEditMode:YES];
    }
    return self;
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow{
	// Register for notifications when the window becomes or resigns key, so that we can redraw the control
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self name:NSWindowDidBecomeKeyNotification object:[self window]];
	[nc removeObserver:self name:NSWindowDidResignKeyNotification object:[self window]];
	
	[nc addObserver:self selector:@selector(setNeedsDisplay) name:NSWindowDidBecomeKeyNotification object:newWindow];
	[nc addObserver:self selector:@selector(setNeedsDisplay) name:NSWindowDidResignKeyNotification object:newWindow];
}

- (void)setNeedsDisplay{
	[self setNeedsDisplay:YES];
}

- (void) dealloc{
	[_textView release];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidBecomeKeyNotification object:[self window]];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResignKeyNotification object:[self window]];
	[super dealloc];
}

#pragma mark -

- (NSArray *)fields {
    return fields; 
}

- (void)setFields:(NSArray *)aFields {
    if (fields != aFields) {
        [fields release];
        fields = [aFields retain];
    }
	
//	[_textView resignFirstResponder];
	[[_textView textStorage] setAttributedString:[self _renderedText]];
}

- (CGFloat)editBoxPadding {
    return editBoxPadding;
}

- (void)setEditBoxPadding:(CGFloat)anEditBoxPadding {
    editBoxPadding = anEditBoxPadding;
	[self setNeedsDisplay:YES];
}

- (NSUInteger)activeField {
    return activeField;
}

- (void)setActiveField:(NSUInteger)anActiveField {
	if((anActiveField >= [fields count]) && (anActiveField != NSNotFound)){
		return;
	}
	
	NSUInteger oldField = activeField;
    activeField = anActiveField;
	

	if(activeField != oldField){
		if(activeField == NSNotFound){ // If there's no field selected, then make no text selected
			if([_textView selectedRange].location != NSNotFound){
				[_textView setSelectedRange: NSMakeRange(0, 0)];
			}
		}else{ // Otherwise, select all text in the new active field
			[_textView setSelectedRange:[self _rangeForFieldAtIndex:activeField]];
		}
	}
	
}

- (BOOL)editMode {
    return editMode;
}

- (void)setEditMode:(BOOL)flag {
	if(editMode != flag){
		
		if(editMode){ // coming out of edit mode
			self.activeField = NSNotFound;
		}else{ // going into edit mode
			self.activeField = 0;
		}
		
		editMode = flag;
		[_textView setEditable:flag];
		[self setNeedsDisplay];
	}
}


#pragma mark -

- (NSAttributedString *) _renderedText{
	NSMutableAttributedString *soFar = [[[NSMutableAttributedString alloc] initWithString:@""] autorelease];
	
	for(WWFlowFieldSubfield *field in fields){
		[soFar appendAttributedString:[field _displayString]];
	}
	
	return soFar;
}

- (NSUInteger) _indexOfFieldForCharOffset:(NSUInteger)offsetDesired{
	
	unsigned offsetReached = 0;
	
	for(NSUInteger i = 0; i < [fields count]; i++){
		WWFlowFieldSubfield *field = [fields objectAtIndex:i];
		unsigned len = [field.value length];
		
		if((offsetDesired >= offsetReached) && (offsetDesired < (offsetReached+len))){
			return i;
		}
		
		offsetReached += len;
	}
	
	return NSNotFound;
}

- (NSUInteger) _charOffsetForBeginningOfFieldAtIndex:(NSUInteger)fieldIndex{
	if(fieldIndex >= [fields count]){
		return NSNotFound;
	}
	
	NSUInteger soFar = 0;
	
	for(NSUInteger i = 0; i <= fieldIndex; i++){
		if(i == fieldIndex){
			return soFar;
		}else{
			WWFlowFieldSubfield *field = [fields objectAtIndex:i];
			soFar += [field.value length];
		}
	}
	
	return NSNotFound;
}

- (NSUInteger) _charOffsetForEndOfFieldAtIndex:(NSUInteger)fieldIndex{
	if(fieldIndex >= [fields count]){
		return NSNotFound;
	}
	
	NSUInteger beginning = [self _charOffsetForBeginningOfFieldAtIndex:fieldIndex];
	if(beginning == NSNotFound){
		return NSNotFound;
	}
	
	return beginning + [((WWFlowFieldSubfield *)[fields objectAtIndex:fieldIndex]).value length];
}


- (NSRange) _rangeForFieldAtIndex:(NSUInteger)fieldIndex{
	if(fieldIndex >= [fields count]){
		return NSMakeRange(NSNotFound, 0);
	}

	return NSMakeRange([self _charOffsetForBeginningOfFieldAtIndex:fieldIndex], 
					   [((WWFlowFieldSubfield *)[fields objectAtIndex:fieldIndex]).value length]);
}


#pragma mark -
#pragma mark Text View Delegate

- (NSRange)textView:(NSTextView *)textView willChangeSelectionFromCharacterRange:(NSRange)oldSelectedCharRange toCharacterRange:(NSRange)newSelectedCharRange{
	
	NSLog(@"oldRange = %@, newRange = %@",NSStringFromRange(oldSelectedCharRange),NSStringFromRange(newSelectedCharRange));
	[self setNeedsDisplay:YES];
	
	
	if(!editMode || (activeField == NSNotFound)){
		return newSelectedCharRange; // If we're not in edit mode, they can select anything they want
	}
	
	if (newSelectedCharRange.location == NSNotFound){
		NSLog(@"Allowing no selection");
		return newSelectedCharRange; // no selection, that's cool.
	}
	
	NSUInteger fieldIndex = [self _indexOfFieldForCharOffset:newSelectedCharRange.location];
	if(fieldIndex == NSNotFound){
		// This could mean that they're changing the insertion point to the very end of the text, and the very end of the last mutable field.
		// Or it could mean they're trying to change the selection to none (by clicking on an invalid field), so we just set the field to Not Found and let them have no active field selected.
		
		if((newSelectedCharRange.location == [[_textView string] length]) && [[fields lastObject] editable]){
			activeField = [fields count] - 1;
		}else{
			activeField = NSNotFound;
		}
		
		return newSelectedCharRange;
	}
	
	// Check that we don't cross fields
	NSUInteger fieldStartChar = [self _charOffsetForBeginningOfFieldAtIndex:fieldIndex];
	NSUInteger fieldEndChar   = [self _charOffsetForEndOfFieldAtIndex:fieldIndex];
	
	if(fieldIndex != activeField){
		WWFlowFieldSubfield *field = [fields objectAtIndex:fieldIndex];
		
		// Figure out if they're just trying to type at the end of this field or fuck with the next one
		if((fieldIndex == (activeField + 1)) && (newSelectedCharRange.length == 0) && (newSelectedCharRange.location == fieldStartChar)){
			return newSelectedCharRange; // allow it. We interpret this scenario in -textView:shouldChangeTextInRange:replacementString:
		}

		// Allow them to change to the new field, but not if it's immutable or nonexistent 
		if(!field || !field.editable){
			NSLog(@"REJECTED AT CHANGE: immutable field");
			return oldSelectedCharRange;
		}
		else{
			// Okay, that's cool, you can change fields, but we're gonna have to select the whole field
			self.activeField = fieldIndex;
			return NSMakeRange(fieldStartChar, field.value.length);
		}
	}
	
	return newSelectedCharRange;
}


- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString{
	NSLog(@"Changing text in range %@, new string = %@",NSStringFromRange(affectedCharRange), replacementString);
	
	if(!editMode || (activeField == NSNotFound)){
		return NO;
	}
	
	NSUInteger startFieldIndex = [self _indexOfFieldForCharOffset:affectedCharRange.location];
	NSUInteger endFieldIndex   = [self _indexOfFieldForCharOffset:affectedCharRange.location + affectedCharRange.length];
	NSUInteger startFieldStartChar = [self _charOffsetForBeginningOfFieldAtIndex:startFieldIndex];
	
	// Newlines are not allowed in these fields
	// If someone enters or pastes one, we're going to strip it, and then handle the updating of the textView ourselves (by returning NO).
	NSString *newlineScrubbedReplacementString = [[replacementString stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
	BOOL overrideHandling = ![newlineScrubbedReplacementString isEqual:replacementString]; 
	
	// Anyway...
	// If we are in the middle of an editable field, just replace the equivilent range in the "field"'s .value property.
	// If we're at the *end* of an editable field (but in reality just a 0-len selection at the start of the next), then append the text.
	
	if((startFieldIndex == NSNotFound) || ((affectedCharRange.length == 0) && (affectedCharRange.location == startFieldStartChar) && (startFieldIndex == (activeField + 1)))){
		WWFlowFieldSubfield *field = [fields objectAtIndex:activeField];
		field.value = [field.value stringByAppendingString:newlineScrubbedReplacementString];
	}else{
		// translate affectedCharRange locally
		NSRange localRange = NSMakeRange(affectedCharRange.location - startFieldStartChar, affectedCharRange.length);
		WWFlowFieldSubfield *startField = [fields objectAtIndex:startFieldIndex];
		startField.value = [startField.value stringByReplacingCharactersInRange:localRange withString:newlineScrubbedReplacementString];
	}

	if(overrideHandling){
		// If this is reached, we're going to put the new text there on behalf of the textfield since it would have put the return-carriage-laden
		// text in its place.
		
		NSRange oldSelectedRange = [_textView selectedRange]; // Remember the old selection range to give the appearance that the textField is handling this action, not us
		
		[[_textView textStorage] setAttributedString:[self _renderedText]];
		
		oldSelectedRange.location += newlineScrubbedReplacementString.length;
		oldSelectedRange.length = 0;
		
		[_textView setSelectedRange:oldSelectedRange];
		
		[self setNeedsDisplay];
		return NO;
	}else{
		[self setNeedsDisplay];
		return YES;
	}
}

#pragma mark -

- (void)drawRect:(NSRect)rect {
	NSPoint containerOrigin	 = [_textView textContainerOrigin];
	CGContextRef myContext = [[NSGraphicsContext currentContext] graphicsPort];
	
	[[NSColor whiteColor] set];
	NSRectFill([self bounds]);

	if(!editMode || (activeField == NSNotFound)) return; // no special drawing
	
	NSRange activeFieldRange = [self _rangeForFieldAtIndex:self.activeField];

	NSUInteger rectCount = 0;
	NSRectArray rects = [[_textView layoutManager] rectArrayForCharacterRange:activeFieldRange 
												 withinSelectedCharacterRange:NSMakeRange(NSNotFound, 0) 
															  inTextContainer:[_textView textContainer] 
																	rectCount:&rectCount];
	
	CGMutablePathRef glyphPath = CGPathCreateMutable();
	CGMutablePathRef outerGlyphPath = CGPathCreateMutable();
	
	for(unsigned i = 0; i < rectCount; i++){
		NSRect nsRect = rects[i];
		CGRect cgRect = CGRectMake(floor(nsRect.origin.x - editBoxPadding + containerOrigin.x), 
								   floor(nsRect.origin.y - editBoxPadding + containerOrigin.y), 
								   floor(nsRect.size.width + editBoxPadding * 2.0f), 
								   floor(nsRect.size.height + editBoxPadding * 2.0f));
		
		cgRect = CGRectInset(cgRect, -0.5, -0.5); // avoid drawing on pixel cracks
		
		CGPathAddRect(glyphPath, nil, cgRect);
		CGPathAddRect(outerGlyphPath, nil, CGRectInset(cgRect, -1, -1));
	}
	

	CGContextBeginPath(myContext);
	CGContextAddPath(myContext, glyphPath);
	CGContextClosePath(myContext);
	
	// Draw a fancy drop shadow if our window has focus
	if([[self window] isKeyWindow]){
		CGContextSetShadowWithColor(myContext, CGSizeMake(2, -3), 5.0, [[NSColor colorWithDeviceWhite:0 alpha:0.9] asCGColor]);
	}

	[[NSColor whiteColor] set];
	CGContextFillPath(myContext);
	
	CGContextSetShadowWithColor(myContext, CGSizeMake(0,0), 0, nil);
	
	CGContextBeginPath(myContext);
	CGContextAddPath(myContext, outerGlyphPath);
	CGContextClosePath(myContext);
	
	[[NSColor lightGrayColor] set];
	CGContextStrokePath(myContext);
}


- (BOOL) isFlipped{
	return YES;
}


- (CGFloat) neededHeight{
	NSRect boundingRect = [[_textView layoutManager] boundingRectForGlyphRange:[[_textView layoutManager] glyphRangeForTextContainer:[_textView textContainer]]
															   inTextContainer:[_textView textContainer]];
	
	NSLog(@"Needed height for flow field contianer is %@",NSStringFromRect(boundingRect));
	return 50;
}
@end
//
//  WWFlowFieldContainer_Internals.h
//  WWCardEditor
//
//  Created by Dan Grover on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface WWFlowFieldRow()
@property(retain) NSTextView *_textView;
@property(assign) BOOL isRendering;
@property(assign) BOOL inUse;

- (NSAttributedString *) _renderedText;

- (NSUInteger) _indexOfFieldForCharOffset:(NSUInteger)offsetDesired;

- (NSUInteger) _charOffsetForBeginningOfFieldAtIndex:(NSUInteger)fieldIndex;
- (NSUInteger) _charOffsetForEndOfFieldAtIndex:(NSUInteger)fieldIndex;
- (NSRange) _rangeForFieldAtIndex:(NSUInteger)fieldIndex;

- (BOOL) _fieldShouldBeDisplayedAsPlaceholder:(WWFlowFieldSubfield *)field;

- (NSDictionary *)_attributesForSubfield:(WWFlowFieldSubfield *)field;
- (NSString *) _displayedStringForField:(WWFlowFieldSubfield *)field;

- (BOOL) hasActiveField;
- (void) _selectNextSubfieldOrRow;
- (void) _selectPreviousSubfieldOrRow;
@end
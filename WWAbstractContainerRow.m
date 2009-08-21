//
//  WWAbstractContainerRow.m
//  WWCardEditor
//
//  Created by Dan Grover on 8/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WWAbstractContainerRow.h"
#import "WWCardEditor_Internals.h"

@implementation WWAbstractContainerRow
@synthesize _subrowsByName, _subrows;

- (id)initWithName:(NSString *)theName{
    if (self = [super initWithName:theName]){
        self._subrows = [NSMutableArray array];
		self._subrowsByName = [NSMutableDictionary dictionary];
		_needsLayout = YES;
    }
    return self;
}

- (void) dealloc{
	self._subrows = nil;
	self._subrowsByName = nil;
	[super dealloc];
}

#pragma mark -

- (void)drawRect:(NSRect)rect {
    
}

- (NSArray *)subrows{
	return _subrows;
}

- (void) addSubrow:(WWCardEditorRow *)row{
	[self insertSubrow:row atIndex:[_subrows count]];
}


- (void) insertSubrow:(WWCardEditorRow *)row atIndex:(NSUInteger)newRowIndex{
	[self willChangeValueForKey:@"subrowsByName"];
	[self willChangeValueForKey:@"subrows"];
	
	[_subrows insertObject:row atIndex:newRowIndex];
	if([row name]) [_subrowsByName setObject:row forKey:[row name]];
	
	row.parentEditor = parentEditor;
	row.parentRow = self;
	
	[self addSubview:row];
	
	[self didChangeValueForKey:@"subrowsByName"];
	[self didChangeValueForKey:@"subrows"];
	
	_needsLayout = YES;
}


- (void) removeSubrowAtIndex:(NSUInteger)removeRowIndex{
	[self willChangeValueForKey:@"subrowsByName"];
	[self willChangeValueForKey:@"subrows"];
	
	WWCardEditorRow *subrow = [_subrows objectAtIndex:removeRowIndex];
	if ([subrow name]) [_subrowsByName removeObjectForKey:[subrow name]];
	
	[subrow removeFromSuperview];
	
	subrow.parentRow = nil;
	subrow.parentEditor = nil;
	
	[self didChangeValueForKey:@"subrowsByName"];
	[self didChangeValueForKey:@"subrows"];
	
	_needsLayout = YES;
}

- (void)setParentEditor:(WWCardEditor *)aParentEditor{
	for(WWCardEditorRow *subrow in _subrows){
		[subrow setParentEditor:aParentEditor];
	}
	
	[super setParentEditor:aParentEditor];
}

- (void)setEditMode:(BOOL)flag {
	for(WWCardEditorRow *subrow in _subrows){
		[subrow setEditMode:flag];
	}
	
	[super setEditMode:flag];
}

- (NSArray *) principalResponders{
	NSMutableArray *responders = [NSMutableArray array];
	
	for(WWCardEditorRow *subrow in _subrows){
		[responders addObjectsFromArray:[subrow principalResponders]];
	}
	
	return responders;
}


- (NSRectArray) requestedFocusRectArrayAndCount:(NSUInteger *)count{
	if (![_subrows count]) return [super requestedFocusRectArrayAndCount:count];
	
	unsigned totalRects = 0;
	for(WWCardEditorRow *subrow in _subrows){
		NSUInteger subrowRectCount = 0;
		[subrow requestedFocusRectArrayAndCount:&subrowRectCount];
		totalRects += subrowRectCount;
	}
	
	NSRectArray allRects = calloc(totalRects, sizeof(NSRect));
	
	unsigned rectsSoFar = 0;
	
	for(WWCardEditorRow *subrow in _subrows){
		NSUInteger subrowRectCount = 0;
		NSRectArray subrowRects = [subrow requestedFocusRectArrayAndCount:&subrowRectCount];
		for(unsigned i = 0; i < subrowRectCount; i++){
			NSRect rect = subrowRects[i];
			rect.origin.x += [subrow frame].origin.x;
			rect.origin.y += [subrow frame].origin.y;
			
			allRects[rectsSoFar] = rect;
			rectsSoFar++;
		}
	}
	
	*count = totalRects;
	return allRects;
}



@end

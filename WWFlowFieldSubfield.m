//
//  WWFlowFields.m
//  WWCardEditor
//
//  Created by Dan Grover on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WWFlowFieldSubfield.h"

@implementation WWFlowFieldSubfield 
@synthesize name, value, font, editable, placeholder;

- (id) initWithName:(NSString *)theName{
	if(self = [super init]){
		self.font		 = [NSFont fontWithName:@"Helvetica" size:12];
		self.value		 = @"";
		self.name		 = theName;
		self.placeholder = @"Empty";
		self.editable	 = YES;
	}
	
	return self;
}

- (void) dealloc{
	self.name = nil;
	self.value = nil;
	self.font = nil;
	self.placeholder = nil;
	[super dealloc];
}


+ (WWFlowFieldSubfield *) editableFieldWithName:(NSString *)fieldName placeholder:(NSString *)placeholderString initialValue:(NSString *)initialValue{
	WWFlowFieldSubfield *field = [[WWFlowFieldSubfield alloc] initWithName:fieldName];
	field.editable = YES;
	field.placeholder = placeholderString;
	field.value = initialValue;
	return [field autorelease];
}


+ (WWFlowFieldSubfield *) uneditableFieldWithName:(NSString *)fieldName initialValue:(NSString *)initialValue{
	WWFlowFieldSubfield *field = [[WWFlowFieldSubfield alloc] initWithName:fieldName];
	field.editable = NO;
	field.value = initialValue;
	return [field autorelease];
}

+ (WWFlowFieldSubfield *) uneditableSpace{
	return [WWFlowFieldSubfield uneditableFieldWithName:@"" initialValue:@" "];
}

+ (WWFlowFieldSubfield *) uneditableNewline{
	return [WWFlowFieldSubfield uneditableFieldWithName:@"" initialValue:@"\n"];
}


- (NSString *) description{
	return [NSString stringWithFormat:@"<WWFlowField: name = %@, editable = %d, value = %@>", name, editable, value];
}
/*
- (NSAttributedString *) _displayString{
	return [[[NSAttributedString alloc] initWithString:self.value 
											attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]] autorelease];
}
*/
- (BOOL) _isDisplayedAsPlaceholder{
	return NO;
}


- (NSAttributedString *) _displayString{
	if([self _isDisplayedAsPlaceholder]){
		NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
		[attrs setObject:font forKey:NSFontAttributeName];
		[attrs setObject:[NSColor lightGrayColor] forKey:NSForegroundColorAttributeName];

		return [[[NSAttributedString alloc] initWithString:self.value attributes:attrs] autorelease];
	}else{
		return [[[NSAttributedString alloc] initWithString:self.value 
												attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]] autorelease];
	}
}

@end
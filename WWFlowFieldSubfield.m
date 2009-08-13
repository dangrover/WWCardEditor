//
//  WWFlowFields.m
//  WWCardEditor
//
//  Created by Dan Grover on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WWFlowFieldSubfield.h"

@interface WWFlowFieldSubfield()
@property(retain,readwrite) NSString *name; 
@end

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



- (NSString *) description{
	return [NSString stringWithFormat:@"<WWFlowField: name = %@, editable = %d, value = %@>", name, editable, value];
}

+ (void) initialize{
	[self exposeBinding:@"value"];
	[self exposeBinding:@"editable"];
	[self exposeBinding:@"font"];
	[self exposeBinding:@"placeholder"];
}

+ (WWFlowFieldSubfield *) editableSubfieldWithName:(NSString *)fieldName placeholder:(NSString *)placeholderString initialValue:(NSString *)initialValue{
	WWFlowFieldSubfield *field = [[WWFlowFieldSubfield alloc] initWithName:fieldName];
	field.editable = YES;
	field.placeholder = placeholderString;
	field.value = initialValue;
	return [field autorelease];
}


+ (WWFlowFieldSubfield *) uneditableSubfieldWithName:(NSString *)fieldName initialValue:(NSString *)initialValue{
	WWFlowFieldSubfield *field = [[WWFlowFieldSubfield alloc] initWithName:fieldName];
	field.editable = NO;
	field.value = initialValue;
	return [field autorelease];
}

+ (WWFlowFieldSubfield *) uneditableSpace{
	return [WWFlowFieldSubfield uneditableSubfieldWithName:nil initialValue:@" "];
}

+ (WWFlowFieldSubfield *) uneditableNewline{
	return [WWFlowFieldSubfield uneditableSubfieldWithName:nil initialValue:@"\n"];
}

@end
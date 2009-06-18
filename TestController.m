//
//  TestController.m
//  WWCardEditor
//
//  Created by Dan Grover on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TestController.h"


@implementation TestController


- (void) awakeFromNib{
	NSLog(@"Hi!");
	
	NSFont *bigFont = [NSFont fontWithName:@"Helvetica Bold" size:24];
	
	WWEditableFlowField *firstName = [[[WWEditableFlowField alloc] initWithName:@"firstName"] autorelease];
	firstName.value = @"Dan";
	firstName.font = bigFont;
	
	WWImmutableStringFlowField *nameSpace = [[[WWImmutableStringFlowField alloc] initWithName:@"nameSpace"] autorelease];
	nameSpace.value = @" ";
	
	WWEditableFlowField *lastName = [[[WWEditableFlowField alloc] initWithName:@"lastName"] autorelease];
	lastName.value = @"Grover";
	lastName.font = bigFont;
	
	
	WWImmutableStringFlowField *newline1 = [[[WWImmutableStringFlowField alloc] initWithName:@"nl"] autorelease];
	newline1.value = @"\n";
	
	WWEditableFlowField *addyLine1 = [[[WWEditableFlowField alloc] initWithName:@"addyLine1"] autorelease];
	addyLine1.value = @"504 Page St";
	
	WWImmutableStringFlowField *newline2 = [[[WWImmutableStringFlowField alloc] initWithName:@"nl2"] autorelease];
	newline2.value = @"\n";
	
	WWEditableFlowField *city = [[[WWEditableFlowField alloc] initWithName:@"city"] autorelease];
	city.value = @"San Francisco";
	
	WWImmutableStringFlowField *cityComma = [[[WWImmutableStringFlowField alloc] initWithName:@"cityComma"] autorelease];
	cityComma.value = @", ";
	
	WWEditableFlowField *state = [[[WWEditableFlowField alloc] initWithName:@"state"] autorelease];
	state.value = @"CA";
	
	WWImmutableStringFlowField *zipSpace = [[[WWImmutableStringFlowField alloc] initWithName:@"zipSpace"] autorelease];
	zipSpace.value = @" ";
	
	WWEditableFlowField *zip = [[[WWEditableFlowField alloc] initWithName:@"zip"] autorelease];
	zip.value = @"94117";
	
	flowFieldContainer.fields = [NSArray arrayWithObjects:firstName,nameSpace,lastName,newline1,addyLine1,newline2,city,cityComma,state,zipSpace,zip,nil];
	[self toggleEditMode:nil];
}


- (IBAction) refreshDebugDisplay:(id)sender{
	[debugDisplay setStringValue:[[flowFieldContainer fields] description]];
	
}

- (IBAction) toggleEditMode:(id)sender{
	NSLog(@"New edit mode is %d",[editModeCheckbox intValue]);
	[flowFieldContainer setEditMode:[editModeCheckbox intValue]];
}

@end

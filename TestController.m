//
//  TestController.m
//  WWCardEditor
//
//  Created by Dan Grover on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TestController.h"
#import "WWSpacerRow.h"
#import "WWSectionRow.h"

@implementation TestController


- (void) awakeFromNib{
	[[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
	
	
	// Set up card editor
	NSFont *bigFont = [NSFont fontWithName:@"Helvetica Bold" size:18];
		
	WWFlowFieldSubfield *firstName = [WWFlowFieldSubfield editableSubfieldWithName:@"first" placeholder:@"First" initialValue:@"Dan"];
	WWFlowFieldSubfield *nameSpace = [WWFlowFieldSubfield uneditableSpace];
	WWFlowFieldSubfield *lastName = [WWFlowFieldSubfield editableSubfieldWithName:@"last" placeholder:@"Last" initialValue:@""];
	lastName.font = nameSpace.font = firstName.font = bigFont;
	
	WWFlowFieldRow *nameRow = [[[WWFlowFieldRow alloc] initWithName:@"name"] autorelease];
	nameRow.subfields = [NSArray arrayWithObjects:firstName, nameSpace, lastName, nil];
	[cardEditor addRow:nameRow];
	
	WWSpacerRow *spacer = [[[WWSpacerRow alloc] init] autorelease];
	spacer.height = 20;
	[cardEditor addRow:spacer];
		
	
	// Set up address flowfield example with a format string
	NSMutableDictionary *addressFields = [NSMutableDictionary dictionary];
	WWFlowFieldSubfield *line = [WWFlowFieldSubfield editableSubfieldWithName:@"addressLine1" placeholder:@"Address" initialValue:@"504 Page St"];
	line.allowsNewlines = YES;
	[addressFields setObject:line forKey:@"<line1>"];
	
	[addressFields setObject:[WWFlowFieldSubfield editableSubfieldWithName:@"city" placeholder:@"City" initialValue:@"San Francisco"]
					  forKey:@"<city>"];
	
	[addressFields setObject:[WWFlowFieldSubfield editableSubfieldWithName:@"state" placeholder:@"State" initialValue:@""]
					  forKey:@"<state>"];
	
	[addressFields setObject:[WWFlowFieldSubfield editableSubfieldWithName:@"zip" placeholder:@"ZIP" initialValue:@"94117"] 
					  forKey:@"<zip>"];
	
	WWFlowFieldRow *addressSubrow = [[[WWFlowFieldRow alloc] initWithFrame:NSZeroRect] autorelease];
	addressSubrow.subfields = [WWFlowFieldSubfield subfieldsWithFormat:@"<line1>\n<city>, <state> <zip> " tokensAndReplacements:addressFields];
	
	// Put the address field inside a key value row
	WWKeyValueRow *addressKeyValueRow = [[[WWKeyValueRow alloc] initWithName:@"homeAddress"] autorelease];
	addressKeyValueRow.keyTypeIdentifiers = [NSArray arrayWithObjects:@"home", @"work", @"boat", @"spaceship", @"spaceboat", @"other",nil];
	addressKeyValueRow.valueRowView = addressSubrow;
	addressKeyValueRow.delegate = self;
	
	NSMenu *addressMenu = [[[NSMenu alloc] init] autorelease];
	[addressMenu addItemWithTitle:@"Large Type" action:nil keyEquivalent:@""];
	[addressMenu addItemWithTitle:@"Show On Map" action:nil keyEquivalent:@""];
	[addressMenu addItemWithTitle:@"Stalk" action:nil keyEquivalent:@""];
	addressKeyValueRow.actionMenu = addressMenu;
	
	[cardEditor addRow:addressKeyValueRow];
	
	
	
	
	
	
	WWCheckboxRow *checkboxRow = [[[WWCheckboxRow alloc] init] autorelease];
	checkboxRow.label = @"Beam Me Up";
	checkboxRow.isChecked = YES;
	
	WWKeyValueRow *checkboxKeyValue = [[[WWKeyValueRow alloc] init] autorelease];
	//checkboxKeyValue.keyLabel = @"awesome";
	checkboxKeyValue.valueRowView = checkboxRow;
	checkboxRow.font = [NSFont fontWithName:@"Helvetica" size:11];
	//[cardEditor addRow:checkboxKeyValue];
	
	
	WWSectionRow *checkboxSection = [[[WWSectionRow alloc] initWithName:@"checkboxSection"] autorelease];
	[checkboxSection addSubrow:checkboxKeyValue];
	[cardEditor addRow:checkboxSection];
	
	[cardEditor setRowSpacing:4];
	[cardEditor setNeedsLayout:YES];
	[cardEditor setNeedsDisplay:YES];
	[self toggleEditMode:nil];	
}


- (IBAction) refreshDebugDisplay:(id)sender{
//	[debugDisplay setStringValue:[[flowFieldContainer fields] description]];
	
}

- (IBAction) toggleEditMode:(id)sender{
	[cardEditor setEditMode:[editModeCheckbox intValue]];
	[cardEditor setNeedsDisplay:YES];
}

- (IBAction) toggleDebugDrawMode:(id)sender{
	[WWCardEditorRow setDebugDrawMode:[debugModeCheckbox intValue]];
	[cardEditor setNeedsDisplay:YES];
}


- (IBAction) triggerLayout:(id)sender{
	[cardEditor setNeedsLayout:YES];
	[cardEditor setNeedsDisplay:YES];
}

- (void) keyValueRow:(WWKeyValueRow *)theRow choseKeyType:(NSString *)keyTypeIdentifier{
	NSLog(@"chose type: %@",keyTypeIdentifier);
}


@end


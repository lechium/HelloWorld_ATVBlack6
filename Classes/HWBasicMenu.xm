
/*
 
 ### EDITING HWBasicMenu.m 
 
	This class is pretty cut and dry, we have an init function, there are 9 functions and only 5 of them ever need to be tweaked for a new controller: init, previewControlForItem, itemForRow, itemSelected and itemForRow (and of course dealloc if you alloc any global variables that don't release themselves.)
 
 
 */

//#import "HWBasicMenu.h"
#import <Foundation/Foundation.h>

%subclass HWBasicMenu: BRMediaMenuController
static char const * const menuItemKey = "MenuItems";


//@implementation HWBasicMenu //no more interface or implementation, using logos to subclass at runtime.

- (id) init
{
	if((self = %orig) != nil) {
		
		//NSLog(@"%@ %s", self, _cmd);
		
		[self setListTitle:@"Utilities"];
		
		/* 
		 
		 if you wanted to load your own image from your own resources folder you would use something like line 29 and 30, here we are just loading from BRThemeInfo
		 
		 */
		
		//NSString *settingsPng = [[NSBundle bundleForClass:[HWBasicMenu class]] pathForResource:@"picture" ofType:@"png"];
		//BRImage *sp = [BRImage imageWithPath:settingsPng];
		//BRImage *sp = [[%c(BRThemeInfo) sharedTheme] gearImage];
		
	//[self setListIcon:sp horizontalOffset:0.0 kerningFactor:0.15];
		
			//these are our menu options in our new controller
		
		NSMutableArray *theArray = [[NSMutableArray alloc] init];
		[theArray addObject:@"Quit Finder"];
		[theArray addObject:@"Show Console Log"];
		[self setMenuItems:theArray];
		[[self list] setDatasource:self];
		[[self list] addDividerAtIndex:1 withLabel:@"testing"];
      
        
		return ( self );
		
	}
	
	return ( self );
}	

/* 
 
 these are the previews that are displayed on your left when a menu item has been selected, we use a basic case statement and return different images according to index
 
 */


- (id)previewControlForItem:(long)item

{
	id theImage = nil;
	
	switch (item) {
			
		case 0: //item one
		
			theImage = [[%c(BRThemeInfo) sharedTheme] largeGeniusIconWithReflection];
			break;
		
		case 1: //item two
			
			theImage = [[%c(BRThemeInfo) sharedTheme] networkPhotosImage];
			break;
		
	}
	
//here we had to change to BRIconPreviewController (or just something different than in prior versions, the old class we used here is gone)
	
	id obj = [[%c(BRIconPreviewController) alloc] init];
	
	[obj setImage:theImage];
	
	return ([obj autorelease]);
	
}

%new - (id)menuItems { return objc_getAssociatedObject(self, menuItemKey); }
%new - (void)setMenuItems:(id)newMenuItems { objc_setAssociatedObject(self, menuItemKey, newMenuItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
/*
 
 here we handle selecting an object from the list, right now we just log out to the syslog which item was selected, you can obviously be more complex than that :) 
 */


- (void)itemSelected:(long)selected {
	
	NSDictionary *currentObject = [[self menuItems] objectAtIndex:selected];
//	NSLog(@"item selected: %@", currentObject);
    id spinControl = nil;
	id controller = nil;
	id scrollBar = nil;
	NSDictionary *lcd = nil;
	id textControls = nil;
	id tb;
	id list;
	switch (selected)
    {
        case 0: //first item quit finder
            [[NSClassFromString(@"BRApplication") sharedApplication] terminate];
            break;
            
        case 1: //show console
            
            system("tail -n 200 /var/log/syslog >/tmp/temp.log");
			textControls = [[objc_getClass("BRScrollingTextControl") alloc] init];
           // NSLog(@"textcontrols: %@", textControls);
			tb = [textControls valueForKey:@"textBox"];
			list = [tb valueForKey:@"list"];
			scrollBar = [[list providers] objectAtIndex:0];
           // NSLog(@"list %@", scrollBar);
			[textControls setDocumentPath:@"/tmp/temp.log" encoding:NSUTF8StringEncoding];
			[textControls setTitle:@"syslog"];
			
			controller =  [%c(BRController) controllerWithContentControl:textControls];
			
            //NSLog(@"%@", [[textControls textBox] text]);
			
			
			[ROOT_STACK pushController:controller];
			
			lcd = [NSDictionary dictionaryWithObject:list forKey:@"ListControl"];
			
			[textControls release];
			
			
			[NSTimer scheduledTimerWithTimeInterval:.1 target: self selector: @selector(myJumpToEnd:) userInfo:lcd  repeats: NO];

            break;
    }
	
}

%new - (void)myJumpToEnd:(id)scrollBarInfo
{
	id theList = [[scrollBarInfo userInfo] valueForKey:@"ListControl"];
	int theCount = (int)[theList dataCount];
	[theList setSelection:theCount];
 
}
/*
 
 Here we handle what kind of items are displayed in our list, we set the title from our [self menuItems] variable and add different accessories (think of UITableView item accessories, same kind of idea)
 
 */

%new - (id)itemForRow:(long)row {
	if(row > [[self menuItems] count])
		return nil;

	id  result = [[%c(BRMenuItem) alloc] init];
	NSString *theTitle = [[self menuItems] objectAtIndex:row];
	[result setText:theTitle withAttributes:[[%c(BRThemeInfo) sharedTheme] menuItemTextAttributes]];
	
	switch (row) {
				
		case 0:
			
			[result addAccessoryOfType:0];
			
			break;
	
		case 1: 
			
			[result addAccessoryOfType:1]; //add a > to the menuItem on the far right.
			break;
			
		default:
			
			[result addAccessoryOfType:0];
			break;
	}
	
	return [result autorelease];
}

%new - (BOOL)rowSelectable:(long)selectable {
	return TRUE;
}

%new - (float)heightForRow:(long)row {
	return 0.0f;
}

- (long)itemCount {
	return [[self menuItems] count];
}



%new - (id)titleForRow:(long)row {
	return [[self menuItems] objectAtIndex:row];
}

-(void)dealloc
{
	//[[self menuItems] release];
	
	%orig;
}


//@end

%end


#import "BackRowExtras.h"
//#import "HWBasicMenu.h"

#define TOPSHELFVIEW %c(BRTopShelfView)
#define IMAGECONTROL %c(BRImageControl)
#define BRAPPCAT %c(BRApplianceCategory)

#define HELLO_ID @"hwHello"

#define HELLO_CAT [BRAPPCAT categoryWithName:@"Hello World" identifier:HELLO_ID preferredOrder:0]


//@interface BRTopShelfView (specialAdditions)
//
//- (BRImageControl *)productImage;
//
//@end
//
//
//@implementation BRTopShelfView (specialAdditions)
//
//- (BRImageControl *)productImage
//{
//	return MSHookIvar<BRImageControl *>(self, "_productImage");
//}
//
//@end


%subclass HWApplianceInfo : BRApplianceInfo

- (NSString*)key
{
	return [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:(NSString*)kCFBundleIdentifierKey];
}

- (NSString*)name
{
	return [[[NSBundle bundleForClass:[self class]] localizedInfoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
}

- (id)localizedStringsFileName
{
	return @"HWLocalizable";
}

%end

@interface TopShelfController : NSObject {
}
- (void)refresh; //4.2.1
- (void)selectCategoryWithIdentifier:(id)identifier;
- (id)topShelfView;
@end

@implementation TopShelfController


-(void)refresh
{
		//needed for 4.2.1 compat to keep AppleTV.app from endless reboot cycle
}

- (void)selectCategoryWithIdentifier:(id)identifier {
	
	//leave this entirely empty for controllerForIdentifier:args to work in Appliance subclass
}





- (id)topShelfView {
	
	id topShelf = [[TOPSHELFVIEW alloc] init];
	return topShelf;
	//BRTopShelfView *topShelf = [[BRTopShelfView alloc] init];
	//BRImageControl *imageControl = [topShelf productImage];
	//BRImage *theImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HWBasicMenu class]] pathForResource:@"ApplianceIcon" ofType:@"png"]];
	//BRImage *theImage = [[BRThemeInfo sharedTheme] largeGeniusIconWithReflection];
	//[imageControl setImage:theImage];
	
	//return topShelf;
}

@end

%subclass HWAppliance: BRBaseAppliance

static char const * const topShelfControllerKey = "topShelfController";
static char const * const applianceCategoriesKey = "applianceCategories";
//@interface HWAppliance: NSObject {
//	TopShelfController *_topShelfController;
//	NSArray *_applianceCategories;
//}
//@property(nonatomic, readonly, retain) id topShelfController;

//@end

//@implementation HWAppliance
//@synthesize topShelfController = _topShelfController;

- (id)applianceInfo
{

		Class cls = objc_getClass("HWApplianceInfo");
		NSLog(@"cls: %@", cls);
		return [[[cls alloc] init] autorelease];

}

%new + (void)forceCrash
{
	NSArray *theArray = [NSArray arrayWithObjects:@"thejesus", @"heyzus", nil];
	NSLog(@"we should crash now");
	id theObject = [theArray objectAtIndex:2];
}

+ (void)initialize {
	
	//NSLog(@"INITIALIZE");
	
	//[HWAppliance forceCrash]; //in here solely to show how to use hwSymbols shell script	
}

- (id)topShelfController { return objc_getAssociatedObject(self, topShelfControllerKey); }

%new - (void)setTopShelfController:(id)topShelfControl { objc_setAssociatedObject(self, topShelfControllerKey, topShelfControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }

- (id)applianceCategories {
	
	return objc_getAssociatedObject(self, applianceCategoriesKey);
}

%new - (void)setApplianceCategories:(id)applianceCategories
{ objc_setAssociatedObject(self, applianceCategoriesKey, applianceCategories, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }

- (id)init
{
	return [self initWithApplianceInfo:nil]; //compat sanity
}

- (id)initWithApplianceInfo:(id)applianceInfo { //IMPORTANT!!!!: if you dont do initWithApplianceInfo: BRBaseAppliance will always return nil in 6.x+
	if((self = %orig) != nil) {
		
		//[self setTopShelfController:
		//_topShelfController = [[TopShelfController alloc] init];
		id topShelfControl = [[TopShelfController alloc] init];
		[self setTopShelfController:topShelfControl];
		NSArray *catArray = [[NSArray alloc] initWithObjects:HELLO_CAT,nil];
		[self setApplianceCategories:catArray];
		//_applianceCategories = [[NSArray alloc] initWithObjects:HELLO_CAT,nil];
	
	} return self;
}

- (id)controllerForIdentifier:(id)identifier args:(id)args
{
	id menuController = nil;
	
	if ([identifier isEqualToString:HELLO_ID])
	{
	
		//for some reason %c(HWBasicMenu) was crashing??
		//	NSLog(@"%c(HWBasicMenu): %@", %c(HWBasicMenu));
		
		menuController = [[objc_getClass("HWBasicMenu") alloc] init];
		
		
	} 
	
	return menuController;
	
}



- (id)identifierForContentAlias:(id)contentAlias {
	return @"Hello World";
}

- (id)selectCategoryWithIdentifier:(id)ident {
	//NSLog(@"selecteCategoryWithIdentifier: %@", ident);
	return nil;
}

- (BOOL)handleObjectSelection:(id)fp8 userInfo:(id)fp12 {

	return YES;
}

- (id)applianceSpecificControllerForIdentifier:(id)arg1 args:(id)arg2 {

	return nil;
}



- (id)localizedSearchTitle { return @"Hello World"; }
- (id)applianceName { return @"Hello World"; }
- (id)moduleName { return @"Hello World"; }
- (id)applianceKey { return @"Hello World"; }

//@end

%end



// vim:ft=objc

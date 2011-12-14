//
//  iTeachWordsAppDelegate.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 5/16/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "iTeachWordsAppDelegate.h"

#import "iTeachWordsViewController.h"
#import "MyMenu.h"
#import "FilesManagerViewController.h"
#import "MyPlayer.h"
#import "Reachability.h"
#import "LanguagePickerController.h"


@implementation iTeachWordsAppDelegate


@synthesize window=_window;

@synthesize viewController=_viewController;


- (void)dealloc
{
    if (player) {
        [player release];
    }
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // start of your application:didFinishLaunchingWithOptions 
    // ...
//    NSString *testTeamToken = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"TestTeamToken"];
//    NSLog(@"TestTeamToken is %@",testTeamToken);
//    [TestFlight takeOff:testTeamToken];
    // The rest of your application:didFinishLaunchingWithOptions method

    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    player = [[MyPlayer alloc] initWithNibName:@"MyPlayer" bundle:nil];
    [self checkDatabase];
    [self showMenuView];
    navigationController.delegate = self;
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    //[self doRegistrationProcess];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //NSFileManager *fileManager = [NSFileManager defaultManager];
//	NSArray *files =[[NSFileManager defaultManager] contentsOfDirectoryAtPath:DOCUMENTS error:nil];
//	if ([files count]>0) {
//		FilesManagerViewController *progressView = [[FilesManagerViewController alloc] initWithNibName:@"FilesManagerViewController" bundle:nil];
//		[navigationController.view addSubview:progressView.view];
//		[progressView release];
//	}
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark shoving functions

- (void) showMenuView{
    MyMenu *myMenu = [[MyMenu alloc] initWithNibName:@"MyMenu" bundle:nil];
    navigationController = [[UINavigationController alloc] initWithRootViewController:myMenu];
    //navigationController.navigationBar.delegate = self;
    [navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [myMenu release];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY_CODE] || [[NSUserDefaults standardUserDefaults] objectForKey:TRANSLATE_COUNTRY_CODE])
    {
        [myMenu performSelector:@selector(showLastItem) withObject:nil afterDelay:0.5];
    }
}

#pragma mark -
#pragma mark Core Data stack


- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"iTeachWordsDataModel" ofType:@"mom"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    //    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [DOCUMENTS stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",[INFO objectForKey: @"dataBaseName"]]]];
	
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
							 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}

+ (iTeachWordsViewController*) sharedDelegate
{
	return (iTeachWordsViewController*)[[UIApplication sharedApplication] delegate];
}

- (void) playSound:(NSData *)_data inView:(UIView *)_view{
    if (player && _data) {
        if (_view) {
            [player openViewWithAnimation:_view];
        }
        [player startPlayWithData:_data];
    }
}

+ (NSManagedObjectContext*) sharedContext
{
	return [[iTeachWordsAppDelegate sharedDelegate] managedObjectContext];
}

+ (void)clearUdoManager{
    NSUndoManager *um = [CONTEXT undoManager];
    if (um) {
        [um removeAllActions];
    }else{
        um = [[NSUndoManager  alloc] init];
        [CONTEXT setUndoManager:um];
        [um release];
    }
}

#pragma mark - my external function

- (void) checkDatabase
{	
	NSString *dbName = [INFO objectForKey: @"dataBaseName"];
	NSString *target = [DOCUMENTS stringByAppendingPathComponent:dbName];
    NSString *source = [[NSBundle mainBundle] pathForResource:dbName ofType:@"sqlite"];
	target = [target stringByAppendingPathExtension:@"sqlite"];
	
	BOOL isDirectory = YES;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (source && (![fileManager fileExistsAtPath:target] || isDirectory))
	{
		NSError *error = nil;
		[fileManager copyItemAtPath:source toPath:target error:&error];
	}
}

- (void) copyDB
{	
	NSString *dbName = [INFO objectForKey: @"dataBaseName"];
	NSString *target = [DOCUMENTS stringByAppendingPathComponent:dbName];
    NSString *source = [[NSBundle mainBundle] pathForResource:dbName ofType:@"sqlite"];
	target = [target stringByAppendingPathExtension:@"sqlite"];
	
	BOOL isDirectory = YES;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (source && (![fileManager fileExistsAtPath:target] || isDirectory))
	{
		NSError *error = nil;
		[fileManager copyItemAtPath:source toPath:target error:&error];
	}
}

#pragma mark navigation delegate

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    return YES;
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (player) {
        [player closePlayer];
    }
}


+ (BOOL) isNetwork{
    //[UIAlertView displayError:@"Network connection is not avalable."];
    //return NO;
    
    Reachability *hostReach = [Reachability reachabilityForInternetConnection];	
	NetworkStatus netStatus = [hostReach currentReachabilityStatus];
	if (netStatus == NotReachable) {
        [UIAlertView displayError:@"Network connection is not avalable."];
		return NO;
	}
    return YES;
}

-(void)doRegistrationProcess
{
    NSString *_fileName;
    NSURL           *recordedTmpFile;
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:
                      [[[NSBundle mainBundle] infoDictionary] objectForKey: @"myResource"]];
    path = [path stringByAppendingPathComponent:@"/WordRecords/"];
 
        _fileName = @"tmp";

    path = [path stringByAppendingPathComponent:
            [NSString stringWithFormat: @"%@.%@", _fileName, @"flac"]  ];
    recordedTmpFile = [[NSURL alloc] initFileURLWithPath:path];
    NSLog(@"Using File called: %@",recordedTmpFile);
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:recordedTmpFile];
    NSString* requestDataLengthString = [[NSString alloc] initWithFormat:@"%d", [data length]];

	NSMutableString *params = [[NSMutableString alloc] init];
//	[params appendFormat:@"login=%@", [[self account] objectForKey:@"login"]];
//	[params appendFormat:@"&imei=%@", [self imei]];
//	[params appendFormat:@"&zipcode=%@", [[self account] objectForKey: @"zipcode"]];
//	[params appendFormat:@"&housenumber=%@", [[self account] objectForKey:@"housenumber"]];
//	[params appendFormat:@"&dateofbirth=%@", [[self account] objectForKey:@"dateofbirth"]];
	
	NSString *u = [NSString stringWithFormat:@"https://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=ru-RU"];
    
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL: [NSURL URLWithString:u]];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
	[request setTimeoutInterval:30];
	[request setHTTPMethod:@"POST"];
	
	NSData *postData = [params dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"audio/x-flac; rate=8000" forHTTPHeaderField:@"Content-Type"];
	[request setValue:requestDataLengthString     forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:data];
    
	_mutableData = [[NSMutableData alloc] init];
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest: request delegate:self];
	NSAssert(nil != connection, @"The connection cannot be created!");
}


#pragma mark -
#pragma mark NSURLRequest delegate
- (void)connection:(NSURLConnection *)connection 
	didReceiveData:(NSData *)data
{
	[_mutableData appendData: data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{	
    NSString *information = [[NSString alloc] initWithData:_mutableData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",information);
    [UIAlertView displayMessage:information];
	[_mutableData release];
    
    
    
    NSString *_fileName;
    NSURL           *recordedTmpFile;
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:
                      [[[NSBundle mainBundle] infoDictionary] objectForKey: @"myResource"]];
    path = [path stringByAppendingPathComponent:@"/WordRecords/"];
    
    _fileName = @"recordingTote";
    
    path = [path stringByAppendingPathComponent:
            [NSString stringWithFormat: @"%@.%@", _fileName, @"caf"]  ];
    recordedTmpFile = [[NSURL alloc] initFileURLWithPath:path];
    NSLog(@"Using File called: %@",recordedTmpFile);
    NSData *data;
    data = [[NSData alloc]initWithContentsOfURL:recordedTmpFile];
    [[iTeachWordsAppDelegate sharedDelegate] playSound:data inView:nil];
    [data release];
}

+ (NSDictionary *) sharedSettings{
    static NSDictionary *languageSettings;
    if (!languageSettings) {
        languageSettings = [self loadLanguageSettings];
        [languageSettings retain];
    }
    return languageSettings;
}

+ (NSDictionary *) loadLanguageSettings{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]  init];
    NSString *nativeCountryCode = [[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY_CODE];
    NSString *translateCountryCode = [[NSUserDefaults standardUserDefaults] objectForKey:TRANSLATE_COUNTRY_CODE];
    NSString *nativeCountry = [[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY];
    NSString *translateCountry = [[NSUserDefaults standardUserDefaults] objectForKey:TRANSLATE_COUNTRY];
    if (translateCountryCode && nativeCountryCode){
        [dict setValue:nativeCountryCode forKey:NATIVE_COUNTRY_CODE];
        [dict setValue:translateCountryCode forKey:TRANSLATE_COUNTRY_CODE];
        [dict setValue:nativeCountry forKey:NATIVE_COUNTRY];
        [dict setValue:translateCountry forKey:TRANSLATE_COUNTRY];
        
        NSString *path = [NSString stringWithFormat:@"%@.png", nativeCountryCode];
        UIImage *nativeCountryFlag = [UIImage imageNamed:path];
        path = [NSString stringWithFormat:@"%@.png", translateCountryCode];
        UIImage *translateCountryFlagm = [UIImage imageNamed:path];
        
        [dict setValue:nativeCountryFlag forKey:@"nativeCountryFlag"];
        [dict setValue:translateCountryFlagm forKey:@"translateCountryFlag"];
    }
    NSLog(@"%@",dict);
    return [dict autorelease];
}

@end

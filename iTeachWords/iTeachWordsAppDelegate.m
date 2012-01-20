//
//  iTeachWordsAppDelegate.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 5/16/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "iTeachWordsAppDelegate.h"

#import "iTeachWordsViewController.h"
#import "MenuViewController.h"
#import "FilesManagerViewController.h"
#import "MyPlayer.h"
#import "Reachability.h"
#import "LanguagePickerController.h"
#import "RepeatModel.h"
#import "WordTypes.h"

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
    
    [self activateNotification];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    player = [[MyPlayer alloc] initWithNibName:@"MyPlayer" bundle:nil];
    [self checkDatabase];
    [self updateData];
    [self showMenuView];
    navigationController.delegate = self;
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
//    NSThread *progressThread = [[NSThread alloc] initWithTarget:self selector:@selector(qqq) object:nil];
//    [progressThread start];
    //[self doRegistrationProcess];
    return YES;
}

- (void)qqq{
    NSString *fileName = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/enrus.txt"];
    NSLog(@"Parsing the %@ file...",fileName);
    
    NSAutoreleasePool *poolRoot= [[NSAutoreleasePool alloc] init];
    bool returnValue = YES;
    //[self performSelectorOnMainThread:@selector(showLoadingView) withObject:nil waitUntilDone:YES];
    NSString *text = [[NSString alloc]initWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    [iTeachWordsAppDelegate clearUdoManager];
    @try {
        NSMutableString *mutStr = [NSMutableString stringWithString:@""];
        unichar ch;
        int index = 0;
        ch = [text characterAtIndex:index];
        while (ch!='.') {
            [mutStr appendString:[NSString stringWithFormat:@"%c",ch]];
            ++index;
            ch = [text characterAtIndex:index];
        }
        NSString *globalSlash = mutStr;
        NSArray *wordsArray = [[NSArray alloc] initWithArray:[text componentsSeparatedByString:globalSlash]];
        //[loadingView setTotal:[wordsArray count]];
        NSDate *createDate = [[NSDate date] retain];
        NSString *themeName = [wordsArray objectAtIndex:2];
        NSString *slash = [wordsArray objectAtIndex:3];
        NSArray *languageObjects = [[wordsArray objectAtIndex:4] componentsSeparatedByString:slash];
        
        NSLog(@"globalSlash->%@",globalSlash);
        NSLog(@"themeName->%@",themeName);
        NSLog(@"slash->%@|",slash);
        NSLog(@"languageObjects->%@",languageObjects);
        
        NSString *nativeLanguage = [languageObjects objectAtIndex:1];
        NSString *translateLanguage = [languageObjects objectAtIndex:0];
        
        //Checking whether there is dictionary with the same name 
        //            while (YES) {
        //                NSPredicate *_predicate = [NSPredicate predicateWithFormat:@"nativeCountryCode = %@ && translateCountryCode = %@ && name = %@",
        //                                           [[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY_CODE], 
        //                                           [[NSUserDefaults standardUserDefaults] objectForKey:TRANSLATE_COUNTRY_CODE],
        //                                           themeName];
        //                NSArray *allTheme = [MyPickerViewContrller loadAllThemeWithPredicate:_predicate];
        //                if ([allTheme count]>0) {
        //                    themeName = [NSString stringWithFormat:@"%@ (%d)",themeName,[allTheme count]];
        //                } else{
        //                    break;
        //                }
        //            }
        
        //Parsing words
        WordTypes *_wordType;
        _wordType = [NSEntityDescription insertNewObjectForEntityForName:@"WordTypes" 
                                                  inManagedObjectContext:CONTEXT];
        [_wordType setName:themeName];
        [_wordType setCreateDate:createDate];
        [_wordType setNativeCountryCode:nativeLanguage];
        [_wordType setTranslateCountryCode:translateLanguage];
        
        @try {   
            NSMutableSet* wordsAr = [[NSMutableSet alloc]init];
            int linesCount = [wordsArray count];
            int breakPoints = ((linesCount<1000)?(linesCount/10):1000);
            
            NSAutoreleasePool *pool= [[NSAutoreleasePool alloc] init];
            for (int i = 5 ; i< linesCount; i++) {
                if ((i%breakPoints) == 0) {
                    [_wordType addWords:wordsAr];
                    [wordsAr removeAllObjects];
                    NSLog(@"%d",i);
                    //[loadingView performSelectorOnMainThread:@selector(updateDataCurrentIndex:) withObject:[NSNumber numberWithInt:i] waitUntilDone:YES];
                    //                    
                    [iTeachWordsAppDelegate performSelectorOnMainThread:@selector(saveDB) withObject:nil waitUntilDone:YES];
                    //                    //[iTeachWordsAppDelegate saveDB];
                    [pool drain];
                    pool= [[NSAutoreleasePool alloc] init];
                }
                NSArray *ar2 = [NSArray arrayWithArray:[[wordsArray objectAtIndex:i] componentsSeparatedByString:slash]];
                if ([ar2 count]<2) {
                    continue;
                }
                //NSLog(@"ar2->%@",ar2);
                Words *word = [NSEntityDescription insertNewObjectForEntityForName:@"Words" 
                                                            inManagedObjectContext:CONTEXT];
                [word setCreateDate:createDate];
                [word setChangeDate:createDate];
                [word setText:[ar2 objectAtIndex:0]];
                [word setTranslate:[ar2 objectAtIndex:1]];
                [word setDescriptionStr:_wordType.name];
                [word setType:_wordType];
                [wordsAr addObject:word];
                //
            }
            [_wordType addWords:wordsAr];
            [iTeachWordsAppDelegate performSelectorOnMainThread:@selector(saveDB) withObject:nil waitUntilDone:YES];
            [wordsAr release];
            [pool drain];
            
        }
        @catch (NSException *exception) {
            returnValue = NO;
            NSLog(@"%@",exception);
            [UIAlertView displayError:NSLocalizedString(@"There was some error within parse words", @"")];
        }
        @finally {
            if (!returnValue) {
                [CONTEXT rollback];
            }
            [wordsArray release];
            [createDate release];
        }
        
    }
    @catch (NSException *exception) {
        returnValue = NO;
        NSLog(@"%@",exception);
        [UIAlertView displayError:NSLocalizedString(@"There was some error within parse options informdtion (line 1->4)", @"")];
    }
    @finally {
        [text release];
        //[loadingView closeLoadingView];
        [poolRoot drain];
    }
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

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)updateData{
    //NSFileManager *fileManager = [NSFileManager defaultManager];
    isUpdating = YES;
	NSArray *files =[[NSFileManager defaultManager] contentsOfDirectoryAtPath:DOCUMENTS error:nil];
	if ([files count]>0) {
		FilesManagerViewController *progressView = [[FilesManagerViewController alloc] initWithNibName:@"FilesManagerViewController" bundle:nil];
        [progressView onCopy];
		//[navigationController.view addSubview:progressView.view];
		[progressView release];
	}
    //    if ([[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY_CODE] && [[NSUserDefaults standardUserDefaults] objectForKey:TRANSLATE_COUNTRY_CODE]){
    //        FilesManagerViewController *progressView = [[FilesManagerViewController alloc] init];
    //        [progressView loadDictionary];
    //        [progressView release];
    //    }

}

#pragma mark FileManagerProtocol

- (void) dataDidUpdate{
    isUpdating = NO;
}

#pragma mark 
- (void)activateNotification{
    
    [[NSUserDefaults standardUserDefaults]  setBool:NO forKey:@"isNotShowRepeatList"];
    UIApplication *app                = [UIApplication sharedApplication];
    NSArray *oldNotifications         = [app scheduledLocalNotifications];
    
    if ([oldNotifications count] > 0) {
        [app cancelAllLocalNotifications];
    }
    if (IS_REPEAT_OPTION_ON) {
        NSArray *repeatDelayedThemes = [[NSArray alloc] initWithArray:[self loadRepeatDelayedTheme]];
        for (int i=0;i<[repeatDelayedThemes count];i++){
            NSDictionary *dict = [repeatDelayedThemes objectAtIndex:i];
            int interval = [[dict objectForKey:@"intervalToNexLearning"] intValue];
            //NSLog(@"%d",interval);
            WordTypes *wordType = [dict objectForKey:@"wordType"];
            //        NSManagedObjectID *objectID = wordType.objectID;
            if (interval > 0) {
                NSDictionary *infoDict = [NSDictionary dictionaryWithObject:wordType.name forKey:@"themeName"];
                UILocalNotification *notification = [UILocalNotification new];
                notification.timeZone  = [NSTimeZone systemTimeZone];
                notification.fireDate  = [[NSDate date] dateByAddingTimeInterval:interval];
                notification.alertAction = wordType.name; 
                notification.alertBody = [NSString stringWithFormat:@"The %@ needs to be repeate",wordType.name];
                notification.soundName = UILocalNotificationDefaultSoundName;
                
                notification.userInfo = infoDict; 
                
                [app scheduleLocalNotification:notification];
                [notification release];
            }
        }
        
        [repeatDelayedThemes release];
    }
}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
    // Handle the notificaton when the app is running
    
    [[NSUserDefaults standardUserDefaults]  setBool:NO forKey:@"isNotShowRepeatList"];
    NSLog(@"Recieved Notification %@",notif.userInfo);
    UIApplicationState state = [app applicationState];
    if(state == UIApplicationStateInactive){
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"lastItem"];
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithString:[notif.userInfo objectForKey:@"themeName"]] forKey:@"lastTheme"];
        NSLog(@"%d",[navigationController.viewControllers count]);
        for (int i=0;i<[navigationController.viewControllers count];i++){
            if ([[navigationController.viewControllers objectAtIndex:i] isKindOfClass:[MenuViewController class]]) {
                MenuViewController *menuView = [navigationController.viewControllers objectAtIndex:i];
                if ([[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY_CODE] || [[NSUserDefaults standardUserDefaults] objectForKey:TRANSLATE_COUNTRY_CODE])
                {
                    [menuView performSelector:@selector(showLastItem) withObject:nil afterDelay:0.5];
                    return;
                }
            }
        }
    }
}

-(NSArray*)loadRepeatDelayedTheme{
    RepeatModel *repeatModel = [[RepeatModel alloc] init];
    NSArray *delayedTheme = [[repeatModel getDelayedTheme] retain];
//    if ([delayedTheme count]>0) {
//        for (int i=0;i<[delayedTheme count];i++){
//            NSDictionary *dict = [delayedTheme objectAtIndex:i];
//           // NSLog(@"%@", dict);    
//            NSDate *currentDate = [NSDate date];
//            int interval = [[dict objectForKey:@"intervalToNexLearning"] intValue];
//            //NSDate *newDate = [currentDate dateByAddingTimeInterval:interval];
//            //NSLog(@"%@",newDate);
//        }
//    }
    [repeatModel release];
    return [delayedTheme autorelease];
}

#pragma mark shoving functions

- (void) showMenuView{
    MenuViewController *myMenu = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
    navigationController = [[UINavigationController alloc] initWithRootViewController:myMenu];
    //navigationController.navigationBar.delegate = self;
    [navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [myMenu release];
    
    if (!isUpdating && ([[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY_CODE] && [[NSUserDefaults standardUserDefaults] objectForKey:TRANSLATE_COUNTRY_CODE]))
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
	return ((iTeachWordsViewController*)[[UIApplication sharedApplication] delegate]);
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
	
    //NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
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
    NSData *_data;
    _data = [[NSData alloc]initWithContentsOfURL:recordedTmpFile];
    [[iTeachWordsAppDelegate sharedDelegate] playSound:_data inView:nil];
    [_data release];
}

+ (void)saveDB{
    NSError *_error;
    if (![CONTEXT save:&_error]) {
        [UIAlertView displayError:@"There is problem with saving data."];
    }else{
        [iTeachWordsAppDelegate clearUdoManager];
    }
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

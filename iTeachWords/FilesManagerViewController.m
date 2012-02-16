 //
//  FilesManagerViewController.m
//  Untitled
//
//  Created by Edwin Zuydendorp on 10/12/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import "FilesManagerViewController.h"
#import "WordTypes.h"
#import "Words.h"
#import "Sounds.h"
#import "LoadingViewController.h"
#import "MyPickerViewContrller.h"

#define RESOUCE [NSHomeDirectory() stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey: @"myResource"]]

@implementation FilesManagerViewController

@synthesize myProgressView,myLabel,delegate;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}

- (void) onCopy{
//	// Теперь важное. Подписываемся на нотификации от движка, это своего рода аналог events в других языках
//	// Нотификация об изменении прогресса поиска. На нее мы меняем значение контрола UIProgressView
//	[[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(updateProgress:)
//												 name:@"progressChanged"
//											   object:nil];
//	// нотификация о том, что поиск полностью окончен
//	[[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(processCopyResult)
//												 name:@"copyEnd"
//											   object:nil];
	// стартуем поиск
	[self threadStart];
}

- (void) updateProgress:(NSNotification *)progressNotification
{
	// получаем объект, переданный в нотификации, этот объект - значение для прогресс-бара
	NSString * sval = [progressNotification object];
	// устанавливаем значение.
	myProgressView.progress = [sval floatValue];
	myLabel.text = file;
	// передать простой тип данных через нотификацию не удается, посему я передал его как указатель на строку
}

- (void) processCopyResult{
	[self.view removeFromSuperview];
} 

-(void) threadStart
{
	// progressThread - член класса Engine: NSThread * progressThread;
	progressThread = [[NSThread alloc] initWithTarget:self selector:@selector(createEditableCopyOfDatabaseIfNeeded) object:nil];
	[progressThread start];
}

-(void)doMessage:(id)param
{
	if(searchProgress < 1.0)
	{
		// здесь делаем наши действия и нотифицируем подписчиков об изменении прогресса
		// проверяем, находимся ли мы в Main потоке
		if( !pthread_main_np() )
		{
			// если нет, то нам сделать расширенную нотификацию
			// создаем массив аргументов нотификации
			NSMutableDictionary *info = [[NSMutableDictionary allocWithZone:nil] init];
			// имя нотификации
			[info setObject:@"progressChanged" forKey:@"name"];
			//значение для UIProgressView
			[info setObject:[NSString stringWithFormat:@"%f", searchProgress] forKey:@"object"];
			// вызываем обработчик запуска нотификации из основного потока
			[[self class] performSelectorOnMainThread:@selector(_postNotificationName:) withObject:info waitUntilDone:YES];
			[info release];
		}
		else
		{
			// если мы в основном потоке, то вызываем обычную нотификацию
			NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
			[nc postNotificationName:@"progressChanged" object:[NSString stringWithFormat:@"%f", searchProgress]];
		}
		return;
	}
	// нотифицируем об окончании обработки поиска
	if( !pthread_main_np() )
	{
		NSMutableDictionary *info = [[NSMutableDictionary allocWithZone:nil] init];
		[info setObject:@"copyEnd" forKey:@"name"];
		[[self class] performSelectorOnMainThread:@selector(_postNotificationName:) withObject:info waitUntilDone:YES];
		[info release];
	}
	else
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"copyEnd" object:nil];
	}
	[NSThread exit];
}

+ (void) _postNotificationName:(NSDictionary *) info {
	NSString *name = [info objectForKey:@"name"];
	id object = [info objectForKey:@"object"];
	[[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:nil];
}

-(void)createEditableCopyOfDatabaseIfNeeded {
    
	NSString *pathOfResource = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/MyResource/"];
	NSString *pathOfResource2 =[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/"];
//	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathOfResource error:nil];
	NSArray *files2 =[[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathOfResource2 error:nil];
	//myProgressView.progress = 0.0;
//	NSLog(@"files:%@",files);
//	for (int i=0; i<[files count]; i++) {
//        
//        NSAutoreleasePool *pool= [[NSAutoreleasePool alloc] init];
//		//NSString *pathOfResource = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/MyResource/"];
//		[self reviewFile:[files objectAtIndex:i]inFolder:(NSString *)pathOfResource];
//		searchProgress = (float)i/([files count]+[files2 count]-1);
//		if (i+1<[files count]) {
//			file = [files objectAtIndex:i+1];
//		}
//		[self doMessage:nil];
//        [pool drain];
//	}
	[[NSFileManager defaultManager] removeItemAtPath:pathOfResource error:nil];
	NSLog(@"files:%@",files2);
//    [loadingView setTotal:[files2 count]];
	for (int i=0; i<[files2 count]; i++) {
        NSAutoreleasePool *pool= [[NSAutoreleasePool alloc] init];
        
        [self performSelectorOnMainThread:@selector(showLoadingView) withObject:nil waitUntilDone:YES];
        loadingView.total = [files2 count];
//        [loadingView performSelectorOnMainThread:@selector(setTotal:) withObject:[NSNumber numberWithInt:[files2 count]] waitUntilDone:YES];
        [loadingView performSelectorOnMainThread:@selector(updateDataCurrentIndex:) withObject:[NSNumber numberWithInt:i] waitUntilDone:YES];
        
		[self reviewFile:[files2 objectAtIndex:i]inFolder:(NSString *)pathOfResource2];
//		searchProgress = (float)i/([files2 count]-1);
//		if (i+1<[files2 count]) {
//			file = [files2 objectAtIndex:i+1];
//		}
//		[self doMessage:nil];
        [pool drain];
	}
    
    [loadingView closeLoadingView];
    SEL selector = @selector(dataDidUpdate);
	if ([delegate respondsToSelector:selector]) {
		[delegate performSelector:selector];
	}
}

- (void) reviewFile:(NSString *)fileName inFolder:(NSString *)pathOfResource{
//	BOOL success;
//    NSError *error;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	//NSString *pathOfResource = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/MyResource/"];
	NSString *pathOfDocuments = [NSHomeDirectory() stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey: @"myResource"]];
	if ([fileManager fileExistsAtPath:pathOfDocuments] == NO)
		[fileManager createDirectoryAtPath:pathOfDocuments withIntermediateDirectories:YES attributes:nil error:nil];
	NSRange subRange;
	
//	NSLog(@"fileName->%@",fileName );
//	subRange = [fileName rangeOfString:@"LESSON"];
//	if (subRange.length != 0) {
//		NSString *writableDBPath = [pathOfDocuments stringByAppendingPathComponent:fileName];
//		NSString *defaultDBPath = [pathOfResource stringByAppendingPathComponent:fileName];
//		if ([fileManager fileExistsAtPath:writableDBPath]) {
//			[fileManager removeItemAtPath:defaultDBPath error:nil];
//			return;
//		}
//				
//		success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];//copy file from defaultDBPath to writableDBPath
//		if (!success) {
//			NSAssert1(NO, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
//		}
//		[fileManager removeItemAtPath:defaultDBPath error:nil];
//		return;
//	}

	subRange = [[fileName lowercaseString] rangeOfString:@".caf"];
	if (subRange.length != 0) {
        if ([self addSoundWithFile:fileName]) {
            [fileManager removeItemAtPath:[RESOUCE stringByAppendingPathComponent:fileName] error:nil];
        }
		return;
	}
	subRange = [[fileName lowercaseString] rangeOfString:@".wav"];
	if (subRange.length != 0) {
        if ([self addSoundWithFile:fileName]) {
            [fileManager removeItemAtPath:[RESOUCE stringByAppendingPathComponent:fileName] error:nil];
        }
		return;
	}	
	
	subRange = [[fileName lowercaseString] rangeOfString:@".txt"];
	if (subRange.length != 0) {
        NSString *pathToFile = [RESOUCE stringByAppendingPathComponent:fileName];
        [self loadDictionaryWithFile:pathToFile];
        [fileManager removeItemAtPath:[RESOUCE stringByAppendingPathComponent:fileName] error:nil];
//        if ([self loadDictionaryWithFile:pathToFile]) {
//            [fileManager removeItemAtPath:[RESOUCE stringByAppendingPathComponent:fileName] error:nil];
//        }
		return;
	}
}

- (void)mergeChanges:(NSNotification *)notification
{
	NSManagedObjectContext *mainContext = [[iTeachWordsAppDelegate sharedDelegate] managedObjectContext];
	
	// Merge changes into the main context on the main thread
	[mainContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)	
                                  withObject:notification
                               waitUntilDone:YES];	
}

#pragma mark load Dictionary
- (void)loadDictionary{
    NSString *pathToFile = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/enrus.txt"];
    progressThread = [[NSThread alloc] initWithTarget:self selector:@selector(loadDictionaryWithFile:) object:pathToFile];
    [progressThread start];
}

- (bool)loadDictionaryWithFile:(NSString*)fileName{
    NSLog(@"Parsing the %@ file...",fileName);
    
    // Create context on background thread
	NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc] init];
	[ctx setUndoManager:nil];
	[ctx setPersistentStoreCoordinator: [[iTeachWordsAppDelegate sharedDelegate] persistentStoreCoordinator]];

	// Register context with the notification center
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
	[nc addObserver:self
           selector:@selector(mergeChanges:) 
               name:NSManagedObjectContextDidSaveNotification
             object:ctx];

    NSAutoreleasePool *poolRoot= [[NSAutoreleasePool alloc] init];
    bool returnValue = YES;
    [self performSelectorOnMainThread:@selector(showLoadingView) withObject:nil waitUntilDone:YES];
    NSString *text = [[NSString alloc]initWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
//    [iTeachWordsAppDelegate clearUdoManager];
//    NSLog(@"%@",text);
    @try {
        NSMutableString *mutStr = [NSMutableString stringWithString:@""];
        unichar ch;
        int index = 0;
        ch = [text characterAtIndex:index];
        while (ch!='.') {
            NSLog(@"%c",ch);
            [mutStr appendString:[NSString stringWithFormat:@"%c",ch]];
            ++index;
            ch = [text characterAtIndex:index];
            if (index>20) {
                NSException * exc = [NSException exceptionWithName: @"my-exception" reason: @"unknown-error"
                                                          userInfo: nil];
                @throw exc;
            }
            
        }
        NSString *globalSlash = mutStr;
        NSArray *wordsArray = [[NSArray alloc] initWithArray:[text componentsSeparatedByString:globalSlash]];
        loadingView.total = [wordsArray count];
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
        while (YES) {
            NSPredicate *_predicate = [NSPredicate predicateWithFormat:@"nativeCountryCode = %@ && translateCountryCode = %@ && name = %@",
                                       NATIVE_LANGUAGE_CODE, 
                                       TRANSLATE_LANGUAGE_CODE,
                                       themeName];
            NSArray *allTheme = [MyPickerViewContrller loadAllThemeWithPredicate:_predicate];
            if ([allTheme count]>0) {
                themeName = [NSString stringWithFormat:@"%@ (%d)",themeName,[allTheme count]];
            } else{
                break;
            }
        }
        
        //Parsing words

        WordTypes *_wordType;                
        _wordType = [NSEntityDescription insertNewObjectForEntityForName:@"WordTypes" 
                                                                                       inManagedObjectContext:ctx];
        [_wordType setName:themeName];
        [_wordType setCreateDate:createDate];
        [_wordType setNativeCountryCode:nativeLanguage];
        [_wordType setTranslateCountryCode:translateLanguage];
        
        @try {   
            NSMutableSet* wordsAr = [[NSMutableSet alloc]init];
            
            int linesCount = [wordsArray count];
            int breakPoints = ((linesCount<1000)?(linesCount/10):1000);
            for (int i = 5 ; i< linesCount; i++) {
                NSArray *ar2 = [NSArray arrayWithArray:[[wordsArray objectAtIndex:i] componentsSeparatedByString:slash]];
                if ([ar2 count]<2) {
                    continue;
                }
                Words *word = [NSEntityDescription insertNewObjectForEntityForName:@"Words" 
                                                            inManagedObjectContext:ctx];
                [word setCreateDate:createDate];
                [word setChangeDate:createDate];
                [word setText:[ar2 objectAtIndex:0]];
                [word setTranslate:[ar2 objectAtIndex:1]];
                [word setDescriptionStr:_wordType.name];
                [word setType:_wordType];
                [wordsAr addObject:word];
                //
                if ((i%breakPoints) == 0) {
                    [_wordType addWords:wordsAr];
                    [wordsAr removeAllObjects];
                      
                    [loadingView performSelectorOnMainThread:@selector(updateDataCurrentIndex:) withObject:[NSNumber numberWithInt:i] waitUntilDone:YES];
                    NSError *error = nil;
                    [ctx save:&error];
                    
                    if (error) {
                        NSLog(@"%@",error); 
                    }
                    
//                    [ctx reset];
                    
                    //                    [iTeachWordsAppDelegate performSelectorOnMainThread:@selector(saveDB) withObject:nil waitUntilDone:YES];
                    //                    [iTeachWordsAppDelegate saveDB];
                    [poolRoot drain];
                    poolRoot= [[NSAutoreleasePool alloc] init];
                }
            }
            [_wordType addWords:wordsAr];
            // Clean up any final imports
            NSError *error = nil;
            [ctx save:&error];
            
            if (error) {
                NSLog(@"%@",error);
            }
            
            [ctx reset];
            
            // Release context
            [ctx release];
            [wordsAr release];
            
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
        [loadingView closeLoadingView];
        [poolRoot drain];
    }
    return returnValue;
}

- (bool) addSoundWithFile:(NSString *)_fileName{
    
    NSAutoreleasePool *poolRoot= [[NSAutoreleasePool alloc] init];
    NSMutableString *fileName = [NSMutableString stringWithString:_fileName];
    [fileName replaceCharactersInRange:[[fileName lowercaseString] rangeOfString:@".wav"] withString:@""];
    
    NSURL *soundData = [[NSURL alloc] initFileURLWithPath:[RESOUCE stringByAppendingPathComponent:_fileName]];
    NSData *data = [[NSData alloc] initWithContentsOfURL:soundData];
    if (data) {
        Sounds *sound;
        sound = [NSEntityDescription insertNewObjectForEntityForName:@"Sounds" 
                                              inManagedObjectContext:CONTEXT];
        [sound setCreateDate:[NSDate date]];
        [sound setType:[NSNumber numberWithInt:0]];
        [sound setDescriptionStr:[fileName lowercaseString]];
        [sound setData:data];
        NSError *error;
        if (![CONTEXT save:&error]) {
            [UIAlertView displayError:@"There is problem with updating data"];
            [soundData release];
            [data release];
            return NO;
        }
    }else{
        [soundData release];
        [data release];
        return NO;
    }
    
    [soundData release];
    [data release];
    [poolRoot drain];
    return YES;
}

- (bool) addThemeWithFile:(NSString *)_fileName{
    NSMutableString *fileName = [NSMutableString stringWithString:_fileName];
    [fileName replaceCharactersInRange:[fileName rangeOfString:@".txt"] withString:@""];
    
    WordTypes *wordType;
    wordType = [NSEntityDescription insertNewObjectForEntityForName:@"WordTypes" 
                                             inManagedObjectContext:CONTEXT];
    [wordType setName:fileName];
    [wordType setCreateDate:[NSDate date]];
    
    [self loadWordsFromFile:_fileName toTheme:wordType];
    
    NSError *error;
    if (![CONTEXT save:&error]) {
        [UIAlertView displayError:@"There is problem with updating data"];
        return NO;
    }
    return YES;
}

- (void) loadWordsFromFile:(NSString *)fileName toTheme:(WordTypes *)wordType{
    NSString *path = [RESOUCE stringByAppendingPathComponent:fileName];
    NSString *stringContent = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *ar = [stringContent componentsSeparatedByString:@"\n"];
    [stringContent release];
    
    for (NSString *el in ar) {
        Words *words =  [NSEntityDescription insertNewObjectForEntityForName:@"Words" 
                                                      inManagedObjectContext:CONTEXT];
        NSMutableDictionary *box = [[NSMutableDictionary alloc] initWithCapacity:2];
        NSArray *arr = [el componentsSeparatedByString:@"\t"];
        if ([arr count] > 1) {
            [words setText:(NSString *)[arr objectAtIndex:0]];
            [words setTranslate:(NSString *)[arr objectAtIndex:1]];
        }
        [wordType addWordsObject:words];
        [box release];
    }    
}


+ (void) textParserFile:(NSString *)path toFile:(NSString *)_outFileName{
    NSMutableArray *_content = [[NSMutableArray alloc] init];
    //NSString *path=[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/05.02.10.txt"];
    NSString *stringContent = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *ar = [stringContent componentsSeparatedByString:@"\n"];
    [stringContent release];
    
    for (NSString *el in ar) {
        NSMutableDictionary *box = [[NSMutableDictionary alloc] initWithCapacity:2];
        NSArray *arr = [el componentsSeparatedByString:@"\t"];
        if ([arr count] > 1) {
            [box setObject:[NSString stringWithString:(NSString *)[arr objectAtIndex:0]] forKey:@"engWord"];
            [box setObject:[NSString stringWithString:(NSString *)[arr objectAtIndex:1]] forKey:@"rusWord"];
        }
        [_content addObject:box];
        [box release];
    }
    
    if ([_content count] > 0) {
        [_content writeToFile:_outFileName atomically:YES];
    }
    [_content release];
}


- (void)saveDB{
    NSError *_error;
    if (![CONTEXT save:&_error]) {
        [UIAlertView displayError:@"There is problem with saving data"];
    }else{
        //[iTeachWordsAppDelegate clearUdoManager];
    }
}

- (void)removeFileOfName:(NSString*)_fileName{
    
}

#pragma mark - showing functions
- (void)showLoadingView{
    if (!loadingView) {
        loadingView = [[LoadingViewController alloc]initWithNibName:@"LoadingViewController" bundle:nil];
    }
    [loadingView showLoadingView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//[self onCopy];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [loadingView release];
	[myLabel release];
	[myProgressView release];
    [super dealloc];
}


@end

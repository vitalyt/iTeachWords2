//
//  FilesManagerViewController.h
//  Untitled
//
//  Created by Edwin Zuydendorp on 10/12/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WordTypes;
@interface FilesManagerViewController : UIViewController {
	IBOutlet UIProgressView	*myProgressView;
	IBOutlet UILabel		*myLabel;
	NSString				*file;
	NSThread * progressThread;
	float searchProgress;
}

@property (nonatomic, retain) IBOutlet UIProgressView	*myProgressView;
@property (nonatomic, retain) IBOutlet UILabel			*myLabel;

- (void) threadStart;
- (void) updateProgress:(NSNotification *)progressNotification;
- (void) processCopyResult;
- (void) doMessage:(id)param;
+ (void) _postNotificationName:(NSDictionary *) info ;
- (void)createEditableCopyOfDatabaseIfNeeded;
- (void) reviewFile:(NSString *)fileName  inFolder:(NSString *)pathOfResource;
+ (void) textParserFile:(NSString *)path toFile:(NSString *)_outFileName;

- (bool) addSoundWithFile:(NSString *)_fileName;
- (bool) addThemeWithFile:(NSString *)_fileName;
- (void) loadWordsFromFile:(NSString *)fileName toTheme:(WordTypes *)wordType;
@end

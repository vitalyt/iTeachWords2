//
//  iTeachWordsAppDelegate.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 5/16/11.
//  Copyright 2011 OSDN. All rights reserved.
//
#import "FileManagerProtocol.h"

@class iTeachWordsViewController,MyPlayer;

@interface iTeachWordsAppDelegate : NSObject <UIApplicationDelegate, UINavigationBarDelegate,UINavigationControllerDelegate,FileManagerProtocol> {
    
    NSManagedObjectModel            *managedObjectModel;
    NSManagedObjectContext          *managedObjectContext;	    
    NSPersistentStoreCoordinator    *persistentStoreCoordinator;
    UINavigationController  *navigationController;
    
    MyPlayer                *player;
    NSMutableData           *_mutableData;
    bool                    isUpdating;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet iTeachWordsViewController *viewController;
//@property (nonatomic, retain) MyPlayer *player;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (BOOL) isNetwork;
- (void) checkDatabase;
- (void)updateData;
+ (NSManagedObjectContext *) sharedContext;
+ (void)clearUdoManager;
+ (iTeachWordsViewController *) sharedDelegate;
- (NSManagedObjectContext *) managedObjectContext;
+ (NSDictionary *)sharedSettings;
+ (NSDictionary *)loadLanguageSettings;

- (void) playSound:(NSData *)_data inView:(UIView *)_view;
- (void) showMenuView;
- (void)activateNotification;
-(NSArray*)loadRepeatDelayedTheme;

+ (void)saveDB;
+ (void)createUndoBranch;
+ (void)saveUndoBranch;
+ (void)remoneUndoBranch;

@end

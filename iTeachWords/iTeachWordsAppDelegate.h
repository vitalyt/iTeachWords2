//
//  iTeachWordsAppDelegate.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 5/16/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class iTeachWordsViewController,MyPlayer;

@interface iTeachWordsAppDelegate : NSObject <UIApplicationDelegate, UINavigationBarDelegate,UINavigationControllerDelegate> {
    
    NSManagedObjectModel            *managedObjectModel;
    NSManagedObjectContext          *managedObjectContext;	    
    NSPersistentStoreCoordinator    *persistentStoreCoordinator;
    UINavigationController  *navigationController;
    
    MyPlayer                *player;
    NSMutableData           *_mutableData;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet iTeachWordsViewController *viewController;
//@property (nonatomic, retain) MyPlayer *player;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (BOOL) isNetwork;
- (void) checkDatabase;
+ (NSManagedObjectContext *) sharedContext;
+ (void)clearUdoManager;
+ (iTeachWordsViewController *) sharedDelegate;
- (NSManagedObjectContext *) managedObjectContext;
+ (NSDictionary *)sharedSettings;
+ (NSDictionary *)loadLanguageSettings;

- (void) playSound:(NSData *)_data inView:(UIView *)_view;
- (void) showMenuView;
- (void)activateNotification;
@end

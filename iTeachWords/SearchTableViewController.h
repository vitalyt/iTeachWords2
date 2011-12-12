//
//  SearchTableViewController.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 6/2/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h"

@interface SearchTableViewController : TableViewController <UISearchBarDelegate> {
    IBOutlet UISearchBar    *mySearchBar;
}

-(void)loadDataWithPredicate:(NSPredicate *)predicate;

@end

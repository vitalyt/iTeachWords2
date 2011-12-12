//
//  LMTableViewController.h
//  MenuItemTesting
//
//  Created by Vitaly Todorovych on 3/3/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMAbstractController.h"

@interface LMTableViewController : LMAbstractController <UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UITableView    *myTable;

}

@property (nonatomic, retain) IBOutlet UITableView    *myTable;

@end

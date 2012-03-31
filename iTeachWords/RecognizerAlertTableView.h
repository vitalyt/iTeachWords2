//
//  RecognizerAlertTableView.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/24/12.
//  Copyright 2012 OSDN. All rights reserved.
//

#import "AlertTableView.h"
@class AlertTableCell;
@interface RecognizerAlertTableView : AlertTableView {
@private
    
}
- (NSString*) tableView: (UITableView*)tableView cellIdentifierForRowAtIndexPath: (NSIndexPath*)indexPath;
- (void) configureCell: (UITableViewCell*)theCell forRowAtIndexPath: (NSIndexPath*)indexPath;
@end

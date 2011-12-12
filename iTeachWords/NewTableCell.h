//
//  NewTableCell.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 6/10/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MultiSelectTableViewCell.h"

@interface NewTableCell : MultiSelectTableViewCell {
    
    IBOutlet UILabel *textLabel;
    IBOutlet UILabel *detailLabel;
}

@property (nonatomic,retain) IBOutlet UILabel *textLabel,*detailLabel;
@end

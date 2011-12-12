//
//  InputTableController.h
//  SOS
//
//  Created by Yalantis on 17.06.10.
//  Copyright 2010 Yalantis Software. All rights reserved.
//

#import "TableViewController.h"
#import "TextFieldCell.h"

@interface InputTableController : TableViewController {
	NSMutableDictionary *values;
    NSMutableArray      *titles;
	UITextField         *responder;
    UITextField         *currentTextField;
}

@property (nonatomic, retain) NSMutableDictionary *values;
@property (nonatomic, retain) NSMutableArray *titles;
@property (nonatomic, retain) UIResponder *responder;

-(void)cellDidBeginEditing:(TextFieldCell *)cell ;
-(void)cellDidEndEditing:(UITableViewCell *)cell;
- (NSString *)getKeyByIndex:(NSIndexPath *)indexPath;

@end

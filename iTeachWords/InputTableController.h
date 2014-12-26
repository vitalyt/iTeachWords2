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
    UITextField         *currentTextField;
}

@property (nonatomic, strong) NSMutableDictionary *values;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) UIResponder *responder;

-(void)cellDidBeginEditing:(TextFieldCell *)cell ;
-(void)cellDidEndEditing:(UITableViewCell *)cell;
- (NSString *)getKeyByIndex:(NSIndexPath *)indexPath;

@end

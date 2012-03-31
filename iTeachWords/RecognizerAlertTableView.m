//
//  RecognizerAlertTableView.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/24/12.
//  Copyright 2012 OSDN. All rights reserved.
//

#import "RecognizerAlertTableView.h"
#import "AlertTableCell.h"


@implementation RecognizerAlertTableView

-(id)initWithCaller:(id)_caller data:(NSArray*)_data title:(NSString*)_title andContext:(id)_context{
    NSMutableString *messageString = [NSMutableString stringWithString:@"\n\n"];
    tableHeight = 0;
    if([_data count] < 2){
        for(int i = 0; i < [_data count]; i++){
            [messageString appendString:@"\n\n"];
            tableHeight += [self cellHeight];
        }
    }else{
        [messageString setString:@"\n\n\n\n\n"];
        tableHeight = 105;
    }
    
    if(self = [super initWithTitle:_title message:messageString delegate:self cancelButtonTitle:NSLocalizedString(@"Try again", @"") otherButtonTitles:nil]){
        self.caller = _caller;
        self.context = _context;
        self.data = _data;
        [self prepare];
    }
    return self;
}

- (UITableViewCell*) tableView: (UITableView*)tableView cellForRowAtIndexPath: (NSIndexPath*)indexPath {
    NSString *cellIdentifier = [self tableView:tableView cellIdentifierForRowAtIndexPath:indexPath];
    UITableViewCell *theCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == theCell) {
		if (nil == cellIdentifier)
			theCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"default"] autorelease];
		else {
			NSArray *items = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
			theCell = [items objectAtIndex:0];
		}
//        theCell.backgroundView = [self cellBackgroundViewWithFrame:theCell.frame];
	}
	[self configureCell:theCell forRowAtIndexPath:indexPath];
	return theCell;
}

- (void) configureCell: (UITableViewCell*)theCell forRowAtIndexPath: (NSIndexPath*)indexPath {
	// Overrided by subclasses
    
    ((AlertTableCell*)theCell).titleLbl.text = [NSString stringWithFormat:@"%@",[data objectAtIndex:indexPath.row]];

}

- (NSString*) tableView: (UITableView*)tableView cellIdentifierForRowAtIndexPath: (NSIndexPath*)indexPath {
    return @"AlertTableCell";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissWithClickedButtonIndex:0 animated:YES];
    [self.caller didSelectRowAtIndex:indexPath.row withContext:[data objectAtIndex:indexPath.row]];
}


//-(float)cellHeight{
//    return 53;
//}

@end

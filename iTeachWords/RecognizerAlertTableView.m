//
//  RecognizerAlertTableView.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/24/12.
//  Copyright 2012 OSDN. All rights reserved.
//

#import "RecognizerAlertTableView.h"

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


//-(float)cellHeight{
//    return 53;
//}

@end

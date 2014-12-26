//
//  AlertTableView.m
//  Demo
//
//  Created by Edwin Zuydendorp on 1/5/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "AlertTableView.h"
#import "MyUIViewWhiteClass.h"
#import "WordTypes.h"
#import "StatisticLearning.h"
#import "AlertTableCell.h"

#define FONT_REPAT_TIME [UIFont fontWithName:@"Helvetica" size:12]

@implementation AlertTableView

@synthesize  caller, context, data;

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
    
    if(self = [super initWithTitle:_title message:messageString delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"OK", @""),nil]){
        self.caller = _caller;
        self.context = _context;
        self.data = _data;
        [self prepare];
    }
    return self;
}

-(float)cellHeight{
    return 53;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        buttonIndex = -10;
    }else{
        switch (buttonIndex) {
            case 1:
                [[NSUserDefaults standardUserDefaults]  setBool:YES forKey:@"isNotShowRepeatList"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
                
            default:
                break;
        }
        buttonIndex = -1*buttonIndex;
    }
    [self.caller didSelectRowAtIndex:buttonIndex withContext:self.context];
}

-(void)show{
    self.hidden = YES;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(myTimer:) userInfo:nil repeats:NO];
    [super show];
}

-(void)myTimer:(NSTimer*)_timer{
    self.hidden = NO;
    [myTableView flashScrollIndicators];
}

-(void)prepare{
    CGRect tableFrame = CGRectMake(11, 50, 261, tableHeight);
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 261, tableHeight) style:UITableViewStylePlain];
    if([data count] < 2){
        myTableView.scrollEnabled = NO;
    }
    [myTableView setBackgroundColor:[UIColor clearColor]];
    [myTableView setSeparatorColor:[UIColor grayColor]];//[UIColor colorWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1.0]];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    
    baseCornerRadiusView = [[MyUIViewWhiteClass alloc] initWithFrame:tableFrame];
    [baseCornerRadiusView addSubview:myTableView];
    [self addSubview:baseCornerRadiusView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 50, 261, 4)];
    imgView.image = [UIImage imageNamed:@"top.png"];
    [self addSubview:imgView];
    
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(11, tableHeight+46, 261, 4)];
    imgView.image = [UIImage imageNamed:@"bottom.png"];
    [self addSubview:imgView];
    
    
    CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 10);
    [self setTransform:myTransform];
}

- (void)willPresentAlertView:(UIAlertView *)alertView{
    int buttonsCount = (([alertView numberOfButtons]<=2)?1:[alertView numberOfButtons]);
    int offset = alertView.frame.size.height - (buttonsCount*50 + tableHeight + ((buttonsCount>2)?15:0) +[self.message length]*(([data count]<2)?20:14));
    
    CGRect tableFrame = CGRectMake(11, 50+offset, 261, tableHeight);
    [baseCornerRadiusView setFrame:tableFrame];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = [self tableView:tableView cellIdentifierForRowAtIndexPath:indexPath];
    
    UITableViewCell *theCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == theCell) {
		if (nil == cellIdentifier)
			theCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"default"];
		else {
			NSArray *items = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
			theCell = [items objectAtIndex:0];
		}
//        theCell.backgroundView = [self cellBackgroundViewWithFrame:theCell.frame];
//        theCell.selectedBackgroundView = [self cellSelectedBackgroundViewWithIndexPath:indexPath];
	}
	[self configureCell:theCell forRowAtIndexPath:indexPath];
	return theCell;
}

- (NSString*) tableView: (UITableView*)tableView cellIdentifierForRowAtIndexPath: (NSIndexPath*)indexPath {
    return @"AlertTableCell";
}

- (void) configureCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath {
	// Overrided by subclasses
    NSDictionary *dict = [data objectAtIndex:indexPath.row];
    WordTypes *_wordType = [dict objectForKey:@"wordType"];
    cell.textLabel.text = _wordType.name;
    int interval = [[dict objectForKey:@"intervalToNexLearning"] intValue];
    NSDate *newDate = [[NSDate date] dateByAddingTimeInterval:interval];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[newDate stringWithFormat:@"dd.MM.YYYY  HH:mm"]];
    [cell.detailTextLabel setTextColor:[UIColor redColor]];
    [cell.detailTextLabel setFont:FONT_REPAT_TIME];
    [((AlertTableCell*)cell) setTheme:_wordType];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissWithClickedButtonIndex:0 animated:YES];
    [self.caller didSelectRowAtIndex:indexPath.row withContext:[data objectAtIndex:indexPath.row]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellHeight];
}
@end
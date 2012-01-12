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
@implementation AlertTableView

const float cellHeight = 53;

@synthesize  caller, context, data;

-(id)initWithCaller:(id)_caller data:(NSArray*)_data title:(NSString*)_title andContext:(id)_context{
    NSMutableString *messageString = [NSMutableString stringWithString:@"\n\n"];
    tableHeight = 0;
    if([_data count] < 2){
        for(int i = 0; i < [_data count]; i++){
            [messageString appendString:@"\n\n"];
            tableHeight += cellHeight;
        }
    }else{
        [messageString setString:@"\n\n\n\n\n"];
        tableHeight = 105;
    }
    
    if(self = [super initWithTitle:_title message:messageString delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"OK", @""),NSLocalizedString(@"Don't show anymore", @""),nil]){
        self.caller = _caller;
        self.context = _context;
        self.data = _data;
        [self prepare];
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        buttonIndex = -10;
    }else{
        switch (buttonIndex) {
            case 1:
                [[NSUserDefaults standardUserDefaults]  setBool:YES forKey:@"isNotShowRepeatList"];
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
    
    UIImageView *imgView = [[[UIImageView alloc] initWithFrame:CGRectMake(11, 50, 261, 4)] autorelease];
    imgView.image = [UIImage imageNamed:@"top.png"];
    [self addSubview:imgView];
    
    imgView = [[[UIImageView alloc] initWithFrame:CGRectMake(11, tableHeight+46, 261, 4)] autorelease];
    imgView.image = [UIImage imageNamed:@"bottom.png"];
    [self addSubview:imgView];
    
    
    CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 10);
    [self setTransform:myTransform];
}

- (void)willPresentAlertView:(UIAlertView *)alertView{
    int offset = alertView.frame.size.height - (234+[self.message length]*20);
    CGRect tableFrame = CGRectMake(11, 50+offset, 261, tableHeight);
    [baseCornerRadiusView setFrame:tableFrame];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"QQQ"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"QQQ"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.textLabel.numberOfLines = 2;
    }
    NSDictionary *dict = [data objectAtIndex:indexPath.row];
    WordTypes *_wordType = [dict objectForKey:@"wordType"];
    cell.textLabel.text = _wordType.name;
    
    int interval = [[dict objectForKey:@"intervalToNexLearning"] intValue];
    NSDate *newDate = [[NSDate date] dateByAddingTimeInterval:interval];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[newDate stringWithFormat:@"dd.MM.YYYY  HH:MM"]];
    [cell.detailTextLabel setTextColor:[UIColor redColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissWithClickedButtonIndex:0 animated:YES];
    [self.caller didSelectRowAtIndex:indexPath.row withContext:[data objectAtIndex:indexPath.row]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

-(void)dealloc{
    self.data = nil;
    self.caller = nil;
    self.context = nil;
    [baseCornerRadiusView release];
    [myTableView release];
    [super dealloc];
}

@end
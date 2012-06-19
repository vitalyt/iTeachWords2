//
//  ExpandingBarViewController.m
//  iTeachWords
//
//  Created by admin on 02.04.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "ExpandingBarViewController.h"

@implementation ExpandingBarViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
@synthesize bar = _bar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self setTitle:@"UIView"];
    
    /* ---------------------------------------------------------
     * Create images that are used for the main button
     * -------------------------------------------------------*/
    UIImage *image = [UIImage imageNamed:@"red_plus_up.png"];
    UIImage *selectedImage = [UIImage imageNamed:@"red_plus_down.png"];
    UIImage *toggledImage = [UIImage imageNamed:@"red_x_up.png"];
    UIImage *toggledSelectedImage = [UIImage imageNamed:@"red_x_down.png"];
    
    /* ---------------------------------------------------------
     * Create the center for the main button and origin of animations
     * -------------------------------------------------------*/
    CGPoint center = CGPointMake(-20.0f, 370.0f);
    
    /* ---------------------------------------------------------
     * Setup buttons
     * Note: I am setting the frame to the size of my images
     * -------------------------------------------------------*/
    CGRect buttonFrame = CGRectMake(0, 0, 32.0f, 32.0f);
    UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b1 setTag:0];
    [b1 setFrame:buttonFrame];
    [b1 setImage:[UIImage imageNamed:@"parce.png"] forState:UIControlStateNormal];
    [b1 addTarget:self action:@selector(parseText:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *b2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b2 setTag:1];
    [b2 setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [b2 setFrame:buttonFrame];
    [b2 addTarget:self action:@selector(translateText:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *b3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b3 setTag:2];
    [b3 setImage:[UIImage imageNamed:@"voice.png"] forState:UIControlStateNormal];
    [b3 setFrame:buttonFrame];
    [b3 addTarget:self action:@selector(playText:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *buttons = [NSArray arrayWithObjects:b1, b2, b3, nil];
    
    /* ---------------------------------------------------------
     * Init method, passing everything the bar needs to work
     * -------------------------------------------------------*/
    RNExpandingButtonBar *bar = [[RNExpandingButtonBar alloc] initWithImage:image selectedImage:selectedImage toggledImage:toggledImage toggledSelectedImage:toggledSelectedImage buttons:buttons center:center];
    
    /* ---------------------------------------------------------
     * Settings
     * -------------------------------------------------------*/
    [bar setDelegate:self];
    [bar setSpin:YES];
    [bar setHorizontal:YES];
    
    /* ---------------------------------------------------------
     * Set our property and add it to the view
     * -------------------------------------------------------*/
    [self setBar:bar];
    
//    [[self navigationController] setToolbarHidden:YES];
//    [[self navigationController] setNavigationBarHidden:NO];
}

- (void) onNext
{
    /* ---------------------------------------------------------
     * Hide the buttons with an animation
     * -------------------------------------------------------*/
    [[self bar] hideButtonsAnimated:YES];
    
}

- (void) onAlert
{
    /* ---------------------------------------------------------
     * Hide the buttons without an animation
     * -------------------------------------------------------*/
    [[self bar] hideButtonsAnimated:YES];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"This is an alert message." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

- (void) onModal
{
    [[self bar] hideButtonsAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[self view] addSubview:[self bar]];
}

/* ---------------------------------------------------------
 * Delegate methods of ExpandingButtonBarDelegate
 * -------------------------------------------------------*/
- (void) expandingBarDidAppear:(RNExpandingButtonBar *)bar
{
    NSLog(@"did appear");
}

- (void) expandingBarWillAppear:(RNExpandingButtonBar *)bar
{
    NSLog(@"will appear");
}

- (void) expandingBarDidDisappear:(RNExpandingButtonBar *)bar
{
    NSLog(@"did disappear");
}

- (void) expandingBarWillDisappear:(RNExpandingButtonBar *)bar
{
    NSLog(@"will disappear");
}

-(UIView*)hintStateViewForDialog:(id)hintState
{
    int index = ((UIBarButtonItem*)_currentSelectedObject).tag+1;
    CGRect frame = self.view.superview.frame;
    float messageHeight = ((UIView*)_currentSelectedObject).frame.origin.y+self.bar.frame.origin.y+44;
    if (index == 4) {
        messageHeight = self.view.frame.size.height;
    }
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, messageHeight/4, frame.size.width-20, messageHeight/2)];
    l.numberOfLines = 4;
    [l setTextAlignment:UITextAlignmentCenter];
    [l setBackgroundColor:[UIColor clearColor]];
    [l setTextColor:[UIColor whiteColor]];
    [l setText:[self helpMessageForButton:_currentSelectedObject]];
    return l;
}

- (NSString*)helpMessageForButton:(id)_button{
    NSString *message = nil;
    int index = ((UIBarButtonItem*)_button).tag+1;
    switch (index) {
        case 1:
            message = NSLocalizedString(@"Разбор/парсинг выделенного текста", @"");
            break;
        case 2:
            message = NSLocalizedString(@"Перевод выделенного текста", @"");
            break;
        case 3:
            message = NSLocalizedString(@"Озвучивание выделенного текста", @"");
            break;
        case 4:
            message = NSLocalizedString(@"Выделение всего текста", @"");
            break;
        case 5:
            message = NSLocalizedString(@"Добавление нового слова", @"");
            break;
            
        default:
            break;
    }
    return message;
}

-(UIView*)hintStateViewToHint:(id)hintState
{
    [usedObjects addObject:_currentSelectedObject];
    int index = ((UIBarButtonItem*)_currentSelectedObject).tag+1;
    UIView *view = (UIView *)_currentSelectedObject;
    if ([_currentSelectedObject isKindOfClass:[UIBarButtonItem class]]) {
        @try {
            return view = ([_currentSelectedObject valueForKey:@"view"])?[_currentSelectedObject valueForKey:@"view"]:nil;
        }
        @catch (NSException *exception) {
        }
        @finally {
            
        }
    }

    if (index == 4) {
        return _currentSelectedObject;
    }
    CGRect frame = view.frame;
    UIView *buttonView = [[[UIView alloc] initWithFrame:frame] autorelease];
    [buttonView setFrame:CGRectMake(frame.origin.x+self.bar.frame.origin.x, frame.origin.y+self.bar.frame.origin.y, frame.size.width, frame.size.height)];
    return buttonView;
}



@end

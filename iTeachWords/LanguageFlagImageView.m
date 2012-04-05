//
//  LanguageFlagImageView.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 3/16/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "LanguageFlagImageView.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define IMAGEVIEWTAG 2233

@implementation LanguageFlagImageView

@synthesize image;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        imageView.tag = IMAGEVIEWTAG;
        NSString *path = [NSString stringWithFormat:@"Flags/UA.png"];
        [imageView setImage:[UIImage imageNamed:path]];
        [self addSubview:imageView];
        [imageView release];
        // Custom initializati
    }
    return self;
}

- (void) setCountryCode:(NSString *) _countryCode {
    NSString *path = [NSString stringWithFormat:@"%@.png", _countryCode];
    UIImage *im = [UIImage imageNamed:path];
    if (!im){
        im = [UIImage imageNamed:@"No_flag.png"];
    }
    [((UIImageView *)[self viewWithTag:IMAGEVIEWTAG]) setImage:im];
    //[self setNeedsDisplay];
}

- (void)dealloc
{
    [image release];
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	self.layer.borderWidth = 1.5;
	self.layer.borderColor = UIColorFromRGB(0x888888).CGColor; 
	self.layer.cornerRadius = 13;
	self.layer.masksToBounds = YES;
	
    /* 
     UIColor *topColor = UIColorFromRGB(0x424242);
     UIColor *bottomColor = UIColorFromRGB(0x2f2f2f);	
     
     CAGradientLayer *gradient = [[CAGradientLayer alloc] init];
     gradient.frame = self.bounds;
     gradient.colors = [NSArray arrayWithObjects:(id)topColor.CGColor, (id)bottomColor.CGColor, nil];
     [self.layer insertSublayer:gradient atIndex:0];
     [gradient release];
     */
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path = [NSString stringWithFormat:@"Flags/%@.png", countryCode];
    UIImage *countryImage = [UIImage imageNamed:path];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

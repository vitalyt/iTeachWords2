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
@synthesize imageView;

+ (int)cornerRadius{
    return 3;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initialize];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Custom initializati
        [self initialize];
    }
    return self;
}

- (void)initialize{
    CGRect frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
    if (!self.imageView) {
        self.imageView = [[UIImageView alloc]initWithFrame:frame];
    }else{
        [self.imageView setFrame:frame];
    }
    self.imageView.tag = IMAGEVIEWTAG;
    NSString *path = [NSString stringWithFormat:@"Flags/UA.png"];
    [self.imageView setImage:[UIImage imageNamed:path]];
    [self addSubview:self.imageView];
}

- (void) setCountryCode:(NSString *) _countryCode {
    NSString *path = [NSString stringWithFormat:@"%@.png", _countryCode];
    UIImage *im = [UIImage imageNamed:path];
    if (!im){
        im = [UIImage imageNamed:@"No_flag.png"];
    }
    [self.imageView setImage:im];
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	self.layer.borderWidth = 1.5;
	self.layer.borderColor = UIColorFromRGB(0x888888).CGColor; 
	self.layer.cornerRadius = [LanguageFlagImageView cornerRadius];
	self.layer.masksToBounds = YES;
	self.imageView.layer.borderWidth = 1.5;
	self.imageView.layer.cornerRadius = [LanguageFlagImageView cornerRadius];
	self.imageView.layer.masksToBounds = NO;
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

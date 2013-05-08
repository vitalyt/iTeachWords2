//
//  LanguageFlagImageView.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 3/16/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"



@interface LanguageFlagImageView : UIView {
    UIImage *image;
}

@property (nonatomic,retain) IBOutlet UIImageView *imageView;
@property (nonatomic,retain) UIImage *image;

+ (int)cornerRadius;
- (void)setCountryCode:(NSString *) _countryCode;

@end

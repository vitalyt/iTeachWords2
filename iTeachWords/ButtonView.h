//
//  ButtonView.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/26/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ButtonViewProtocol <NSObject>

- (void)buttonDidClick:(id)sender withIndex:(NSInteger)index;

@end

@interface ButtonView : UIViewController{

    IBOutlet UIButton *button;
    
    NSInteger   index;
    id  delegate;
}


@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) id delegate;

- (IBAction)buttonAction:(id)sender;
- (void)performInitializations;

- (void)changeButtonImage:(UIImage*)_image;

@end

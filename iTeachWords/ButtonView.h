//
//  ButtonView.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/26/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

@protocol ButtonViewProtocol <NSObject>

- (void)buttonDidClick:(id)sender withIndex:(NSNumber*)index;

@end

@interface ButtonView : UIViewController{
    IBOutlet UIButton *button;
    
    NSInteger   index;
    NSInteger   type;
    id  delegate;
}


@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) id delegate;

- (IBAction)buttonAction:(id)sender;
- (void)performInitializations;

- (void)changeButtonImage:(UIImage*)_image;

@end

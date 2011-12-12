//
//  LoadingViewController.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 6/6/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadingViewController : UIViewController {
    IBOutlet UIProgressView	*myProgressView;
	IBOutlet UILabel		*titleLabel;
    float                   total;
}

@property (nonatomic, retain) IBOutlet UIProgressView	*myProgressView;
@property (nonatomic, retain) IBOutlet UILabel			*titleLabel;
@property (nonatomic, assign) float                     total;

- (void)updateDataCurrentIndex:(NSNumber *) currentIndex;
@end

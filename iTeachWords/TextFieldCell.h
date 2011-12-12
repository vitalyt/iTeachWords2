//
//  TextFieldCell.h
//  SOS
//
//  Created by Yalantis on 17.06.10.
//  Copyright 2010 Yalantis Software. All rights reserved.
//


@interface TextFieldCell : UITableViewCell {
	UITextField *textField;
    IBOutlet UILabel *titleLabel;
	id delegate;
}

@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) id delegate;

@end

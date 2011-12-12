//
//  ManagerViewProtocol.h
//  iTeachWords
//
//  Created by  user on 03.07.11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ManagerViewProtocol <NSObject>
@required
- (void) mixingWords;
- (IBAction)selectedLanguage:(id)sender ;
@end

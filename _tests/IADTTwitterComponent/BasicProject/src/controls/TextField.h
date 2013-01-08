//
// Created by dpostigo on 12/4/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TextFieldDelegate.h"



@interface TextField : UITextField <UITextFieldDelegate> {

    BOOL dismissKeyboardOnReturn;
    TextFieldDelegate *delegateManager;

}

@property(nonatomic) BOOL dismissKeyboardOnReturn;
@property(nonatomic, strong) TextFieldDelegate *delegateManager;

@end
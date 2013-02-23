//
// Created by dpostigo on 12/4/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TextFieldDelegate.h"

typedef enum {
    TextFieldModeDefault = 0,
    TextFieldModeEmail = 1,
    TextFieldModePhone = 2,
    TextFieldModeZip = 3
} TextFieldMode;


@interface TextField : UITextField {


    BOOL isNumeric;
    NSInteger characterLimit;
    TextFieldMode mode;
    IBOutlet UIView *invalidView;

}


@property(nonatomic) BOOL isNumeric;
@property(nonatomic) NSInteger characterLimit;
@property(nonatomic) TextFieldMode mode;
@property(nonatomic, strong) UIView *invalidView;
- (BOOL) isValid;

@end
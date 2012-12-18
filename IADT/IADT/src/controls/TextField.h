//
// Created by dpostigo on 12/4/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TextFieldDelegate.h"



@interface TextField : UITextField {


    BOOL isNumeric;
    NSInteger characterLimit;

}


@property(nonatomic) BOOL isNumeric;
@property(nonatomic) NSInteger characterLimit;

@end
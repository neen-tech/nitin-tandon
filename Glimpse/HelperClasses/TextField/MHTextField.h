//
//  MHTextField.h
//  PME
//
//  Created by Nishit Shah on 3/4/14.
//  Copyright (c) 2014 Nishit Shah. All rights reserved.
//
#import <UIKit/UIKit.h>
//#import "Constant.h"

@interface MHTextField : UITextField <UIPickerViewDataSource,UIPickerViewDelegate>
{
    int len;
}

@property (nonatomic) BOOL required;
@property (nonatomic) BOOL finished;
@property (nonatomic) BOOL becomeActive;

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, weak) UISlider *slider;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) NSString *dateFormat;
@property (nonatomic, weak) NSString *timeFormat;
@property (nonatomic, weak) NSString *maximumDate;
@property (nonatomic, weak) NSString *minimumDate;

@property (nonatomic, setter = setDateField:) BOOL isDateField;
@property (nonatomic, setter = setTimeField:) BOOL isTimeField;
@property (nonatomic, setter = setSliderField:) BOOL isSliderField;

@property (nonatomic, setter = setZipCodeField:) BOOL isZipCodeField;
@property (nonatomic, setter = setContactField:) BOOL isContactField;
@property (nonatomic, setter = setTextPickerField:) BOOL isTextPickerField;
@property (nonatomic, setter = setEmailField:) BOOL isEmailField;
@property (nonatomic, setter = setNameField:) BOOL isNameField;

@property (nonatomic, setter = setPasswordField:) BOOL isPasswordField;
@property (nonatomic, setter = setUserField:) BOOL isUserField;


@property (nonatomic, assign) BOOL isValueChanged;

@property (nonatomic, retain) NSMutableArray *textPickerValues;

@property (nonatomic, assign) int maxCharacterLimit;
@property (nonatomic, assign) int minCharacterLimit;

@property (nonatomic, assign) float minInputValue;
@property (nonatomic, assign) float maxInputValue;

- (BOOL) validate;
- (void) setDateFieldWithFormat:(NSString *)dateFormat;
- (void) scrollToField;

- (void)becomeActive:(UITextField*)textField;
- (void)textFieldDidBeginEditing:(NSNotification *) notification;
-(void)setBecomeFirstResponder;
-(void)setPaddingOfTextFields;
@end

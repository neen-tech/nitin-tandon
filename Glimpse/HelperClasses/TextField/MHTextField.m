//
//  MHTextField.m
//  PME
//
//  Created by Nishit Shah on 3/4/14.
//  Copyright (c) 2014 Nishit Shah. All rights reserved.
//

#import "MHTextField.h"


#define selectedColor [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0]
#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define IS_IPAD()(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE ([[[UIDevice currentDevice] model] hasPrefix:@"iPhone"] )
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"] )
#define NetworkError @"Something wrong with internet connection"


@interface MHTextField()
{
    UITextField *_textField;
    BOOL _disabled;

}

@property (nonatomic) BOOL keyboardIsShown;
@property (nonatomic) CGSize keyboardSize;
@property (nonatomic) BOOL hasScrollView;
@property (nonatomic) BOOL invalid;

@property (nonatomic, setter = setToolbarCommand:) BOOL isToolBarCommand;
@property (nonatomic, setter = setDoneCommand:) BOOL isDoneCommand;
@property (nonatomic, setter = setNextPreCommand:) BOOL isNextPreCommand;

@property (nonatomic , strong) UIBarButtonItem *previousBarButton;
@property (nonatomic , strong) UIBarButtonItem *nextBarButton;

@property (nonatomic, strong) NSMutableArray *textFields;

@property (weak) id keyboardDidShowNotificationObserver;
@property (weak) id keyboardWillHideNotificationObserver;

@end

@implementation MHTextField

@synthesize required;
@synthesize finished;
@synthesize  becomeActive;

@synthesize scrollView;
@synthesize toolbar;
@synthesize keyboardIsShown;
@synthesize keyboardSize;
@synthesize invalid;
@synthesize textPickerValues;

@synthesize maxCharacterLimit;
@synthesize minCharacterLimit;

@synthesize minInputValue;
@synthesize maxInputValue;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self){
        [self setup];
    }
    
    return self;
}

- (void) awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (void)setup{
    if ([self respondsToSelector:@selector(setTintColor:)])
        //[self setTintColor:[UIColor blackColor]];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldShouldChange:) name:UITextFieldTextDidChangeNotification object:self];
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textField:shouldChangeCharactersInRange:replacementString:) name:UITextFieldTextDidChangeNotification object:self];
    
    toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, self.window.frame.size.width, 44);
    [toolbar setBarStyle:UIBarStyleDefault];
    //toolbar.backgroundColor=[UIColor yellowColor];//[UIColor colorWithRed:247/255.0 green:209/255.0 blue:154/255.0 alpha:1.0];//[UIColor lightGrayColor];
    //toolbar.barTintColor = [BMBGLOBAL colorFromHexString:kCOLOR_NAV];
    //toolbar.tintColor = kCOLOR_WHITE;
    
    
    self.previousBarButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(previousButtonIsClicked:)];
    
     [self.previousBarButton setImage:[UIImage imageNamed:@"IQButtonBarArrowLeft.png"]];
    self.nextBarButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonIsClicked:)];
     [self.nextBarButton setImage:[UIImage imageNamed:@"IQButtonBarArrowRight.png"]];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonIsClicked:)];
    
    NSArray *barButtonItems = @[self.previousBarButton, self.nextBarButton, flexBarButton, doneBarButton];
    
    toolbar.items = barButtonItems;
    
    self.textFields = [[NSMutableArray alloc]init];
    [self markTextFieldsWithTagInView:self.superview];
    
   
}
#pragma TextFields padding

-(void)setPaddingOfTextFields
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, _textField.frame.size.height)];
    _textField.leftView = paddingView;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    
}
- (void)markTextFieldsWithTagInView:(UIView*)view{
    int index = 0;
    if ([self.textFields count] == 0){
        for(UIView *subView in view.subviews){
            if ([subView isKindOfClass:[MHTextField class]]){
                MHTextField *textField = (MHTextField*)subView;
                textField.tag = index;
                [self.textFields addObject:textField];
                index++;
            }
        }
    }
}

- (void) doneButtonIsClicked:(id)sender{
    [self setDoneCommand:YES];
    [self resignFirstResponder];
    [self setToolbarCommand:YES];
}

- (void) nextButtonIsClicked:(id)sender{
    
    _isNextPreCommand = YES;
    
    if ((_dateFormat || _timeFormat) && [_textField.text isEqualToString:@""]) {
        NSDate *selectedDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        if (_dateFormat) {
            [dateFormatter setDateFormat:_dateFormat];
        } else if (_timeFormat) {
            [dateFormatter setDateFormat:_timeFormat];
        }
        
        [_textField setText:[dateFormatter stringFromDate:selectedDate]];
        self.isValueChanged = YES;
        
    } else if (_isTextPickerField && [_textField.text isEqualToString:@""]) {
        [_textField setText:[self.textPickerValues objectAtIndex:0]];
        self.isValueChanged = YES;
    }
    NSInteger tagIndex = self.tag;
    MHTextField *textField =  [self.textFields objectAtIndex:++tagIndex];
    
    while (!textField.isEnabled && tagIndex < [self.textFields count])
        textField = [self.textFields objectAtIndex:++tagIndex];

    [self becomeActive:textField];
}

- (void) previousButtonIsClicked:(id)sender{
    
    _isNextPreCommand = YES;
    
    if ((_dateFormat || _timeFormat) && [_textField.text isEqualToString:@""]) {
        NSDate *selectedDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        if (_dateFormat) {
            [dateFormatter setDateFormat:_dateFormat];
        } else if (_timeFormat) {
            [dateFormatter setDateFormat:_timeFormat];
        }
        
        [_textField setText:[dateFormatter stringFromDate:selectedDate]];
        self.isValueChanged = YES;
        
    } else if (_isTextPickerField && [_textField.text isEqualToString:@""]) {
        [_textField setText:[self.textPickerValues objectAtIndex:0]];
        self.isValueChanged = YES;
    }
    NSInteger tagIndex = self.tag;
    
    MHTextField *textField =  [self.textFields objectAtIndex:--tagIndex];
    
    while (!textField.isEnabled && tagIndex < [self.textFields count])
        textField = [self.textFields objectAtIndex:--tagIndex];
   
    [self becomeActive:textField];
}

- (void)becomeActive:(UITextField*)textField{
    [self setToolbarCommand:YES];
    [self resignFirstResponder];
    [textField becomeFirstResponder];
}

- (void)setBarButtonNeedsDisplayAtTag:(NSInteger)tag{
    BOOL previousBarButtonEnabled = NO;
    BOOL nexBarButtonEnabled = NO;
    
    for (int index = 0; index < [self.textFields count]; index++) {

        UITextField *textField = [self.textFields objectAtIndex:index];
    
        if (index < tag)
            previousBarButtonEnabled |= textField.isEnabled;
        else if (index > tag)
            nexBarButtonEnabled |= textField.isEnabled;
    }
    
    self.previousBarButton.enabled = previousBarButtonEnabled;
    self.nextBarButton.enabled = nexBarButtonEnabled;
}

- (void) selectInputView:(UITextField *)textField{
    if (_isDateField){
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.backgroundColor = [UIColor whiteColor];
        
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        if (![textField.text isEqualToString:@""]){
    
            if (self.dateFormat) {
                [dateFormatter setDateFormat:self.dateFormat];
            } else {
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            }
            [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
           // [datePicker setDate:[dateFormatter dateFromString:textField.text]];
        }
        
        if (_maximumDate) {
            datePicker.maximumDate = [dateFormatter dateFromString:_maximumDate];
        }
        if (_minimumDate) {
            datePicker.minimumDate = [dateFormatter dateFromString:_minimumDate];
        }
        
        [textField setInputView:datePicker];
        
    } else if (_isTimeField){
        UIDatePicker *timePicker = [[UIDatePicker alloc] init];
        timePicker.datePickerMode = UIDatePickerModeTime;
        timePicker.backgroundColor = [UIColor whiteColor];
        
        [timePicker addTarget:self action:@selector(timePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        if (![textField.text isEqualToString:@""]){
            
            if (self.dateFormat) {
                [dateFormatter setDateFormat:self.timeFormat];
            } else {
                [dateFormatter setDateFormat:@"hh:mm a"];
            }

            [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
            [timePicker setDate:[dateFormatter dateFromString:textField.text]];
        }
        
        [textField setInputView:timePicker];
        
    } else if(_isTextPickerField) {
        UIPickerView *_pickerView = [[UIPickerView alloc] init];
        [_pickerView sizeToFit];
        [_pickerView setShowsSelectionIndicator:YES];
        [_pickerView setDelegate:self];
        [_pickerView setDataSource:self];
        _pickerView.backgroundColor = [UIColor whiteColor];
        [textField setInputView:_pickerView];
        [_pickerView reloadAllComponents];
        if (![textField.text isEqualToString:@""]) {
            for (int i = 0; i < [self.textPickerValues count]; i++) {
                if ([[self.textPickerValues objectAtIndex:i] isEqualToString:textField.text]) {
                    [_pickerView selectRow:i inComponent:0 animated:YES];
                    break;
                }
            }
        }
    } else if (_isSliderField) {
        UISlider *customSlider = [[UISlider alloc] init];
        customSlider.backgroundColor = [UIColor clearColor];
        [customSlider addTarget:self action:@selector(silderValueChanged:) forControlEvents:UIControlEventValueChanged];
        UIImage *stetchLeftTrack = [[UIImage imageNamed:@"yellowslide.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
        UIImage *stetchRightTrack = [[UIImage imageNamed:@"orangeslide.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
        [customSlider setThumbImage: [UIImage imageNamed:@"slider_ball.png"]  forState:UIControlStateNormal];
        [customSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
        [customSlider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
        
        [textField setInputView:customSlider];
    }
}

#pragma mark -
#pragma mark UISlider Action Methods

-(IBAction)silderValueChanged:(id)sender {
    UISlider *silder = (UISlider *)sender;
    self.isValueChanged = YES;
    [_textField setText:[NSString stringWithFormat:@"%0.0f%%",silder.value*100]];
}

#pragma mark -
#pragma mark UIPickerView Delegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.superview.frame.size.width;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.textPickerValues count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.textPickerValues objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.isValueChanged = YES;
    [_textField setText:[self.textPickerValues objectAtIndex:row]];
    [self validate];
}

#pragma mark -
#pragma mark DatePicker Delegate

- (void)datePickerValueChanged:(id)sender{
    UIDatePicker *datePicker = (UIDatePicker*)sender;
    NSDate *selectedDate = datePicker.date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [_textField setText:[dateFormatter stringFromDate:selectedDate]];
    self.isValueChanged = YES;
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    [[NSUserDefaults standardUserDefaults] setObject:[dateFormatter stringFromDate:selectedDate] forKey:@"SELECTED_DATE"];
    
    [self validate];
}

- (void)timePickerValueChanged:(id)sender {
    UIDatePicker *timePicker = (UIDatePicker*)sender;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSString *selectedDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"SELECTED_DATE"];
    NSDate *selectedTime = timePicker.date;
    if (selectedDate && ![selectedDate isEqualToString:@""]) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
        selectedTime = [dateFormatter dateFromString:selectedDate];
    }
    
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    NSDate *currentTime = [NSDate date];
    NSTimeInterval distanceBetweenDates = [selectedTime timeIntervalSinceDate:currentTime];
    if (distanceBetweenDates < 0) {
       // [timePicker setDate:currentTime];
    }
    
    [_textField setText:[dateFormatter stringFromDate:timePicker.date]];
    self.isValueChanged = YES;
    
    [self validate];
}

#pragma mark -
#pragma mark Scrollview delegate

- (void)scrollToField{
    CGRect textFieldRect = _textField.frame;
    
    CGRect aRect = self.window.bounds;
    aRect.origin.y = -scrollView.contentOffset.y;
    
    if (IS_IPAD()) {
        
        aRect.size.height = aRect.size.height - (396 + self.toolbar.frame.size.height + 50);
        
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        
        if ((orientation == UIInterfaceOrientationLandscapeLeft) ||
            (orientation == UIInterfaceOrientationLandscapeRight)) {
            
            aRect = CGRectMake(self.window.bounds.origin.x, self.window.bounds.origin.y, self.window.bounds.size.height, self.window.bounds.size.width);
            
            aRect.origin.y = -scrollView.contentOffset.y;
            aRect.size.height = aRect.size.height - (396 + self.toolbar.frame.size.height + 50);
        }
    } else {
        aRect.size.height = aRect.size.height - (keyboardSize.height + self.toolbar.frame.size.height);
    }
    
    CGPoint textRectBoundary = CGPointMake(textFieldRect.origin.x, textFieldRect.origin.y + textFieldRect.size.height);
    
    if (!CGRectContainsPoint(aRect, textRectBoundary) || scrollView.contentOffset.y > 0) {
        CGPoint scrollPoint = CGPointMake(0.0, self.superview.frame.origin.y + _textField.frame.origin.y + _textField.frame.size.height - aRect.size.height);

        if (scrollPoint.y < 0)
            scrollPoint.y = 0;
        
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

#pragma mark -
#pragma mark Validation

- (BOOL)validate {
    
    if (required && ([self.text isEqualToString:@""] || self.text == nil)){
        
        return NO;
        
    } else if (required && (![self.text isEqualToString:@""] || !self.text) && self.minCharacterLimit) {
        if (self.text.length < self.minCharacterLimit) {
            return NO;
        }
    }
    if (_isEmailField){
        NSString *emailRegEx =
        @"(?:[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}"
        @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
        @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[A-Za-z0-9](?:[a-"
        @"z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\\[(?:(?:25[0-5"
        @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
        @"9][0-9]?|[A-Za-z0-9-]*[A-Za-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
        @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
        
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        
        if (![emailTest evaluateWithObject:self.text] && (![self.text isEqualToString:@""]  || !self.text)){
            return NO;
        }
        
    }
    
    if (_isNameField){
        NSString *emailRegEx =
        @"^[a-zA-Z ]+$";
        
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        
        if (![emailTest evaluateWithObject:self.text] && (![self.text isEqualToString:@""]  || !self.text)){
            return NO;
        }
        
    }
    else if (_isContactField && (![self.text isEqualToString:@""] || !self.text)) {
         NSString *value = self.text;
        /*NSString *phoneRegex = @"^[+,#,*]{0,1}[0-9]{8,20}$";

        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        if (![phoneTest evaluateWithObject:self.text]){
            return NO;
        }
       
     
        NSCharacterSet* charSet = [NSCharacterSet characterSetWithCharactersInString:@"+*#,;"];
        value = [[value componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];*/
        
        if (value.length < self.minCharacterLimit) {
            return NO;
        }
    } else if (_isZipCodeField && (![self.text isEqualToString:@""] || !self.text)) {
        NSString *phoneRegex = @"^[a-zA-Z0-9]*$";
        
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        if (![phoneTest evaluateWithObject:self.text]){
            return NO;
        }
        NSString *value = self.text;
        
        if (value.length < self.minCharacterLimit) {
            return NO;
        }
    }
    else if (_isUserField && (![self.text isEqualToString:@""] || !self.text)) {
        NSString *phoneRegex = @"^[a-zA-Z]+$";
        
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        if (![phoneTest evaluateWithObject:self.text]){
            return NO;
        }
        NSString *value = self.text;
        
        if (value.length < self.minCharacterLimit) {
            return NO;
        }
    }
    return YES;
}

- (void)setBecomeFirstResponder{
    [super becomeFirstResponder];
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
}

- (void)setDateFieldWithFormat:(NSString *)dateFormat {
    self.isDateField = YES;
    self.dateFormat = dateFormat;
}

#pragma mark - UIKeyboard notifications

- (void) keyboardDidShow:(NSNotification *) notification{
    if (_textField== nil) return;
    if (keyboardIsShown) return;
    if (![_textField isKindOfClass:[MHTextField class]]) return;
    
    NSDictionary* info = [notification userInfo];
    
    NSValue *aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    keyboardSize = [aValue CGRectValue].size;
    
    [self scrollToField];
    
    self.keyboardIsShown = YES;
}

- (void) keyboardWillHide:(NSNotification *) notification{
    NSTimeInterval duration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        if (!_isNextPreCommand) {
            CGFloat yOffSet =  scrollView.contentOffset.y - keyboardSize.height;
            yOffSet = (yOffSet >= 0) ? yOffSet : 0.0f;
            [self.scrollView setContentOffset:CGPointMake(0, yOffSet) animated:NO];
        }
    }];
    
    keyboardIsShown = NO;
    
    [self setNextPreCommand:NO];
}

#pragma mark - UITextField notifications

- (void)textFieldDidBeginEditing:(NSNotification *) notification{
    UITextField *textField = (UITextField*)[notification object];
    
    if (_isContactField) {
      //  textField.text = nil;
       //  finished = NO;
      
    }
    if (_isPasswordField) {
        
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    
   // [textField setTintColor:[UIColor whiteColor]];
    
    _textField = textField;
    
    [self setKeyboardDidShowNotificationObserver:[[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidShowNotification object:nil queue:nil usingBlock:^(NSNotification *notification){
        [self keyboardDidShow:notification];
    }]];
    [self setKeyboardWillHideNotificationObserver:[[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification *notification){
        [self keyboardWillHide:notification];
    }]];
 
    [self setBarButtonNeedsDisplayAtTag:textField.tag];
    
    if ([self.superview isKindOfClass:[UIScrollView class]] && self.scrollView == nil)
        self.scrollView = (UIScrollView*)self.superview;
    
    [self selectInputView:textField];
    [self setInputAccessoryView:toolbar];
    
    [self setToolbarCommand:NO];
    
}




- (void)textFieldDidEndEditing:(NSNotification *) notification{
    UITextField *textField = (UITextField*)[notification object];
    
    if (_isDateField && [textField.text isEqualToString:@""]) {
        NSDate *selectedDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
        [[NSUserDefaults standardUserDefaults] setObject:[dateFormatter stringFromDate:selectedDate] forKey:@"SELECTED_DATE"];
    }
    
    if (_isTimeField && ![textField.text isEqualToString:@""]){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
        
        NSString *selectedDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"SELECTED_DATE"];
        NSDate *selectedTime = [dateFormatter dateFromString:selectedDate];
        
        [dateFormatter setDateFormat:@"hh:mm a"];
        
        NSDate *currentTime = [NSDate date];
        NSTimeInterval distanceBetweenDates = [selectedTime timeIntervalSinceDate:currentTime];
        
        if (distanceBetweenDates < 0) {
            [textField setText:[dateFormatter stringFromDate:currentTime]];
        }
        
    }
   
    if ((_isTimeField || _isDateField) && [textField.text isEqualToString:@""] && _isDoneCommand){
        NSDate *selectedDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        if (_dateFormat) {
            [dateFormatter setDateFormat:_dateFormat];
        } else if (_timeFormat) {
            [dateFormatter setDateFormat:_timeFormat];
        }
        
        [_textField setText:[dateFormatter stringFromDate:selectedDate]];
        
    } else if (_isTextPickerField && [textField.text isEqualToString:@""] && _isDoneCommand) {
        self.isValueChanged = YES;
        [textField setText:[self.textPickerValues objectAtIndex:0]];
    }
    
    UIImageView *textFieldBG = nil;
    for (id view in [textField superview].subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            if (((UIImageView *)view).tag - 1 == textField.tag) {
                textFieldBG = ((UIImageView *)view);
                
                if (![self validate]) {
                    textFieldBG.image = [[UIImage imageNamed:@"wrong_input_button.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
                } else {
                    textFieldBG.image = [[UIImage imageNamed:@"white_button.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
                }
            }
        }
    }

    [self setDoneCommand:NO];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self.keyboardDidShowNotificationObserver];
    [[NSNotificationCenter defaultCenter]removeObserver:self.keyboardWillHideNotificationObserver];
    

    _textField = nil;
}

- (void)textFieldDidChange:(NSNotification *) notification{
    
    [self scrollToField];
    
    
    UITextField *textField = (UITextField*)[notification object];
    if (_isContactField) {
        
        NSString *str = textField.text;
        int oldlen = len;
        len = (int)str.length-1;
        if (oldlen == len && oldlen!=0) {
            len ++;
        }
    }
    
    if (self.maxCharacterLimit) {
        if (textField.text.length > self.maxCharacterLimit) {
            textField.text = [textField.text substringToIndex:textField.text.length-1];
        }
    }
    if (_isPasswordField && textField.text.length > 0) {
        NSString *string = [textField.text substringFromIndex:[textField.text length] - 1];
        if ([string isEqualToString:@" "]) {
            textField.text = [textField.text substringToIndex:textField.text.length-1];
            //[self.window makeToast:@"Space is not allowed in password" backgroundColor:[UIColor redColor]];
        }
    }
    if ((self.maxInputValue || self.minInputValue ) && ![textField.text isEqualToString:@""]) {
        float value = [textField.text floatValue];
        if (value > self.maxInputValue) {
            textField.text = [NSString stringWithFormat:@"%0.0f",self.maxInputValue];
            
        } else if (value < self.minInputValue) {
            textField.text = [NSString stringWithFormat:@"%0.0f",self.minInputValue];
        }
    }
    self.isValueChanged = YES;
}

-(BOOL)textFieldShouldChange:(NSNotification *) notification
{
    UITextField *textField = (UITextField*)[notification object];
    if (_isContactField) {
        
    
        
        
   /* if (textField.text.length) {
        if ((textField.text.length<=13)&& (finished == NO)) {
            if (textField.text.length==3) {
    
                NSString *tempStr=[NSString stringWithFormat:@"%@-",textField.text];
                textField.text=tempStr;
               
            } else if (textField.text.length==7) {
    
               NSString *tempStr=[NSString stringWithFormat:@"%@-",textField.text];
                textField.text=tempStr;
                
            } else if (textField.text.length==12) {
                finished = YES;
                [textField resignFirstResponder];
            }
        } else {
            return NO;
        }
    }*/
        NSString *str = textField.text;
        if (str.length == 3 && len < str.length) {// len check for
            // backspace
            textField.text =[NSString stringWithFormat:@"%@-",str];
        }
        if (str.length == 7 && len < str.length) {// len check for
            // backspace
            textField.text =[NSString stringWithFormat:@"%@-",str];
        }
    }
    if (_isPasswordField) {
        
        textField.text = [textField.text  uppercaseString];
    }
    
    return YES;
}



/*- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copy:))
        return NO;
    if (action == @selector(paste:))
        return NO;
    return [super canPerformAction:action withSender:sender];
}*/

@end

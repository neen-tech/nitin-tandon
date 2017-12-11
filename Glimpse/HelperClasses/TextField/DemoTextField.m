//
//  DemoTextField.m
//  PME
//
//  Created by Nishit Shah on 3/4/14.
//  Copyright (c) 2014 Nishit Shah. All rights reserved.
//
#import "DemoTextField.h"

@implementation DemoTextField

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
}

/*- (void) drawPlaceholderInRect:(CGRect)rect {
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:17], NSForegroundColorAttributeName : [UIColor colorWithRed:182/255. green:182/255. blue:183/255. alpha:1.0]};
    [self.placeholder drawInRect:CGRectInset(rect, 5, 5) withAttributes:attributes];
}*/

@end

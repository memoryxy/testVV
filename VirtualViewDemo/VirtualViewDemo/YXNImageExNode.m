//
//  YXGifImageView.m
//  VirtualViewDemo
//
//  Created by wangjianfei on 2020/8/27.
//  Copyright © 2020 tmall. All rights reserved.
//

#import "YXNImageExNode.h"
#import <UIImageView+WebCache.h>

@interface YXNImageExNode ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) NSString *src;

@end

@implementation YXNImageExNode

@dynamic cocoaView;

- (id)init {
    if (self = [super init]) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor lightGrayColor];
        _imageView.contentMode = UIViewContentModeScaleToFill;
    }
    return self;
}

- (UIView *)cocoaView {
    return _imageView;
}

- (void)setRootCocoaView:(UIView *)rootCocoaView {
    if (self.cocoaView.superview != rootCocoaView) {
        if (self.cocoaView.superview) {
            [self.cocoaView removeFromSuperview];
        }
        [rootCocoaView addSubview:self.cocoaView];
    }
    [super setRootCocoaView:rootCocoaView];
}

- (BOOL)setStringValue:(NSString *)value forKey:(int)key {
    BOOL ret  = [super setStringValue:value forKey:key];
    if (!ret) {
        if (key == STR_ID_src) {
            self.src = value;
            ret = YES;
        }
    }
    return ret;
}

- (void)updateFrame
{
    [super updateFrame];
    if (self.src && self.src.length > 0) {
        if ([self.src containsString:@"//"]) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.src]];
        }
    }
}


@end

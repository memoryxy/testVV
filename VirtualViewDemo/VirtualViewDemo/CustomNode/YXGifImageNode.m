//
//  YXGifImageNode.m
//  VirtualViewDemo
//
//  Created by wangjianfei on 2020/8/28.
//  Copyright © 2020 tmall. All rights reserved.
//

#import "YXGifImageNode.h"

@interface YXGifImageNode ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) NSString *src;

@end

@implementation YXGifImageNode

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

- (void)setRootCocoaView:(UIView *)rootCocoaView {
    if (self.cocoaView.superview != rootCocoaView) {
        if (self.cocoaView.superview) {
            [self.cocoaView removeFromSuperview];
        }
        [rootCocoaView addSubview:self.cocoaView];
    }
    [super setRootCocoaView:rootCocoaView];
}


@end

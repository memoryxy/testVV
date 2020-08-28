//
//  YXGifImageNode.m
//  VirtualViewDemo
//
//  Created by wangjianfei on 2020/8/28.
//  Copyright © 2020 tmall. All rights reserved.
//

#import "YXGifImageNode.h"
#import <VVBinaryStringMapper.h>
#import <UIImageView+WebCache.h>

@interface YXGifImageNode ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) NSString *src;
@property (nonatomic, assign) CGFloat animateInterval;
@property (nonatomic, copy) NSString *pic;

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

- (BOOL)setFloatValue:(float)value forKey:(int)key {
    BOOL ret  = [super setFloatValue:value forKey:key];
    if (!ret) {
        if (key == [VVBinaryStringMapper hashOfString:@"aniInt"]) {
            self.animateInterval = value;
            ret = YES;
        }
    }
    NSLog(@"wjflog, self.id=%ld", self.nodeID);
    return ret;
}

- (BOOL)setStringValue:(NSString *)value forKey:(int)key {
    BOOL ret  = [super setStringValue:value forKey:key];
    if (!ret) {
        if (key == STR_ID_src) {
            self.src = value;
            ret = YES;
        } else if (key == STR_ID_action) {
            self.action = value;
            ret = YES;
        }
    }
    NSLog(@"wjflog, self.id=%ld", self.nodeID);
//    NSLog(@"wjflog, self.version=%ld", self.version);
    return ret;
}

- (BOOL)setDataObj:(NSObject *)obj forKey:(int)key {
    BOOL ret = [super setDataObj:obj forKey:key];
    if (!ret) {
        if (key == STR_ID_dataTag) {
            
            ret = YES;
        } else if (key == [VVBinaryStringMapper hashOfString:@"dataDic"]) {
            
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

- (void)updateFrame
{
    [super updateFrame];
    if (self.action && self.action.length > 0) {
        if ([self.action containsString:@"//"]) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.action]];
        }
    }
}


@end

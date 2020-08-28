//
//  VVGridView.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVGridView.h"
#import "VVViewContainer.h"
#import "VVTemplateManager.h"
#import "VVPropertyExpressionSetter.h"

@interface VVGridView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, weak) id lastData;
@property (nonatomic, assign, readwrite) CGRect nodeFrame;

@end

@implementation VVGridView

@synthesize rootCocoaView = _rootCocoaView, rootCanvasLayer = _rootCanvasLayer;
@synthesize nodeFrame;

- (instancetype)init
{
    if (self = [super init]) {
        _lastData = self;
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIView *)cocoaView
{
    return _containerView;
}

- (void)setRootCocoaView:(UIView *)rootCocoaView
{
    _rootCocoaView = rootCocoaView;
    if (self.cocoaView.superview !=  rootCocoaView) {
        if (self.cocoaView.superview) {
            [self.cocoaView removeFromSuperview];
        }
        [rootCocoaView addSubview:self.cocoaView];
    }
}

- (void)setRootCanvasLayer:(CALayer *)rootCanvasLayer
{
    _rootCanvasLayer = rootCanvasLayer;
    if (self.canvasLayer) {
        if (self.canvasLayer.superlayer) {
            [self.canvasLayer removeFromSuperlayer];
        }
        [rootCanvasLayer addSublayer:self.canvasLayer];
    }
}

- (VVBaseNode *)hitTest:(CGPoint)point
{
    if (self.visibility == VVVisibilityVisible
        && CGRectContainsPoint(self.nodeFrame, point)) {
        if (self.subNodes.count > 0) {
            point.x -= self.nodeFrame.origin.x;
            point.y -= self.nodeFrame.origin.y;
            for (VVBaseNode* subNode in [self.subNodes reverseObjectEnumerator]) {
                VVBaseNode *hitNode = [subNode hitTest:point];
                if (hitNode) {
                    return hitNode;
                }
            }
        }
        if ([self isClickable] || [self isLongClickable]) {
            return self;
        }
    }
    return nil;
}

- (BOOL)setDataObj:(NSObject *)obj forKey:(int)key
{
    if (key == STR_ID_dataTag) {
        if (obj != _lastData && [obj isKindOfClass:[NSArray class]]) {
            _lastData = obj;
            
            [self.subNodes makeObjectsPerformSelector:@selector(removeFromSuperNode)];
            [self.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.containerView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
            
            NSArray *dataArray = (NSArray *)obj;
            for (NSDictionary *itemData in dataArray) {
                if ([itemData isKindOfClass:[NSDictionary class]] == NO
                    || [itemData.allKeys containsObject:@"type"] == NO) {
                    continue;
                }
                NSString *nodeType = [itemData objectForKey:@"type"];
                VVBaseNode *node = [[VVTemplateManager sharedManager] createNodeTreeForType:nodeType];
                NSArray *variableNodes = [VVViewContainer variableNodes:node];
                for (VVBaseNode *variableNode in variableNodes) {
                    [variableNode reset];
                    
                    for (VVPropertyExpressionSetter *setter in variableNode.expressionSetters.allValues) {
                        if ([setter isKindOfClass:[VVPropertyExpressionSetter class]]) {
                            [setter applyToNode:variableNode withObject:itemData];
                        }
                    }
                    variableNode.actionValue = [itemData objectForKey:variableNode.action];
                    
                    [variableNode didUpdated];
                }
                [self addSubNode:node];
            }
            for (VVBaseNode *subNode in self.subNodes) {
                subNode.rootCanvasLayer = self.containerView.layer;
            }
            for (VVBaseNode *subNode in self.subNodes) {
                subNode.rootCocoaView = self.containerView;
            }
        }
        return YES;
    }
    return NO;
}

- (void)layoutSubNodes
{
    CGPoint origin = self.nodeFrame.origin;
    self.nodeFrame = CGRectMake(0, 0, self.nodeFrame.size.width, self.nodeFrame.size.height);
    [super layoutSubNodes];
    self.nodeFrame = CGRectMake(origin.x, origin.y, self.nodeFrame.size.width, self.nodeFrame.size.height);
}

@end

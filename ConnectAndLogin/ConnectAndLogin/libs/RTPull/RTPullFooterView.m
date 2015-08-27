//
//  RTPullFooterView.m
//  PullVIew
//
//  Created by Sharon on 14-8-11.
//  Copyright (c) 2014年 OuyangRenshuang. All rights reserved.
//

#import "RTPullFooterView.h"
#import "RTPullDefination.h"


@interface RTPullFooterView()
{
    EGOPullState _state;
    UILabel *_statusLabel;
    CALayer *_arrowImage;
    UIActivityIndicatorView *_activityView;
    BOOL _isLoading;
}
- (void)setState:(EGOPullState)aState;
- (void)config;
- (CGFloat)scrollViewOffsetFromBottom:(UIScrollView *) scrollView;
- (CGFloat)visibleTableHeightDiffWithBoundsHeight:(UIScrollView *) scrollView;

@end

@implementation RTPullFooterView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}

- (void)config
{
    
    _isLoading = NO;
    CGFloat midY = PULL_AREA_HEIGTH/2;
    
    /* Config Status Updated Label */
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, midY - 10, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		
    /* Config Arrow Image */
		CALayer *layer = [[CALayer alloc] init];
		layer.frame = CGRectMake(25.0f,midY - 20, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
    /* Config activity indicator */
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:DEFAULT_ACTIVITY_INDICATOR_STYLE];
		view.frame = CGRectMake(25.0f,midY - 8, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		
		[self setState:EGOOPullNormal]; // Also transform the image
    
    /* Configure the default colors and arrow image */
    [self setBackgroundColor:nil textColor:nil arrowImage:nil];
}


#pragma mark - Util
- (CGFloat)scrollViewOffsetFromBottom:(UIScrollView *) scrollView
{
    CGFloat scrollAreaContenHeight = scrollView.contentSize.height;
    
    CGFloat visibleTableHeight = MIN(scrollView.bounds.size.height, scrollAreaContenHeight);
    CGFloat scrolledDistance = scrollView.contentOffset.y + visibleTableHeight; // If scrolled all the way down this should add upp to the content heigh.
    
    CGFloat normalizedOffset = scrollAreaContenHeight -scrolledDistance;
    
    return normalizedOffset;
    
}

- (CGFloat)visibleTableHeightDiffWithBoundsHeight:(UIScrollView *) scrollView
{
    return (scrollView.bounds.size.height - MIN(scrollView.bounds.size.height, scrollView.contentSize.height));
}


#pragma mark -
#pragma mark Setters


- (void)setState:(EGOPullState)aState
{
    
    switch (aState) {
        case EGOOPullPulling:
            
            _statusLabel.text = NSLocalizedStringFromTable(@"松手获取更多信息...",@"PullTableViewLan", @"Release to load more status");
            [CATransaction begin];
            [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];
            
            break;
        case EGOOPullNormal:
            
            if (_state == EGOOPullPulling) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
                [CATransaction commit];
            }
            
            _statusLabel.text = NSLocalizedStringFromTable(@"上提获取更多信息...", @"PullTableViewLan",@"Pull down to load more status");
            [_activityView stopAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = NO;
            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];
            
            break;
        case EGOOPullLoading:
            
            _statusLabel.text = NSLocalizedStringFromTable(@"正在加载数据...", @"PullTableViewLan",@"Loading Status");
            [_activityView startAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = YES;
            [CATransaction commit];
            
            break;
        default:
            break;
    }
    
    _state = aState;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor textColor:(UIColor *) textColor arrowImage:(UIImage *) arrowImage
{
    self.backgroundColor = backgroundColor? backgroundColor : DEFAULT_BACKGROUND_COLOR;
    _statusLabel.textColor = textColor? textColor: DEFAULT_TEXT_COLOR;
    _statusLabel.shadowColor = [_statusLabel.textColor colorWithAlphaComponent:0.1f];
    _arrowImage.contents = (id)(arrowImage? arrowImage.CGImage : DEFAULT_ARROW_IMAGE.CGImage);
}


#pragma mark -
#pragma mark ScrollView Methods


- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat bottomOffset = [self scrollViewOffsetFromBottom:scrollView];
    if (_state == EGOOPullLoading) {
        
        CGFloat offset = MAX(bottomOffset * -1, 0);
        offset = MIN(offset, PULL_AREA_HEIGTH);
        UIEdgeInsets currentInsets = scrollView.contentInset;
        currentInsets.bottom = offset? offset + [self visibleTableHeightDiffWithBoundsHeight:scrollView]: 0;
        scrollView.contentInset = currentInsets;
        
    } else if (scrollView.isDragging) {
        if (_state == EGOOPullPulling && bottomOffset > -PULL_TRIGGER_HEIGHT && bottomOffset < 0.0f && !_isLoading) {
            [self setState:EGOOPullNormal];
        } else if (_state == EGOOPullNormal && bottomOffset < -PULL_TRIGGER_HEIGHT && !_isLoading) {
            [self setState:EGOOPullPulling];
            
        }
        
        if (scrollView.contentInset.bottom != 0) {
            UIEdgeInsets currentInsets = scrollView.contentInset;
            currentInsets.bottom = 0;
            scrollView.contentInset = currentInsets;
        }
        
    }
    
}

- (void)startAnimatingWithScrollView:(UIScrollView *)scrollView
{
    _isLoading = YES;
    [self setState:EGOOPullLoading];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    UIEdgeInsets currentInsets = scrollView.contentInset;
    currentInsets.bottom = PULL_AREA_HEIGTH + [self visibleTableHeightDiffWithBoundsHeight:scrollView];
    scrollView.contentInset = currentInsets;
    [UIView commitAnimations];
    if([self scrollViewOffsetFromBottom:scrollView] == 0){
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y + PULL_TRIGGER_HEIGHT) animated:YES];
    }
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    
    
    if ([self scrollViewOffsetFromBottom:scrollView] <= - PULL_TRIGGER_HEIGHT && !_isLoading) {
        if ([_delegate respondsToSelector:@selector(pullFooterViewDidTriggerLoadMore:)]) {
            [_delegate pullFooterViewDidTriggerLoadMore:self];
        }
        [self startAnimatingWithScrollView:scrollView];
    }
    
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    _isLoading = NO;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    UIEdgeInsets currentInsets = scrollView.contentInset;
    currentInsets.bottom = 0;
    scrollView.contentInset = currentInsets;
    [UIView commitAnimations];
    
    [self setState:EGOOPullNormal];
    
}



@end

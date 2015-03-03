//
//  HCSCarousel.h
//  HCSCarousel
//
//  Created by Sahil Kapoor on 26/02/15.
//  Copyright (c) 2015 Hot Cocoa Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HCSCarousel;

@protocol HCSCarouselDelegate <NSObject>

- (NSUInteger)numberOfImagesAvailableForImageScroller:(HCSCarousel *)scroller;
- (id)imageScroller:(HCSCarousel *)scroller infoForItemAtIndex:(NSUInteger)index;
- (void)imageScroller:(HCSCarousel *)scroller didSelectImageAtIndex:(NSUInteger)index;

@optional

- (NSString *)reuseIdentifierForImageScroller:(HCSCarousel *)scroller index:(NSUInteger)index;
- (void)didChangePageAtIndex:(CGFloat)newOffsetX;

@end

/// auto limits the images, so that the page control indicators remain visible
@interface HCSCarousel : UIView

- (id)initWithFrame:(CGRect)frame;

- (void)reloadData;

- (void)scrollToImageAtIndex:(NSUInteger)index animated:(BOOL)animated;

/// override to set custom carousel cells
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerCells;
- (Class)reusableCellClass;

/// pragma mark - customize methods
- (void)setCarouselBackgroundColor:(UIColor *)backgroundColor;

@property (nonatomic, weak) id<HCSCarouselDelegate> delegate;
@property (nonatomic, readonly) NSUInteger numberOfItems;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

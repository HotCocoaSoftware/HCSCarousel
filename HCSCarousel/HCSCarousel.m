//
//  HCSCarousel.m
//  HCSCarousel
//
//  Created by Sahil Kapoor on 26/02/15.
//  Copyright (c) 2015 Hot Cocoa Software. All rights reserved.
//

#import "HCSCarousel.h"
#import "HCSImageScrollerCell.h"
#import "FrameAccessor.h"

static CGFloat const kPageControlHeight = 30;
static CGFloat const kMargin = 10.f;

static NSUInteger const kMaxNumberOfImages = 18;

@interface HCSCarousel () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *URLs;

@end

@implementation HCSCarousel
@synthesize numberOfItems=_numberOfItems;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;

}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self setUpCollectionView];
    [self setUpPageControl];
}

- (void)setUpCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = self.bounds.size;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    [_collectionView setContentOffset:CGPointZero animated:NO];
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    _collectionView.pagingEnabled = YES;
    [self addSubview:_collectionView];
    
    [self registerCells];
}

- (void)setUpPageControl {
    _pageControl = [[UIPageControl alloc] initWithFrame:(CGRect){kMargin, self.height - kPageControlHeight, self.width - 2 * kMargin, kPageControlHeight}];
    [self addSubview:_pageControl];
    _pageControl.enabled = NO;
    _pageControl.hidden = YES;
}

- (void)registerCells {
    [self registerClass:[self reusableCellClass] forCellWithReuseIdentifier:NSStringFromClass([self reusableCellClass])];
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [_collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (Class)reusableCellClass {
    return [HCSImageScrollerCell class];
}

- (void)scrollToImageAtIndex:(NSUInteger)index animated:(BOOL)animated {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self numberOfItems];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = [self reuseIdentifierForIndexPath:indexPath];
    HCSImageScrollerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell configureWithInfo:[self.delegate imageScroller:self infoForItemAtIndex:indexPath.item]];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate imageScroller:self didSelectImageAtIndex:indexPath.row];
}

- (NSString *)reuseIdentifierForIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(reuseIdentifierForImageScroller:index:)]) {
        return [self.delegate reuseIdentifierForImageScroller:self index:indexPath.item];
    } else {
        return NSStringFromClass([self reusableCellClass]);
    }
}

- (NSUInteger)numberOfItems {
    NSUInteger numberOfAvailableImages = [self.delegate numberOfImagesAvailableForImageScroller:self];
    
    if ([_pageControl sizeForNumberOfPages:numberOfAvailableImages].width < (self.width - 2 * kMargin)) {
        _numberOfItems = numberOfAvailableImages;
    } else {
        _numberOfItems = kMaxNumberOfImages;
    }
    return _numberOfItems;
}

- (void)reloadData {
    _pageControl.numberOfPages = [self numberOfItems];
    _pageControl.currentPage = 0;
    _pageControl.hidden = NO;
    
    [self.collectionView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = _collectionView.width;
    float fractionalPage = _collectionView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
    
    if ([self.delegate respondsToSelector:@selector(didChangePageAtIndex:)]) {
        [self.delegate didChangePageAtIndex:_collectionView.contentOffset.x];
    }
}

#pragma mark - customize methods

- (void)setCarouselBackgroundColor:(UIColor *)backgroundColor {
    [self.collectionView setBackgroundColor:backgroundColor];
}

@end

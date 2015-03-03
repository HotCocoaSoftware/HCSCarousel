//
//  ViewController.m
//  HCSCarousel
//
//  Created by Sahil Kapoor on 26/02/15.
//  Copyright (c) 2015 Hot Cocoa Software. All rights reserved.
//

#import "ViewController.h"
#import "HCSCarousel.h"

@interface ViewController () <HCSCarouselDelegate>

@property (nonatomic, strong) HCSCarousel *carouselView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeCarouselView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.carouselView reloadData];
}

- (void)initializeCarouselView {
    _carouselView = [[HCSCarousel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    self.carouselView.delegate = self;
    [self.view addSubview:self.carouselView];
}

#pragma mark - HCSCarouselDelegate

- (NSUInteger)numberOfImagesAvailableForImageScroller:(HCSCarousel *)scroller {
    return 5;
}

- (id)imageScroller:(HCSCarousel *)scroller infoForItemAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:return [NSURL URLWithString:@"http://cdn.filmschoolrejects.com/images/mondo-heavy-metal-670x380.jpg"];
        case 1:return [NSURL URLWithString:@"http://www.fun2smiles.com/wp-content/uploads/2014/10/hoods_are_cool____by_moni158-d6dam6q-36.jpg"];
        case 2:return [NSURL URLWithString:@"http://masspictures.net/wp-content/uploads/2014/04/young-and-stupid-cool-quotes.jpg"];
        default:return [NSURL URLWithString:@"http://www.graphics99.com/wp-content/uploads/2012/06/cool.jpg"];
    }
}

- (void)imageScroller:(HCSCarousel *)scroller didSelectImageAtIndex:(NSUInteger)index {

}

@end

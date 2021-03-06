//
//  HCSImageScrollerCell.m
//  HCSCarousel
//
//  Created by Sahil Kapoor on 26/02/15.
//  Copyright (c) 2015 Hot Cocoa Software. All rights reserved.
//

#import "HCSImageScrollerCell.h"
#import "UIImageView+XLNetworking.h"
#import "UIImageView+HCSAdditions.h"
#import "FrameAccessor.h"

@interface HCSImageScrollerCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation HCSImageScrollerCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
        
        _progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _progressView.roundedCorners = YES;
        _progressView.center = self.contentView.center;
        [self.contentView addSubview:_progressView];
        
        [self setUpGradient];
    }
    return self;
}

- (void)setUpGradient {
    UIImage *gradientImage = [UIImage imageNamed:@"gradient-bottom"];
    UIImageView *bottomGradientView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height - gradientImage.size.height, self.width, gradientImage.size.height)];
    bottomGradientView.image = gradientImage;
    [self.contentView addSubview:bottomGradientView];
}

- (void)configureWithInfo:(id)info {
    [self setImageURL:info];
}

- (void)setImageURL:(NSURL *)URL {
    self.imageView.image = nil;
    [self.progressView setHidden:NO];
    [self.progressView setProgress:0];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    HCSImageScrollerCell * __weak weakSelf = self;
    [self.imageView setImageWithURLRequest:request
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       HCSImageScrollerCell *strongSelf = weakSelf;
                                       [strongSelf.progressView setHidden:YES];
                                       strongSelf.imageView.image = image;
                                   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       [weakSelf.progressView setProgress:0 animated:YES];
                                   }
                     downloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                         float newValue = totalBytesExpectedToRead ? ((float)totalBytesRead / totalBytesExpectedToRead) : 0;
                         [weakSelf.progressView setProgress:newValue animated:YES];
                     }
     ];
}

- (void)setImageWithReq:(NSURLRequest *)primaryRequest
        fallBackRequest:(NSURLRequest *)fallBackRequest {
    self.imageView.image = nil;
    [self.progressView setHidden:NO];
    [self.progressView setProgress:0];
    
    HCSImageScrollerCell * __weak weakSelf = self;
    [self.imageView setImageWithURLRequest:primaryRequest fallbackURLRequest:fallBackRequest
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       HCSImageScrollerCell *strongSelf = weakSelf;
                                       [strongSelf.progressView setHidden:YES];
                                       strongSelf.imageView.image = image;
                                   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       HCSImageScrollerCell *strongSelf = weakSelf;
                                       [strongSelf.progressView setProgress:0 animated:YES];
                                   } downloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                                       HCSImageScrollerCell *strongSelf = weakSelf;
                                       float newValue = totalBytesExpectedToRead ? ((float)totalBytesRead / totalBytesExpectedToRead) : 0;
        [strongSelf.progressView setProgress:newValue animated:YES];
    }];
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
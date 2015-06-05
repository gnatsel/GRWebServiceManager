//
//  FeedItemPresenter.h
//  SampleGRWebServiceManager
//
//  Created by Olivier Lestang [DAN-PARIS] on 02/06/2015.
//  Copyright (c) 2015 Gnatsel Reivilo. All rights reserved.
//

#import "Presenter.h"
@class FeedItem;
@interface FeedItemPresenter : Presenter
@property (nonatomic,weak) IBOutlet UIImageView *mediaImageView;
@property (nonatomic,weak) IBOutlet UILabel *titleFeedLabel;
@property (nonatomic,weak) IBOutlet UILabel *descriptionFeedLabel;


@end

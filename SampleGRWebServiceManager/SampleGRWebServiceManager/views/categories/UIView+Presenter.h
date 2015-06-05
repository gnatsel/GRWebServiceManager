//
//  UITableViewCell+Presenter.h
//  SampleGRWebServiceManager
//
//  Created by Olivier Lestang [DAN-PARIS] on 04/06/2015.
//  Copyright (c) 2015 Gnatsel Reivilo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Presenter;
@interface UIView (Presenter)
@property (nonatomic, weak) IBOutlet Presenter *presenter;

@end

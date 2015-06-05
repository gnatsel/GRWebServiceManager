//
//  UITableViewCell+Presenter.m
//  SampleGRWebServiceManager
//
//  Created by Olivier Lestang [DAN-PARIS] on 04/06/2015.
//  Copyright (c) 2015 Gnatsel Reivilo. All rights reserved.
//

#import "UIView+Presenter.h"
#import "Presenter.h"
#import <objc/runtime.h>

static char UIPresenter;

@implementation UIView (UIPresenter)
- (void)setPresenter:(Presenter *)presenter{
    [self willChangeValueForKey:@"GRPresenter"];
    objc_setAssociatedObject(self, &UIPresenter,
                             presenter,
                             UIPresenter);
    [self didChangeValueForKey:@"GRPresenter"];
}

- (Presenter *)presenter {
    return objc_getAssociatedObject(self, &UIPresenter);
}
@end

//
//  JHNineImageView.h
//  JHKit
//
//  Created by HaoCold on 2018/4/8.
//  Copyright © 2018年 HaoCold. All rights reserved.
//
//  MIT License
//
//  Copyright (c) 2018 xjh093
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import <UIKit/UIKit.h>

@interface JHNineImageView : UIView

/// Default is 9. Minimum is 1. Maximum is 9.
@property (nonatomic,  assign) NSInteger  maxCount;
/// Numbers in one row. Default is 3.
@property (nonatomic,  assign) NSInteger  rowCount;
/// Image array on show.
@property (nonatomic,  strong,  readonly) NSArray *imageArray;
/// Handle Add Image event in your VC.
@property (nonatomic,    copy) void (^addImageBlock)(void);
/// Delete image event, 'index' is image in 'imageArray'.
@property (nonatomic,    copy) void (^deleteImageBlock)(NSInteger index);
/// Tap image event, 'index' is image in 'imageArray'.
@property (nonatomic,    copy) void (^tapImageBlock)(NSInteger index);

/// Add a image to show.
- (void)addImage:(UIImage *)image;

/// Add image array to show. If 'flag' is YES, all images in 'imageArray' will be remove before add new images.
- (void)addImageArray:(NSArray *)imageArray removeOldImages:(BOOL)flag;

@end

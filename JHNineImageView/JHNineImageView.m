//
//  JHNineImageView.m
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

#import "JHNineImageView.h"

//!!!!: Protocol
@protocol JHNineImageCollectionViewCellDelegate <NSObject>
- (void)cellDidClickDeleteButton:(NSInteger)index;  // Delete
- (void)cellDidClickAddButton:(NSInteger)index;     // Add
- (void)cellDidClickTapButton:(NSInteger)index;     // Tap
@end

//!!!!: Cell
@interface JHNineImageCollectionViewCell : UICollectionViewCell
@property (nonatomic,  assign) NSInteger  row;
@property (nonatomic,  strong) UIImageView *imageView;
@property (nonatomic,  strong) UIButton *deleteButton;
@property (nonatomic,  strong) UIButton *addButton;
@property (nonatomic,  strong) UIButton *tapImageViewButton;

@property (nonatomic,    weak) id<JHNineImageCollectionViewCellDelegate>delegate;
@end

@implementation JHNineImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self jhSetupVies];
    }
    return self;
}

- (void)jhSetupVies
{
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.addButton];
    [self.contentView addSubview:self.tapImageViewButton];
    [self.contentView addSubview:self.deleteButton];
}

- (void)delete
{
    if (_delegate && [_delegate respondsToSelector:@selector(cellDidClickDeleteButton:)]) {
        [_delegate cellDidClickDeleteButton:_row];
    }
}

- (void)add
{
    if (_delegate && [_delegate respondsToSelector:@selector(cellDidClickAddButton:)]) {
        [_delegate cellDidClickAddButton:_row];
    }
}

- (void)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(cellDidClickTapButton:)]) {
        [_delegate cellDidClickTapButton:_row];
    }
}

- (UIImageView *)imageView{
    if (!_imageView) {
        CGFloat W = CGRectGetWidth(self.bounds) - 20;
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 20, W, W);
        //imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView = imageView;
    }
    return _imageView;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(CGRectGetWidth(self.bounds)-40, 0, 40, 40);
        [button setTitleColor:[UIColor blackColor] forState:0];
        [button setImage:[UIImage imageNamed:@"JHNineImageView_delete"] forState:0];
        [button addTarget:self action:@selector(delete) forControlEvents:1<<6];
        _deleteButton = button;
    }
    return _deleteButton;
}

- (UIButton *)addButton{
    if (!_addButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = _imageView.frame;
        [button addTarget:self action:@selector(add) forControlEvents:1<<6];
        _addButton = button;
    }
    return _addButton;
}

- (UIButton *)tapImageViewButton{
    if (!_tapImageViewButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = _imageView.frame;
        [button addTarget:self action:@selector(tap) forControlEvents:1<<6];
        _tapImageViewButton = button;
    }
    return _tapImageViewButton;
}

@end

//!!!!!: JHNineImageView
@interface JHNineImageView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,JHNineImageCollectionViewCellDelegate>
@property (nonatomic,  strong) UICollectionView *collectionView;
@property (nonatomic,  strong) NSMutableArray *dataArray;

@property (nonatomic,  assign) BOOL  canAddImage;
@property (nonatomic,  assign) BOOL  shouldAddHolderImage;
@end

@implementation JHNineImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    CGFloat space = 10;
    CGFloat W = [UIScreen mainScreen].bounds.size.width;
    CGFloat H = (W - space)/3;
    frame = CGRectMake(frame.origin.x, frame.origin.y, W, H);
    self = [super initWithFrame:frame];
    if (self) {
        _maxCount = 9;
        _rowCount = 3;
        _imageCornerRadius = 0.0;
        _dataArray = @[].mutableCopy;
        _canAddImage = YES;
        _shouldAddHolderImage = NO;
        [_dataArray addObject:[UIImage imageNamed:@"JHNineImageView_add"]];
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma mark - event

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHNineImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHNineImageCollectionViewCell_ID" forIndexPath:indexPath];
    cell.delegate = self;
    UIImage *image = _dataArray[indexPath.row];
    cell.imageView.image = image;
    cell.row = indexPath.row;
    if (_imageCornerRadius > 0) {
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.cornerRadius = _imageCornerRadius;
    }
    
    if (indexPath.row < _dataArray.count - 1) {
        cell.addButton.hidden = YES;
        cell.deleteButton.hidden = NO;
        cell.tapImageViewButton.hidden = NO;
    }else if ([image isEqual:[UIImage imageNamed:@"JHNineImageView_add"]]) {
        cell.addButton.hidden = NO;
        cell.deleteButton.hidden = YES;
        cell.tapImageViewButton.hidden = YES;
    }else{
        cell.addButton.hidden = YES;
        cell.deleteButton.hidden = NO;
        cell.tapImageViewButton.hidden = NO;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat space = 10;
    CGFloat W = [UIScreen mainScreen].bounds.size.width;
    CGFloat H = (W - space - _rowCount)/_rowCount;
    return CGSizeMake(H, H);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

#pragma mark - JHNineImageCollectionViewCellDelegate

- (void)cellDidClickDeleteButton:(NSInteger)index{
    [self deleteEvent:index];
}
- (void)cellDidClickAddButton:(NSInteger)index{
    if (_addImageBlock) {
        _addImageBlock();
    }
}
- (void)cellDidClickTapButton:(NSInteger)index{
    if (_tapImageBlock) {
        _tapImageBlock(index);
    }
}

- (void)deleteEvent:(NSInteger)index
{
    if (index < _dataArray.count) {
        _canAddImage = YES;
        [_dataArray removeObjectAtIndex:index];
        
        if (_shouldAddHolderImage) {
            _shouldAddHolderImage = NO;
            [_dataArray addObject:[UIImage imageNamed:@"JHNineImageView_add"]];
        }
        
        [self reSizeFrame];
        [_collectionView reloadData];
        
        if (_deleteImageBlock) {
            _deleteImageBlock(index);
        }
    }
}

- (void)addImage:(UIImage *)image{
    if (!_canAddImage) {
        return;
    }
    
    if ([image isKindOfClass:[UIImage class]]) {
        if (_dataArray.count < _maxCount) {
            [_dataArray insertObject:image atIndex:_dataArray.count-1];
        }else{
            _canAddImage = NO;
            _shouldAddHolderImage = YES;
            [_dataArray removeLastObject];
            [_dataArray addObject:image];
        }
        
        [self reSizeFrame];
        [_collectionView reloadData];
    }
}

- (void)reSizeFrame
{
    CGFloat space = 10;
    CGFloat W = [UIScreen mainScreen].bounds.size.width;
    CGFloat H = (W - space)/_rowCount;
    CGRect frame = self.frame;
    CGRect cframe = _collectionView.frame;
    
    if (_dataArray.count < _rowCount + 1) { // one row. 一行
        // H = (W - 4 * space)/3 + 2 * space;
    }else if (_dataArray.count < _rowCount*2 + 1){// two rows.    两行
        H += H;
    }else{ // three rows.   三行
        H += 2*H;
    }
    frame.size.height = H + 10;
    self.frame = frame;
    cframe.size.height = H;
    _collectionView.frame = cframe;
}

- (void)addImageArray:(NSArray *)imageArray removeOldImages:(BOOL)flag{
    if (_dataArray.count == _maxCount && _canAddImage == NO) {
        return;
    }
    
    if (imageArray.count > 0) {
        NSMutableArray *marr = @[].mutableCopy;
        for (id obj in imageArray) {
            if ([obj isKindOfClass:[UIImage class]]) {
                [marr addObject:(UIImage *)obj];
            }
        }
        if (marr.count > 0) {
            if (flag) {
                [_dataArray removeAllObjects];
            }else{
                [_dataArray removeLastObject];
            }
            
            [_dataArray addObjectsFromArray:marr];
            if (_dataArray.count >= _maxCount) {
                _canAddImage = NO;
                _shouldAddHolderImage = YES;
                [_dataArray removeObjectsInRange:NSMakeRange(_maxCount, _dataArray.count-_maxCount)];
            }else if (_dataArray.count < _maxCount) {
                [_dataArray addObject:[UIImage imageNamed:@"JHNineImageView_add"]];
            }
            
            [self reSizeFrame];
            [_collectionView reloadData];
        }
    }
}

- (NSArray *)imageArray{
    NSMutableArray *marr = _dataArray.mutableCopy;
    
    // The last image is holderImage, so we remove it.
    // 不需要添加占位图时，说明占位图存在
    if (!_shouldAddHolderImage) {
        [marr removeLastObject];
    }
    return marr;
}

- (void)setMaxCount:(NSInteger)maxCount{
    if (maxCount>= 1 && maxCount <= 9) {
        _maxCount = maxCount;
    }
}

- (void)setRowCount:(NSInteger)rowCount{
    if (rowCount >= 3) {
        _rowCount = rowCount;
        [self reSizeFrame];
    }
}

#pragma mark - lazy

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        CGFloat space = 10;
        CGFloat W = [UIScreen mainScreen].bounds.size.width;
        CGFloat H = (W - space - _rowCount)/_rowCount;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(space, 0, W-space, H) collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.scrollEnabled = NO;
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerClass:[JHNineImageCollectionViewCell class] forCellWithReuseIdentifier:@"JHNineImageCollectionViewCell_ID"];
        _collectionView = collectionView;
    }
    return  _collectionView;
}

@end

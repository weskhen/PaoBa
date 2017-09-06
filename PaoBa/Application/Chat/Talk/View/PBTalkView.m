//
//  PBTalkView.m
//  PaoBa
//
//  Created by wujian on 2017/3/14.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBTalkView.h"
#import "PBTalkViewProtocol.h"
#import "PBController.h"
#import "PBTalkAdapter.h"
#import "PBTalkInputBar.h"
#import "PBTableView.h"
#import "PBTalkTableHeaderView.h"
#import "PBBottomView.h"
#import "PBTalkPresenterProtocol.h"
#import "PBTalkControllerProtocol.h"
#import "ChatMessage.h"
#import "Masonry.h"
#import "PBDetailUser.h"

#define PBTalkScrollViewHeight 230
@interface PBTalkView ()<PBTalkViewProtocol,PBTalkAdapterDelegate,PBTalkInputBarDelegate,PBTalkTableHeaderViewDelegate>

@property (nonatomic, strong)  PBTalkAdapter *adapter;
@property (nonatomic, strong)  PBTableView *tableView;
@property (nonatomic, strong)  PBTalkInputBar *inputBar;
@property (nonatomic, strong)  PBTalkTableHeaderView *followTipView;
@property (nonatomic, strong)  PBBottomView *bottomView;
@property (nonatomic, strong)  UIView *tableHeaderView;

@property (nonatomic, assign)  BOOL isFunctionShow;
@property (nonatomic, assign)  BOOL isKeyboardShow;

@property (nonatomic, assign)  BOOL hasMoreData; //是否有更多数据

@end
@implementation PBTalkView

- (void)dealloc
{
    _adapter.adapterDelegate = nil;
    _inputBar.delegate = nil;
    TraceS(@"PBTalkView dealloc");
}
#pragma mark - PBTalkViewProtocol 类代理
- (void)buildView
{
    self.isFunctionShow = NO;
    [self addSubview:self.tableView];
    [self addSubview:self.inputBar];
    [self addSubview:self.bottomView];
    
    _tableView.delegate = self.adapter;
    _tableView.dataSource = self.adapter;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
    }];
    [_inputBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_bottom);
        make.leading.trailing.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(PBTalkInputBarHeight);
    }];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.mas_equalTo(0);
    }];
    
    
    //add Gesture
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_tableView addGestureRecognizer:singleTap];
    /** 获取第一页聊天记录 **/
    PBSend(self.baseController.presenter, PBTalkPresenterProtocol, getPreMoreMessages);
}

- (void)refreshTalkViewWithMsgList:(NSMutableArray *)msgList andHasMoreMsg:(BOOL)hasMore
{
    float heightBeforeUpdate = [_adapter getTableContentHeight] - _tableView.contentOffset.y;
    heightBeforeUpdate = MAX((_tableView.frame.size.height - _tableView.tableHeaderView.frame.size.height), heightBeforeUpdate);
    
    self.hasMoreData = hasMore;
    [_adapter setLoadingEnable:hasMore];
    
    NSMutableArray *tempMsgList = [NSMutableArray arrayWithArray:msgList];
    if (self.hasMoreData) {
        PBSend(self.baseController.presenter, PBTalkPresenterProtocol, insertLoadingCell:tempMsgList);
    }
    [_adapter setAdapterArray:tempMsgList];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self renderTalkView:false];
        
        float heightAfterUpdate = [_adapter getTableContentHeight];
        if (heightAfterUpdate < (_tableView.frame.size.height - _tableView.tableHeaderView.frame.size.height) ) {
            [_tableView setContentOffset:CGPointMake(0, 0)];
        }
        else
        {
            [_tableView layoutIfNeeded];
            [_tableView setContentOffset:CGPointMake(0, heightAfterUpdate - heightBeforeUpdate)];
        }
        
        //stop loading
        [_adapter endLoading];
    });
    
}

- (void)refreshPersonalInfoView
{
    //关注tipView
    PBDetailUser *detailUser = PBSend(self.baseController.presenter, PBTalkPresenterProtocol, getTalkUser);
    [self.baseController updateNavTitle:detailUser.name];
    if (detailUser.isFollowing.intValue == 0) {
        [self addSubview:self.followTipView];
        [_followTipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.equalTo(self);
            make.height.mas_equalTo(38);
        }];
        _tableView.tableHeaderView = self.tableHeaderView;
    }
    [self scrollingToBottom:true];
}

- (void)followUserSuccessed:(BOOL)sucessed
{
    if (sucessed) {
        if (_followTipView) {
            [_followTipView removeFromSuperview];
            _followTipView.delegate = nil;
            _followTipView = nil;
        }
        _tableView.tableHeaderView = nil;
    }
    else
    {
        
    }
}



- (void)hiddenDownInputViewAndBottomView
{
    if (self.isKeyboardShow == NO && self.isFunctionShow == NO) {
        return;
    }
    [self hiddenFunctionView:0.25];
    if (self.isKeyboardShow) {
        //键盘弹出
        [self hiddenKeyBoard];
    }
    else{
        //键盘隐藏
        [self refreshInputBarBottomOffset:0 animationTime:0.25];
    }
}

- (void)insertNewMessage:(ChatMessage *)message talkArray:(NSMutableArray *)messageList
{
    NSMutableArray *tempMsgList = [NSMutableArray arrayWithArray:messageList];
    if (self.hasMoreData) {
        PBSend(self.baseController.presenter, PBTalkPresenterProtocol, insertLoadingCell:tempMsgList);
    }
    [_adapter setAdapterArray:tempMsgList];
    [_tableView reloadData];
    [self scrollingToBottom:YES];
}

- (void)updateMessage:(ChatMessage *)message andMessageIndex:(NSInteger)index
{
    NSInteger row = index;
    if (self.hasMoreData) {
        row = row+1;
    }
    
    ChatMessage *temMessage = [[_adapter getAdapterArray] objectAtIndex:row];
    if (temMessage.rowid.longLongValue == message.rowid.longLongValue) {
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)updateTalkTable:(NSMutableArray *)messageList
{
    NSMutableArray *tempMsgList = [NSMutableArray arrayWithArray:messageList];
    if (self.hasMoreData) {
        PBSend(self.baseController.presenter, PBTalkPresenterProtocol, insertLoadingCell:tempMsgList);
    }
    [_adapter setAdapterArray:tempMsgList];
    [_tableView reloadData];
}


#pragma mark - privateMethod
- (void)renderTalkView:(BOOL)toBottom
{
    //set inputview mode
    [_tableView reloadData];
    
    if (toBottom) {
        [self scrollingToBottom:true];
    }
}

- (void)scrollingToBottom:(BOOL)animated {
    
    //不scroll的情况：正在拖动table
    if (_tableView.isDragging) {
        return;
    }
    
    int cellCount = (int)[_tableView.dataSource tableView:_tableView numberOfRowsInSection:0];
    if (cellCount == 0) {
        return;
    }
    
    CGRect frame = _tableView.frame;
    CGFloat originY = 0;//
    CGFloat contentHeight = _tableView.contentSize.height + originY;
    if (contentHeight > frame.size.height) {
        CGPoint offset = CGPointMake(0, _tableView.contentSize.height - _tableView.frame.size.height);
        [_tableView layoutIfNeeded];
        [_tableView setContentOffset:offset animated:animated];
    }
}

- (void)hiddenKeyBoard
{
    if (self.isKeyboardShow == NO && self.isFunctionShow == NO) {
        return;
    }
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

/** 输入框下方偏移量 **/
- (void)refreshInputBarBottomOffset:(CGFloat)height animationTime:(NSTimeInterval)time
{
    if (height == 0) {
        if (self.isFunctionShow) {
            height = PBTalkScrollViewHeight;
        }
    }
    
    PBWEAKSELF
    [UIView animateWithDuration:time animations:^{
        PBSTRONGSELF
        [_inputBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(strongSelf).offset(-height);
        }];
        //        PBTalkControllerFrom fromSource = PBSend(self.baseController, PBTalkControllerProtocol, getCurrentControllerFrom);
        //        if (fromSource == PBTalkControllerFrom_Stream && self.isKeyboardShow == NO) {
        //            [strongSelf scrollingToBottom:NO];
        //            [strongSelf layoutIfNeeded];
        //
        //        }else
        {
            [strongSelf layoutIfNeeded];
            [strongSelf scrollingToBottom:NO];
        }
    }];
}

/** 送礼列表 **/
- (void)showFunctionView:(NSTimeInterval)time
{
    if (self.isFunctionShow) {
        return;
    }
    self.isFunctionShow = YES;
    
    //弹出
    
    
    PBWEAKSELF
    [UIView animateWithDuration:time animations:^{
        PBSTRONGSELF
        [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(PBTalkScrollViewHeight);
        }];
        [strongSelf layoutIfNeeded];
        [strongSelf scrollingToBottom:NO];
        
    }];
    
}

- (void)hiddenFunctionView:(NSTimeInterval)time
{
    if (!self.isFunctionShow) {
        return;
    }
    self.isFunctionShow = NO;
    PBWEAKSELF
    [UIView animateWithDuration:time animations:^{
        PBSTRONGSELF
        [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [strongSelf layoutIfNeeded];
    }];
}

#pragma mark - buttonEvent  按钮触摸时间
- (void)handleSingleTap:(UIGestureRecognizer*)sender
{
    [self hiddenDownInputViewAndBottomView];
}

#pragma mark - PBTalkAdapterDelegate
- (void)startToGetMoreData
{
    PBWEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        PBSTRONGSELF
        PBSend(strongSelf.baseController.presenter, PBTalkPresenterProtocol, getPreMoreMessages);
    });
}

#pragma mark - PBTalkTableHeaderViewDelegate 顶部关注
- (void)followButtonClicked
{
    TraceS(@"关注按钮点击");
    PBSend([(PBController *)self.baseController presenter], PBTalkPresenterProtocol, followTalkUser);
}


#pragma mark - PBTalkInputBarDelegate 底部输入框
- (void)inputBar:(PBTalkInputBar *)inputBar didSendText:(NSString *)text
{
    //发送文本
    PBSend(self.baseController.presenter, PBTalkPresenterProtocol, sendChatText:text);
    //输入框清除
    [_inputBar clearInputText];
}

- (void)inputBar:(PBTalkInputBar *)inputBar keyboardWillShow:(CGRect)keyboardRect animationTime:(NSTimeInterval)time
{
    //展示键盘
    self.isKeyboardShow = YES;
    [self refreshInputBarBottomOffset:keyboardRect.size.height animationTime:time];
}

- (void)inputBar:(PBTalkInputBar *)inputBar keyboardWillHideAnimationTime:(NSTimeInterval)time
{
    //隐藏键盘
    self.isKeyboardShow = NO;
    [self refreshInputBarBottomOffset:0 animationTime:time];
}

- (void)changeInputBarHeight:(CGFloat)height
{
    
    PBWEAKSELF
    [UIView animateWithDuration:0.1 animations:^{
        PBSTRONGSELF
        //textView 高度改变 导致InputBar 高度改变
        [_inputBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        [strongSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        [_inputBar reloadInputTextViews];
    }];
    
}

- (void)functionButtonClicked
{
    //+按钮点击
    [self showFunctionView:0.25];
    if (self.isKeyboardShow) {
        [self hiddenKeyBoard];
    }
    else
    {
        [self refreshInputBarBottomOffset:0 animationTime:0.25];
    }
}

#pragma mark - setter/getter 懒加载
- (PBTalkAdapter *)adapter
{
    if (!_adapter) {
        _adapter = [PBTalkAdapter new];
        _adapter.talkAdapterDelegate = self;
    }
    return _adapter;
}

- (PBTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[PBTableView alloc] init];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableView;
}

- (PBTalkInputBar *)inputBar
{
    if (!_inputBar) {
        _inputBar = [[PBTalkInputBar alloc] init];
        _inputBar.delegate = self;
    }
    return _inputBar;
}

- (PBBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [PBBottomView new];
    }
    return _bottomView;
}

- (PBTalkTableHeaderView *)followTipView
{
    if (!_followTipView) {
        _followTipView = [[PBTalkTableHeaderView alloc] init];
        _followTipView.delegate = self;
    }
    return _followTipView;
}


- (UIView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38)];
        _tableHeaderView.backgroundColor = [UIColor clearColor];
    }
    return _tableHeaderView;
}

@end

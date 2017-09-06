//
//  ChatMessageCell.m
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "ChatMessageCell.h"
#import "NSObject+BaseController.h"
#import "PBController.h"
#import "PBTalkViewProtocol.h"
#import "PBTalkInteractorProtocol.h"

@interface ChatMessageCell ()


@end

@implementation ChatMessageCell

static NSMutableDictionary* registeredRenderCellMap = NULL;

+ (NSMutableDictionary*)getRegisteredRenderCellMap
{
    return registeredRenderCellMap;
}

+ (void)registerRenderCell:(Class)cellClass messageType:(int)mtype
{
    if (!registeredRenderCellMap) {
        registeredRenderCellMap = [NSMutableDictionary new];
    }
    NSString* className = NSStringFromClass(cellClass);
    [registeredRenderCellMap setObject:className forKey:[NSNumber numberWithInt:mtype]];
}

+ (float)calculteRenderCellHeight:(ChatMessage*)msg
{
    return 0;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = nil;
        self.contentView.backgroundColor = nil;

        
        _touchFailedFrame = CGRectMake(0, 0, 0, 0);
        _touchAvatarFrame = CGRectMake(0, 0, 0, 0);

        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [self.contentView addGestureRecognizer:longPress];
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        [self.contentView addGestureRecognizer:singleTap];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc
{
    TraceS(@"ChatMessageCell dealloc");
}

- (void)gotoDrawingCell
{
    //#TODO
}

- (void)goToAvatarProfile
{
    PBSend([(PBController *)self.baseController interactor], PBTalkInteractorProtocol, gotoTalkUserProfileController);
}

- (void)willGotoResend
{
    
}

- (void)invalidTouchOnCell
{
    PBSend([(PBController *)self.baseController cView], PBTalkViewProtocol, hiddenDownInputViewAndBottomView);
}

- (void)normalBubble
{
    
}

#pragma mark- privateMethod

- (void)setTouchFailedFrame:(CGRect)frame
{
    _touchFailedFrame = frame;
}

- (void)setTouchAvatarFrame:(CGRect)frame
{
    _touchAvatarFrame = frame;
}

- (void)setTouchMenuFrame:(CGRect)frame
{
    _touchMenuFrame = frame;
}

#pragma mark - UIGestureRecognizer
static bool isMenuVisible = false;
- (void)handleSingleTap:(UIGestureRecognizer*)sender
{
    CGPoint locationInView = [sender locationInView:self];
    //for test message click
    if(CGRectContainsPoint(_touchAvatarFrame, locationInView))
    {
        [self goToAvatarProfile];
    }
    else if (CGRectContainsPoint(_touchFailedFrame, locationInView))
    {
        [self willGotoResend];
    }
    else
    {
        if (isMenuVisible) {
            [self hideMenu];
        }
        else
        {
            [self invalidTouchOnCell];
        }
    }
}

- (BOOL)handleShowMenu:(CGPoint)location
{
    return false;
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)sender
{
    CGPoint locationInView = [sender locationInView:self];
    if (CGRectContainsPoint(_touchMenuFrame, locationInView)) {
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            //let UITextView decide if cell can become FirstResponder, prevent keyboard from hiding
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectHideMenu:) name:UIMenuControllerDidHideMenuNotification object:nil];
            
            if ([self handleShowMenu:locationInView] == false) {
                [self becomeFirstResponder];
                [self showMenu:_touchMenuFrame];
            }
        }
    }
}

//required to show menu
- (BOOL)canBecomeFirstResponder {
    return true;
}
- (void)showMenu:(CGRect)frame
{
    NSArray* definedMenuItems = @[
                                  [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyCell:)],
                                  [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteCell:)]
                                  ];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:nil];
    [menu setMenuItems:definedMenuItems];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([window isKeyWindow] == NO)
    {
        [window becomeKeyWindow];
        [window makeKeyAndVisible];
    }
    [menu setTargetRect:frame inView:self];
    [menu setMenuVisible:YES animated:YES];
    
    isMenuVisible = true;
}

- (void)hideMenu
{
    PBWEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        PBSTRONGSELF
        [strongSelf delayHideMenu];
    });
}

- (void)delayHideMenu
{
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:false];
    isMenuVisible = false;
}

- (void)detectHideMenu:(NSNotification *)notification
{
    isMenuVisible = false;
    [self normalBubble];
}


#pragma mark- Menu Item Events
- (void)copyCell:(id)sender
{
    
}
- (void)deleteCell:(id)sender
{
//    [Notif postNotificationName:Notification_MessageCell_Delete object:_chatMsg];
}

@end

//
//  PBTalkAdapter.m
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBTalkAdapter.h"
#import "ChatMessage.h"
#import "PBMessageCellHelper.h"
#import "ChatMessageCell.h"
#import "ChatLoadCell.h"


@interface PBTalkAdapter ()

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL loadingEnable;

@end

@implementation PBTalkAdapter

- (float)getTableContentHeight
{
    float height = 0;
    for (ChatMessage* msg in self.getAdapterArray) {
        height += msg.renderHeight;
    }
    return height;
}

- (void)endLoading
{
    self.isLoading = NO;
}

- (void)setLoadingEnable:(BOOL)enable
{
    _loadingEnable = enable;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float cellHeight = 0;
    if (indexPath.row > self.getAdapterArray.count-1) {
        return cellHeight;
    }
    
    
    ChatMessage* msg = [self.getAdapterArray objectAtIndex:indexPath.row];
    if (![msg isKindOfClass:[ChatMessage class]]) {
        return cellHeight;
    }
    cellHeight = msg.renderHeight;
    cellHeight = MAX(cellHeight, 0);
    
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > self.getAdapterArray.count-1) {
        return [UITableViewCell new];
    }
    
    NSArray* arr = self.getAdapterArray;
    
    if (arr.count == 0) {
        return [UITableViewCell new];
    }
    if (indexPath.row > arr.count - 1) {
        TraceS(@"table cell index out of bound!");
        return [UITableViewCell new];
    }
//    TICK
    ChatMessageCell* cell = NULL;
    
    ChatMessage* message = [arr objectAtIndex:indexPath.row];
    
    Class renderClass = [[PBMessageCellHelper sharedInstance] getRenderClassByMessageType:message.msgtype.intValue];
    if (!renderClass) {
        return [UITableViewCell new];
    }
    NSString* cellIndentifier = NSStringFromClass(renderClass);
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[renderClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    cell.chatMessage = message;
    
    //防止cell被重用时播放动画
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [cell gotoDrawingCell];
    [CATransaction commit];
//    TOCK
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self.isLoading) {
        return;
    }
    if (indexPath.row == 0 && self.loadingEnable == YES) {
        if ([self.talkAdapterDelegate respondsToSelector:@selector(startToGetMoreData)]) {
            self.isLoading = YES;
            [self.talkAdapterDelegate startToGetMoreData];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row > self.getAdapterArray.count-1) {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    id model = self.getAdapterArray[indexPath.row];
    if (self.adapterDelegate && [self.adapterDelegate respondsToSelector:@selector(didSelectCellData:)]) {
        [self.adapterDelegate didSelectCellData:model];
    }
}

@end

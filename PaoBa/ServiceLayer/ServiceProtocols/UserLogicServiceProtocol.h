//
//  UserLogicServiceProtocol.h
//  PaoBa
//
//  Created by wujian on 4/18/16.
//  Copyright © 2016 wesk痕. All rights reserved.
//

#ifndef UserLogicServiceProtocol_h
#define UserLogicServiceProtocol_h

@protocol UserLogicServiceProtocol <NSObject>

- (void)getUserProfileFromServerWithUserId:(NSNumber *)userId andDelegate:(id)delegate;


- (void)modifyUserWithName:(NSString *)name andDelegate:(id)delegate;
@end
#endif /* UserLogicServiceProtocol_h */

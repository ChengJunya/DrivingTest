//
//  CYLockView.h
//  驾考刷题
//
//  Created by 程俊亚 on 15/12/30.
//  Copyright © 2015年 john. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CYLockView;
@protocol CYLockViewDelegate <NSObject>

- (void)lockView:(CYLockView *)lockView didSelectedPassword:(NSString *)password;

@end

@interface CYLockView : UIView

@property(nonatomic, weak)id<CYLockViewDelegate> delegete;

@end

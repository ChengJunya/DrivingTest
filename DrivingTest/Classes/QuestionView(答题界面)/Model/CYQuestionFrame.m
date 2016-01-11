//
//  CYQuestionFrame.m
//  驾考刷题
//
//  Created by 程俊亚 on 15/12/14.
//  Copyright © 2015年 john. All rights reserved.
//

#import "CYQuestionFrame.h"
#import "CYQuestionModel.h"
#import "NSString+Extension.h"
#import "MJExtension.h"
#define QuestionCellBorderW 10

@implementation CYQuestionFrame
- (void)setQuestionMode:(CYQuestionModel *)questionMode
{
    _questionMode = questionMode;

    /** 题干 */
    CGFloat maxW = __kScreenWidth;
    CGSize titleSize = [questionMode.question sizeWithFont:[UIFont systemFontOfSize:15]maxW:maxW];
    self.titleLabelF = (CGRect){{10, 10}, titleSize};

    /** 图片 */
    CGFloat answerY = 0;
    if (questionMode.url == nil || [questionMode.url isEqualToString:@""]) {
        answerY = CGRectGetMaxY(self.titleLabelF) + QuestionCellBorderW;
    } else {
        CGFloat imageX = QuestionCellBorderW * 4;
        CGFloat imageY = CGRectGetMaxY(self.titleLabelF) + QuestionCellBorderW * 2;
        CGFloat imageW = __kScreenWidth - 2 * QuestionCellBorderW * 4;
        CGFloat imageH = 100;
        self.questionImageF = CGRectMake(imageX, imageY, imageW, imageH);
        answerY = CGRectGetMaxY(self.questionImageF) + QuestionCellBorderW * 2;
    }
    
    /** 选项 */
        CGFloat answerX = 0;
        CGFloat answerW = __kScreenWidth;
        CGFloat answerH = 185;
        self.answerViewF = CGRectMake(answerX, answerY, answerW, answerH);

    /** 滚动背景 */
    CGFloat scrollW = __kScreenWidth;
    CGFloat scrollH = CGRectGetMaxY(self.answerViewF);
    self.scrollViewF = CGRectMake(0, 0, scrollW, scrollH);
}

//MJ的解档和归档
MJCodingImplementation
@end

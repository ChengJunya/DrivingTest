//
//  CYLockView.m
//  驾考刷题
//
//  Created by 程俊亚 on 15/12/30.
//  Copyright © 2015年 john. All rights reserved.
//

#import "CYLockView.h"

@interface CYLockView()

/** 选中的所有按钮 */
@property(nonatomic,strong)NSMutableArray *seletedBtns;
/** 最后一个点 */
@property(nonatomic,assign)CGPoint lastPoint;

@end
@implementation CYLockView

- (NSMutableArray *)seletedBtns
{
    if (!_seletedBtns) {
        self.seletedBtns = [[NSMutableArray alloc]init];
    }
    return _seletedBtns;
}

- (instancetype)initWithFrame:(CGRect)frame{
    //初始化按钮
    if(self = [super initWithFrame:frame]){
        [self setupBtns];
    }
    return self;
}

- (void)setupBtns{
    //添加9个按钮
    for (NSInteger i = 0; i < 9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        // 设置默认图片
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];

        //设置按钮不可用
        btn.userInteractionEnabled = NO;

        [self addSubview:btn];
    }
}

/** 绘制按钮键的连线 */
- (void)drawRect:(CGRect)rect
{
    NSInteger selectedCount = self.seletedBtns.count;
    //没有选中按钮直接返回
    if (selectedCount == 0) return;
    //创建路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < selectedCount; i++) {
        CGPoint btnCenter = [self.seletedBtns[i] center];
        if (i == 0) {
            [path moveToPoint:btnCenter];
        }else{
            [path addLineToPoint:btnCenter];
        }
    }
    //追加一个点的路径
    [path addLineToPoint:self.lastPoint];
    path.lineWidth = 8;
    //连接点的样式
    path.lineJoinStyle = kCGLineCapRound;
    path.lineCapStyle = kCGLineCapRound;
    [[UIColor greenColor] set];
    //渲染
    [path stroke];
}

- (void)layoutSubviews{
    [super layoutSubviews];

    //重新布局9个按钮
    CGFloat btnW = 74;
    CGFloat btnH = 74;
    NSInteger btnCount = self.subviews.count;

    // 每一个按钮的间距
    CGFloat padding = (self.frame.size.width - 3 * btnW) / 4;

    for (NSInteger i = 0; i < btnCount; i++) {
        UIButton *btn = self.subviews[i];

        // 当前按钮所处的列
        NSInteger column = i % 3;

        // 当前按钮所处的行
        NSInteger row = i / 3;

        // 计算每一个按钮的位置
        // x = 间距 + （按钮的宽度 + 间距） * 列
        CGFloat btnX = padding + (btnW + padding) * column;

        // y = 间距 + （按钮的高度 + 间距） * 行
        CGFloat btnY = padding + (btnH + padding) * row;

        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //获取当前的触摸点
    UITouch *touch = [touches anyObject];
    CGPoint touchP = [touch locationInView:touch.view];

    //判断当前的触摸点在不在按钮范围内
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, touchP)) {
            //放在一个选中按钮的数组
            if (btn.selected == NO) {
                [self.seletedBtns addObject:btn];
            }
            btn.selected = YES;
        }else{
            //记录最后的连接点
            self.lastPoint = touchP;
        }
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //拼接选中按钮的索引
    NSMutableString *password = [NSMutableString string];
    for (UIButton *selectedBtn in self.seletedBtns) {
        [password appendFormat:@"%ld",(long)selectedBtn.tag];
    }
    //取消连线
    //取消所有按钮的选中状态为NO
    [self.seletedBtns makeObjectsPerformSelector:@selector(setSelected:) withObject:@(NO)];

    //移除所有选中的按钮
    [self.seletedBtns removeAllObjects];

    //重绘
    [self setNeedsDisplay];
}

@end

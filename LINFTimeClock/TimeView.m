//
//  TimeView.m
//  LINFTimeClock
//
//  Created by Linf on 15/6/4.
//  Copyright (c) 2015年 Linf. All rights reserved.
//

#import "TimeView.h"

#define WIDTH               [UIScreen mainScreen].bounds.size.width     // 屏幕宽度
#define HEIGHT              [UIScreen mainScreen].bounds.size.height    // 屏幕高度
#define KTAP                30.0f                                       // 时钟tap
#define KRADIUS             (WIDTH - KTAP * 2)                          // 时钟圆半径
#define KCIRCLE_Y           100.0f                                      // 时钟圆位置Y值
#define KSECONDNUMBER       60                                          // 时钟显示秒数
#define KHOURNUMBER         12                                          // 时钟显示时数
#define KSECONDANGLE        6.0f                                        // 秒数所占角度(360.0f / 60.0f)
#define KHOURANGLE          30.0f                                       // 时钟所占角度(360.0f / 12.0f)
#define KIMAGEWIDTH         39.0f                                       // 罗马数字图片宽度
#define KIMAGEHEIGHT        23.5f                                       // 罗马数字图片高度
#define KRADIAN(angle)      ((M_PI * angle) / 180.0f)                   // 角度转弧度
#define KTIMELABLETEXT      [NSString stringWithFormat:@"%ld年%ld月%ld日 %ld时%ld分%ld秒", (long)year, (long)month, (long)day, (long)hour, (long)minute, (long)second]
#define KCIRCLECENTER       5.0f                                        // 时钟圆心半径
#define KSECONDLINEWIDTH    1.0f                                        // 秒线宽度
#define KMINUTELINEWIDTH    2.0f                                        // 分线宽度
#define KHOURLINEWIDTH      3.0f                                        // 时线宽度

@interface TimeView() {
    NSInteger year;
    NSInteger month;
    NSInteger day;
    NSInteger hour;
    NSInteger minute;
    NSInteger second;
    UILabel *timeLab;
    UIBezierPath *secondPath;
    UIBezierPath *minutePath;
    UIBezierPath *hourPath;
}

@end

@implementation TimeView

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self updateTime];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, WIDTH, 44.0f)];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont fontWithName:@"Georgia" size:22.0f];
        nameLabel.textColor = [UIColor colorWithRed:52.0f/255.0f green:152.0f/255.0f blue:219.0f/255.0f alpha:1.0f];
        nameLabel.text = @"LINF的时钟";
        [self addSubview:nameLabel];
        
        timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, WIDTH + KCIRCLE_Y, WIDTH, KTAP)];
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.font = [UIFont fontWithName:@"Georgia" size:22.0f];
        timeLab.text = KTIMELABLETEXT;
        [self addSubview:timeLab];
        
        UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, WIDTH, HEIGHT)];
        bgImage.image = [self showImageView];
        [self addSubview:bgImage];
        
        for (int index = 0; index < KHOURNUMBER; index ++) {
            CGFloat angle = index * KHOURANGLE;
            CGFloat radian = KRADIAN(angle);
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, KIMAGEWIDTH, KIMAGEHEIGHT)];
            int gap = 10.0f;
            imgView.center = CGPointMake(WIDTH / 2 + sin(radian) * (KRADIUS / 2 - gap - KIMAGEHEIGHT / 2), gap + KCIRCLE_Y + KIMAGEHEIGHT / 2 + (1 - cos(radian)) * (KRADIUS / 2 - gap - KIMAGEHEIGHT / 2));
            imgView.transform = CGAffineTransformMakeRotation(radian);
            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"time%d", index]];
            [self addSubview:imgView];
        }
        
        secondPath = [UIBezierPath bezierPath];
        minutePath = [UIBezierPath bezierPath];
        hourPath = [UIBezierPath bezierPath];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    }
    return self;
}

/*
 * 创建时钟背景图
 */
- (UIImage *) showImageView {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
    
    [[UIColor lightGrayColor] set];
    // 创建秒线
    for (int index = 0; index < KSECONDNUMBER; index ++) {
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        linePath.lineWidth = KSECONDLINEWIDTH;
        CGFloat angle = index * KSECONDANGLE;
        CGFloat radian = KRADIAN(angle);
        int gap = 10.0f;
        [linePath moveToPoint:CGPointMake(WIDTH / 2 + sin(radian) * (KRADIUS / 2 - gap), KCIRCLE_Y + gap + (1 - cos(radian)) * (KRADIUS / 2 - gap))];
        [linePath addLineToPoint:CGPointMake(WIDTH / 2 + sin(radian) * (KRADIUS / 2), KCIRCLE_Y + (1 - cos(radian)) * (KRADIUS / 2))];
        [linePath stroke];
    }
    
    [[UIColor blackColor] set];
    for (int index = 0; index < KHOURNUMBER; index ++) {
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        linePath.lineWidth = KHOURLINEWIDTH;
        CGFloat angle = index * KHOURANGLE;
        CGFloat radian = KRADIAN(angle);
        int gap = 10.0f;
        [linePath moveToPoint:CGPointMake(WIDTH / 2 + sin(radian) * (KRADIUS / 2 - gap), KCIRCLE_Y + gap + (1 - cos(radian)) * (KRADIUS / 2 - gap))];
        [linePath addLineToPoint:CGPointMake(WIDTH / 2 + sin(radian) * (KRADIUS / 2), KCIRCLE_Y + (1 - cos(radian)) * (KRADIUS / 2))];
        [linePath stroke];
    }
    
    [[UIColor lightGrayColor] set];
    UIBezierPath *bigCircle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(KTAP, KCIRCLE_Y, KRADIUS, KRADIUS)];
    bigCircle.lineWidth = KCIRCLECENTER;
    [bigCircle stroke];
    
    UIBezierPath *normalCircle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake((WIDTH - KCIRCLECENTER) / 2, KCIRCLE_Y + (KRADIUS - KCIRCLECENTER) / 2, KCIRCLECENTER, KCIRCLECENTER)];
    normalCircle.lineWidth = KCIRCLECENTER;
    [normalCircle stroke];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void) updateTime {
    //获取当前时间
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    year = [dateComponent year];
    month = [dateComponent month];
    day = [dateComponent day];
    hour = [dateComponent hour];
    minute = [dateComponent minute];
    second = [dateComponent second];
    
    // 更新视图
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGFloat secondRadio = (second * M_PI) / KHOURANGLE;
    CGFloat minuteRadio = (minute * M_PI) / KHOURANGLE;
    CGFloat hourRadio = ((hour % KHOURNUMBER) * M_PI) / KSECONDANGLE + ((minute * M_PI) / (KSECONDNUMBER * KSECONDANGLE));
    
    [[UIColor lightGrayColor] set];
    
    int secondGap = 40.0f;
    [secondPath removeAllPoints];
    secondPath.lineWidth = KSECONDLINEWIDTH;
    [secondPath moveToPoint:CGPointMake(WIDTH / 2, KCIRCLE_Y + KRADIUS / 2)];
    [secondPath addLineToPoint:CGPointMake(WIDTH / 2 + sin(secondRadio) * (KRADIUS / 2 - secondGap), KCIRCLE_Y + secondGap + (1 - cos(secondRadio)) * (KRADIUS / 2 - secondGap))];
    [secondPath stroke];
    
    int minuteGap = 50.0f;
    [minutePath removeAllPoints];
    minutePath.lineWidth = KMINUTELINEWIDTH;
    [minutePath moveToPoint:CGPointMake(WIDTH / 2, KCIRCLE_Y + KRADIUS / 2)];
    [minutePath addLineToPoint:CGPointMake(WIDTH / 2 + sin(minuteRadio) * (KRADIUS / 2 - minuteGap), KCIRCLE_Y + minuteGap + (1 - cos(minuteRadio)) * (KRADIUS / 2 - minuteGap))];
    [minutePath stroke];
    
    int hourGap = 60.0f;
    [hourPath removeAllPoints];
    hourPath.lineWidth = KHOURLINEWIDTH;
    [hourPath moveToPoint:CGPointMake(WIDTH / 2, KCIRCLE_Y + KRADIUS / 2)];
    [hourPath addLineToPoint:CGPointMake(WIDTH / 2 + sin(hourRadio) * (KRADIUS / 2 - hourGap), KCIRCLE_Y + hourGap + (1 - cos(hourRadio)) * (KRADIUS / 2 - hourGap))];
    [hourPath stroke];
    
    timeLab.text = KTIMELABLETEXT;
}


@end

//
//  ViewController.m
//  text1
//
//  Created by zyh on 2017/9/1.
//  Copyright © 2017年 zyh. All rights reserved.
//

#import "ViewController.h"
typedef void (^SHResultArrayBlock)(NSArray *results);

@interface ViewController (){
    NSMutableArray * arr;
}
@property (weak, nonatomic) IBOutlet UITextField *txt;

@end

@implementation ViewController

- (void)viewDidLoad {
    //已经提交到git上了
    
    [super viewDidLoad];
}

- (IBAction)actionTxt:(id)sender {
    NSLog(@"\n----------Insert: begin-------------\n");

    arr = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<[_txt.text intValue]; i++) {
        [arr addObject:[NSNumber numberWithInt:i]];
    }
    
    NSLog(@"\n----------Insert: end-------------\n");
}


- (IBAction)actionBegin:(id)sender {
    NSMutableArray * arrAll1 = [NSMutableArray arrayWithArray:arr];
    NSLog(@"\n----------Insert: begin-------------\n");
  //  NSArray * arrGate =
    [self sortByInsert:arrAll1];
    NSLog(@"\n----------Insert: end-------------\n");

}

- (IBAction)actionCompare:(id)sender {
    
    NSArray * arrAll = [NSArray arrayWithArray:arr];
    NSLog(@"\n----------Insert: begin-------------\n");
    NSArray * arrGate=[self splitArrSender:arrAll theMoreNum:nil];
    NSLog(@"\n----------Insert: end-------------\n");
}

-(NSArray *)sortByInsert:(NSMutableArray *)arrSender{
    NSArray * arrAll = [NSArray arrayWithArray:arrSender];
    for (int j = 1; j<arrAll.count; j++) {
        [arrSender removeObjectAtIndex:j];
        int theNum =[arrAll[j] intValue];
        NSArray * arrNew =[NSArray arrayWithArray:arrSender];
        for (int i=0; i<j; i++) {
            if(theNum>[arrNew[i] intValue]){
                [arrSender insertObject:[NSNumber numberWithInt:theNum] atIndex:i];
                break;
            }
        }
    }
    return arrSender;
}

-(NSArray *)splitArrSender:(NSArray*)arrSender theMoreNum:(NSNumber *)moreNum{
    NSMutableArray * arrMade1=[NSMutableArray arrayWithCapacity:0];
    NSMutableArray * arrMade2=[NSMutableArray arrayWithCapacity:0];
    
    int isEvenNumber = !(arrSender.count%2);
    if (isEvenNumber) {
        for (int i=0; i<arrSender.count/2; i++) {
            [arrMade1 addObject:arrSender[i]];
            [arrMade2 addObject:arrSender[arrSender.count/2+1]];
        }
        if (arrMade1.count==1) {
            if ([arrMade1.firstObject intValue]<[arrMade2.lastObject intValue]) {
                return @[arrMade2.firstObject,arrMade1.firstObject];
            }else{
                return @[arrMade1.firstObject,arrMade2.firstObject];
            }
        }else{
           NSMutableArray * arrGate1 = [NSMutableArray arrayWithArray:[self splitArrSender:arrMade1 theMoreNum:nil]];
           NSMutableArray * arrGate2 = [NSMutableArray arrayWithArray:[self splitArrSender:arrMade2 theMoreNum:nil]];
            NSMutableArray * arrNew =[NSMutableArray arrayWithCapacity:0];
            for (int i=0; i<(arrSender.count+(moreNum?1:0)); i++) {
                if (!arrGate2.count) {
                    if (moreNum) {
                        arrNew =[self getArrCompareWithMoreNum:arrGate1 oldArr:arrNew moreNum:moreNum];
                    }else{
                        [arrNew addObjectsFromArray:arrGate1];
                    }
                    return arrNew;
                }else if (!arrGate1.count) {
                    if (moreNum) {
                        arrNew =[self getArrCompareWithMoreNum:arrGate2 oldArr:arrNew moreNum:moreNum];
                    }else{
                        [arrNew addObjectsFromArray:arrGate2];
                    }
                    return arrNew;
                }else{
                    if ([arrGate1.firstObject intValue]>=[arrGate2.firstObject intValue]&&[arrGate1.firstObject intValue]>=[moreNum intValue]) {
                        [arrNew addObject:arrGate1.firstObject];
                        [arrGate1 removeObjectAtIndex:0];
                    }else if ([arrGate2.firstObject intValue]>=[arrGate1.firstObject intValue]&&[arrGate2.firstObject intValue]>=[moreNum intValue]) {
                        [arrNew addObject:arrGate2.firstObject];
                        [arrGate2 removeObjectAtIndex:0];
                    }else if ([moreNum intValue]>=[arrGate1.firstObject intValue]&&[moreNum intValue]>=[arrGate2.firstObject intValue]) {
                        [arrNew addObject:moreNum];
                        moreNum = nil;
                    }
                }
            }
            return arrNew;
        }
    }else{
        NSNumber * moreNum =arrSender.lastObject;
        NSMutableArray * arrNew = [NSMutableArray arrayWithArray:arrSender];
        [arrNew removeObjectAtIndex:(arrSender.count-1)];
        return [self splitArrSender:arrNew theMoreNum:moreNum];
        
    }
    return 0;
//     [self compareWith:arrMade1 withArrSender2:arrMade2 complation:^(NSArray *results) {
//         
//     }];
}

-(NSMutableArray *)getArrCompareWithMoreNum:(NSArray *)sender oldArr:(NSMutableArray *)oldArr moreNum:(NSNumber *)moreNum{
    if ([moreNum intValue] >[sender.firstObject intValue]) {
        [oldArr addObject:moreNum];
        [oldArr addObjectsFromArray:sender];
        return oldArr;
    }else if ([moreNum intValue]<=[sender.lastObject intValue]) {
        [oldArr addObjectsFromArray:sender];
        [oldArr addObject:moreNum];
        return oldArr;
    }else{
        for (int i =0;i<sender.count;i++) {
            NSNumber * num = sender[i];
            if ([num intValue] >= [moreNum intValue]) {
                [oldArr addObject:num];
            }else{
                [oldArr addObject:moreNum];
                for (int j =i;i<sender.count;j++) {
                    NSNumber * othersNum = sender[j];
                    [oldArr addObject:othersNum];
                }
                return oldArr;
            }
        }
    }
    return oldArr;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

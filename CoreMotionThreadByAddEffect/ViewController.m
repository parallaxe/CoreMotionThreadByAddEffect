//
//  ViewController.m
//  CoreMotionThreadByAddEffect
//
//  Created by Hendrik von Prince on 07.06.17.
//  Copyright © 2017 Hendrik von Prince. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *fixedView;
@property (strong, nonatomic) IBOutlet UIView *floatingView;
@property (strong, nonatomic) IBOutlet UILabel *runloopCounterLabel;
@property(nonatomic) NSInteger runloopCounter;
@property(nonatomic) CFRunLoopObserverRef runloopObserver;

-(void)incrementCounter;
@end


void runloopCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    NSLog(@"runloop %lu", activity);
    ViewController *controller = (__bridge ViewController *)info;
    [controller incrementCounter];
    switch(activity) {
        case kCFRunLoopExit:
            NSLog(@"  kCFRunLoopExit");
            break;
        case kCFRunLoopEntry:
            NSLog(@"  kCFRunLoopEntry");
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"  kCFRunLoopAfterWaiting");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"  kCFRunLoopBeforeTimers");
            break;
        case kCFRunLoopAllActivities:
            NSLog(@"  kCFRunLoopAllActivities");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"  kCFRunLoopBeforeSources");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"  kCFRunLoopBeforeWaiting");
            break;
    }
}

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.floatingView.layer.borderColor = [UIColor blackColor].CGColor;
    self.floatingView.layer.borderWidth = 1;
    self.fixedView.layer.borderColor = [UIColor blackColor].CGColor;
    self.fixedView.layer.borderWidth = 1;

    CFRunLoopObserverContext context;
    context.version = 0;
    context.info = (__bridge void *)(self);
    context.release = NULL;
    context.retain = NULL;
    context.copyDescription = NULL;
    self.runloopObserver = CFRunLoopObserverCreate(NULL, kCFRunLoopAllActivities, true, 0, &runloopCallback, &context);

    CFRunLoopAddObserver(CFRunLoopGetMain(), self.runloopObserver, kCFRunLoopCommonModes);
}

-(void)incrementCounter {
    ++self.runloopCounter;
    self.runloopCounterLabel.text = [NSString stringWithFormat:@"%d", self.runloopCounter];
}

- (IBAction)activateCoreMotion:(id)sender {
    UIInterpolatingMotionEffect *effectX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath: @"center.x" type: UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    effectX.minimumRelativeValue = @(-30);
    effectX.maximumRelativeValue = @(30);
    
    UIInterpolatingMotionEffect *effectY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath: @"center.y" type: UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    effectY.minimumRelativeValue = @(-30);
    effectY.maximumRelativeValue = @(30);
    
    UIMotionEffectGroup *effectGroup = [[UIMotionEffectGroup alloc] init];
    effectGroup.motionEffects = @[effectX, effectY];
    [self.floatingView addMotionEffect:effectGroup];
}

@end

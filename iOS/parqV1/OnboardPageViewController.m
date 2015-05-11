//
//  OnboardPageViewController.m
//  parqV1
//
//  Created by Christopher Lee on 5/11/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import "OnboardPageViewController.h"

@interface OnboardPageViewController ()

@end

@implementation OnboardPageViewController
{
    NSArray *myViewControllers;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    
    UIViewController *p1 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"TutVC1"];
    UIViewController *p2 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"TutVC2"];
    UIViewController *p3 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"TutVC3"];
    UIViewController *p4 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"TutVC4"];
    
    myViewControllers = @[p1,p2,p3,p4];
    
    [self setViewControllers:@[p1]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO completion:nil];
    
    NSLog(@"loaded!");
}

-(UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    return myViewControllers[index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [myViewControllers indexOfObject:viewController];
    
    --currentIndex;
    currentIndex = currentIndex % (myViewControllers.count);
    return [myViewControllers objectAtIndex:currentIndex];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [myViewControllers indexOfObject:viewController];
    
    ++currentIndex;
    currentIndex = currentIndex % (myViewControllers.count);
    return [myViewControllers objectAtIndex:currentIndex];
}

-(NSInteger)presentationCountForPageViewController:
(UIPageViewController *)pageViewController
{
    return myViewControllers.count;
}

-(NSInteger)presentationIndexForPageViewController:
(UIPageViewController *)pageViewController
{
    return 0;
}

@end
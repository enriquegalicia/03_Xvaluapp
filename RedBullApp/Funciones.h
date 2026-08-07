//
//  Funciones.h
//  ClasesYClases
//
//  Created by Anis Galicia on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface Funciones : NSObject{
    NSArray* numf;
    int aa;
}
-(void)animloc:(UIImageView*)viewToFadeIn withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait destiny:(CGPoint)destino;
-(void)animmapa:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait destiny:(CGPoint)destino;
-(void)fadeInView:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait;
-(void)fadeOutView:(UIView*)viewToDissolve withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait;
-(void)animapossize:(UIImageView*)imagen fin:(CGPoint)fin tfin:(CGSize)tfin;
-(void)animapossizef:(UIImageView*)imagen fin:(CGPoint)fin tfin:(CGSize)tfin;
-(void)fadeIn:(UIImageView*)viewToFadeIn withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait;
-(void)animalocal1:(UIImageView*)imagen punto1:(CGPoint)punto1 punto2:(CGPoint)punto2;
@end

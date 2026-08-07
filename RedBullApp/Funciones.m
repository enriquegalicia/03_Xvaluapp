//
//  Funciones.m
//  ClasesYClases
//
//  Created by Anis Galicia on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Funciones.h"

@implementation Funciones
-(id)valoresiniciales{
    NSArray *numeros=[NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",nil];
    numf=[self shuffled:numeros];
    aa=0;
    return self;
}
-(int)proximolugar{
    int bb=[[numf objectAtIndex:aa] intValue];
    if (aa>4) {
        aa=0;
    }
    else{
        aa++;
    }
    return bb;
}

-(void)animalocal1:(UIImageView*)imagen punto1:(CGPoint)punto1 punto2:(CGPoint)punto2 {
    CABasicAnimation *muevetemami = [CABasicAnimation animationWithKeyPath:@"position"];
        [muevetemami setFromValue:[NSValue valueWithCGPoint:punto1]];
        [muevetemami setToValue:[NSValue valueWithCGPoint:punto2]];
        muevetemami.delegate = self;
        muevetemami.repeatCount = 1;
        muevetemami.autoreverses = NO;
        muevetemami.duration = 1.0;
        [imagen.layer addAnimation:muevetemami forKey:@"horizontalBallAnimation"];
   
}

-(void)fadeIn:(UIImageView*)viewToFadeIn withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait
{
    [UIView beginAnimations: @"Fade In" context:nil];
    [UIView setAnimationDelay:wait];
    [UIView setAnimationDuration:duration];
    viewToFadeIn.alpha = 1;
    [UIView commitAnimations];
    
}

-(void)fadeinout:(UIImageView*)viewToFadeIn withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait{
    CABasicAnimation *desaparece;
    desaparece=[CABasicAnimation animationWithKeyPath:@"opacity"];
    desaparece.duration=duration;
    desaparece.repeatCount=0;
    desaparece.autoreverses=YES;
    desaparece.beginTime=wait;
    desaparece.fromValue=[NSNumber numberWithFloat:0.0];
    desaparece.toValue=[NSNumber numberWithFloat:1.0];
    [viewToFadeIn.layer addAnimation:desaparece forKey:@"animateOpacity"];
}


-(void)fadeOut:(UIImageView*)viewToDissolve withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait
{
	[UIView beginAnimations: @"Fade Out" context:nil];
	[UIView setAnimationDelay:wait];
	[UIView setAnimationDuration:duration];
	viewToDissolve.alpha = 0.0;
	[UIView commitAnimations];
}
-(void)changeimage:(UIImageView*)imagen withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait imagencambio:(NSString*)imagcam{
    [UIView beginAnimations: @"Fade Out" context:nil];
	[UIView setAnimationDelay:wait];
	[UIView setAnimationDuration:duration];
	imagen.image = [UIImage imageNamed:imagcam];
	[UIView commitAnimations];
}

-(void)barmancambiante:(UIImageView*)escenarioc imagen1:(NSString*)imagen1 imagen2:(NSString*)imagen2 duracion:(float)duracion{
    escenarioc.animationImages =[NSArray arrayWithObjects:
    [UIImage imageNamed:imagen1],
    [UIImage imageNamed:imagen2],nil];
    escenarioc.animationDuration=duracion;
    escenarioc.animationRepeatCount=0;
    [escenarioc startAnimating];
}


-(void)fadeInView:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait
{
    [UIView beginAnimations: nil context:nil];
    [UIView setAnimationDelay:wait];
    [UIView setAnimationDuration:duration];
    viewToFadeIn.alpha = 1;
    [UIView commitAnimations];
    
}

-(void)fadeOutView:(UIView*)viewToDissolve withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait
{
	[UIView beginAnimations: nil context:nil];
	[UIView setAnimationDelay:wait];
	[UIView setAnimationDuration:duration];
    [UIView setAnimationDelegate:self];
	viewToDissolve.alpha = 0.0;
	[UIView commitAnimations];
}


-(void)animloc:(UIImageView*)viewToFadeIn withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait destiny:(CGPoint)destino;
{
    [UIView beginAnimations: @"Fade In" context:nil];
    [UIView setAnimationDelay:wait];
    [UIView setAnimationDuration:duration];
    viewToFadeIn.center=destino;
    [UIView commitAnimations];
    
}
-(void)animubic:(UIImageView*)viewToFadeIn withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait destiny:(CGPoint)destino;
{
    [UIView beginAnimations: @"Fade In" context:nil];
    [UIView setAnimationDelay:wait];
    [UIView setAnimationDuration:duration];
    viewToFadeIn.center=destino;
    viewToFadeIn.alpha = 1;
    [UIView commitAnimations];
    
}
-(void)animapossize:(UIImageView*)imagen fin:(CGPoint)fin tfin:(CGSize)tfin{
    
    
    [UIView beginAnimations : @"Display notif" context:nil];
    [UIView setAnimationDuration:2];
    imagen.frame=CGRectMake(fin.x-tfin.width/2, fin.y-tfin.height/2, tfin.width, tfin.height);
    
    [UIView commitAnimations];
}
-(void)animapossizef:(UIImageView*)imagen fin:(CGPoint)fin tfin:(CGSize)tfin{
    
    
    [UIView beginAnimations : @"Display notif" context:nil];
    [UIView setAnimationDuration:1];
    imagen.frame=CGRectMake(fin.x-tfin.width/2, fin.y-tfin.height/2, tfin.width, tfin.height);
    
    [UIView commitAnimations];
}

-(void)animmapa:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait destiny:(CGPoint)destino;
{
    [UIView beginAnimations: @"Fade In" context:nil];
    [UIView setAnimationDelay:wait];
    [UIView setAnimationDuration:duration];
    viewToFadeIn.center=destino;
    viewToFadeIn.alpha = 1;
    [UIView commitAnimations];
    
}

-(void)animalocal:(UIImageView*)imagen punto1:(CGPoint)punto1 punto2:(CGPoint)punto2 {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        CABasicAnimation *muevetemami = [CABasicAnimation animationWithKeyPath:@"position"];
        [muevetemami setFromValue:[NSValue valueWithCGPoint:CGPointMake(punto1.x+6.17, punto1.y+53.12)]];
        [muevetemami setToValue:[NSValue valueWithCGPoint:CGPointMake(punto2.x+6.17, punto2.y+53.12)]];
        muevetemami.delegate = self;
        muevetemami.repeatCount = 8;
        muevetemami.autoreverses = YES;
        muevetemami.duration = 1.0;    
        [imagen.layer addAnimation:muevetemami forKey:@"horizontalBallAnimation"];    }
    else {
        CABasicAnimation *muevetemami = [CABasicAnimation animationWithKeyPath:@"position"];
        [muevetemami setFromValue:[NSValue valueWithCGPoint:CGPointMake(punto1.x+10.14, punto1.y+93.20)]];
        [muevetemami setToValue:[NSValue valueWithCGPoint:CGPointMake(punto2.x+10.14, punto2.y+93.20)]];
        muevetemami.delegate = self;
        muevetemami.repeatCount = 8;
        muevetemami.autoreverses = YES;
        muevetemami.duration = 1.0;    
        [imagen.layer addAnimation:muevetemami forKey:@"horizontalBallAnimation"];
    }
}

-(void)animaluz:(UIImageView*)imagen punto1:(CGPoint)punto1 punto2:(CGPoint)punto2 {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        CABasicAnimation *muevetemami = [CABasicAnimation animationWithKeyPath:@"position"];
        [muevetemami setFromValue:[NSValue valueWithCGPoint:CGPointMake(punto1.x, punto1.y)]];
        [muevetemami setToValue:[NSValue valueWithCGPoint:CGPointMake(punto2.x, punto2.y-50)]];
        muevetemami.delegate = self;
        muevetemami.repeatCount = 30;
        muevetemami.autoreverses = YES;
        muevetemami.duration = 4;    
        [imagen.layer addAnimation:muevetemami forKey:@"horizontalBallAnimation"];    }
    else {
        CABasicAnimation *muevetemami = [CABasicAnimation animationWithKeyPath:@"position"];
        [muevetemami setFromValue:[NSValue valueWithCGPoint:CGPointMake(punto1.x, punto1.y)]];
        [muevetemami setToValue:[NSValue valueWithCGPoint:CGPointMake(punto2.x, punto2.y+75)]];
        muevetemami.delegate = self;
        muevetemami.repeatCount = 30;
        muevetemami.autoreverses = YES;
        muevetemami.duration = 4;    
        [imagen.layer addAnimation:muevetemami forKey:@"horizontalBallAnimation"];
    }
}

- (NSArray *) shuffled:(NSArray*)array
{
	// create temporary autoreleased mutable array
    
    
	NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[array count]];
    
	for (id anObject in array)
	{       
		NSUInteger randomPos = arc4random()%([tmpArray count]+1);
		[tmpArray insertObject:anObject atIndex:randomPos];
	}
    
	return [NSArray arrayWithArray:tmpArray];  // non-mutable autoreleased copy
}

-(void)animaetiqueta:(UILabel *)imagen punto1:(CGPoint)punto1 punto2:(CGPoint)punto2 {
    CABasicAnimation *muevetemami = [CABasicAnimation animationWithKeyPath:@"position"];
    [muevetemami setFromValue:[NSValue valueWithCGPoint:CGPointMake(punto1.x, punto1.y)]];
    [muevetemami setToValue:[NSValue valueWithCGPoint:CGPointMake(punto2.x, punto2.y)]];
    muevetemami.delegate = self;
    muevetemami.repeatCount = 8;
    muevetemami.autoreverses = YES;
    muevetemami.duration = 4.9;
    [imagen.layer addAnimation:muevetemami forKey:@"horizontalBallAnimation"];
}






-(void)fadeInetiq:(UILabel*)viewToFadeIn withDuration:(NSTimeInterval)duration         andWait:(NSTimeInterval)wait
{
    [UIView beginAnimations: @"Fade In" context:nil];
    [UIView setAnimationDelay:wait];
    [UIView setAnimationDuration:duration];
    viewToFadeIn.alpha = 1;
    [UIView commitAnimations];
    
}
-(void)fadeOutetiq:(UILabel*)viewToDissolve withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait
{
	[UIView beginAnimations: @"Fade Out" context:nil];
	[UIView setAnimationDelay:wait];
	[UIView setAnimationDuration:duration];
	viewToDissolve.alpha = 0.0;
	[UIView commitAnimations];
}
-(void)rotateder:(UIImageView*)imagen{
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    [theAnimation setFromValue:[NSNumber numberWithFloat:0]];
    [theAnimation setToValue:[NSNumber numberWithFloat:((360*M_PI)/180)]];
    [theAnimation setDuration:2];
    theAnimation.repeatCount= 1000;
    
    [imagen.layer addAnimation:theAnimation forKey:@"transform.rotation"];
    
}

-(void)rotateizq:(UIImageView*)imagen{
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    [theAnimation setFromValue:[NSNumber numberWithFloat:0]];
    [theAnimation setToValue:[NSNumber numberWithFloat:((-360*M_PI)/180)]];
    [theAnimation setDuration:2];
    theAnimation.repeatCount= 1000;
    
    [imagen.layer addAnimation:theAnimation forKey:@"transform.rotation"];
    
}

-(void)rotatederrange:(UIImageView*)imagen{
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    [theAnimation setFromValue:[NSNumber numberWithFloat:0]];
    [theAnimation setToValue:[NSNumber numberWithFloat:((70*M_PI)/150)]];
    [theAnimation setDuration:0.3];
    theAnimation.repeatCount= 2;
    theAnimation.autoreverses=YES;
    
    [imagen.layer addAnimation:theAnimation forKey:@"transform.rotation"];
    
}

-(void)rotateizqrange:(UIImageView*)imagen{
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    [theAnimation setFromValue:[NSNumber numberWithFloat:0]];
    [theAnimation setToValue:[NSNumber numberWithFloat:((-70*M_PI)/180)]];
    [theAnimation setDuration:0.3];
    theAnimation.repeatCount= 2;
    theAnimation.autoreverses=YES;
    
    [imagen.layer addAnimation:theAnimation forKey:@"transform.rotation"];
    
}



-(void)rotatehand:(UIImageView*)imagen{
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];    
    [theAnimation setFromValue:[NSNumber numberWithFloat:0]];
    [theAnimation setToValue:[NSNumber numberWithFloat:((71*M_PI)/180)]];

    [theAnimation setDuration:3];
   theAnimation.autoreverses = YES;
    theAnimation.repeatCount= 50;  
    
    [imagen.layer addAnimation:theAnimation forKey:@"transform.rotation"];
    
}




@end
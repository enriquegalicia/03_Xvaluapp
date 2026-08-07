//
//  CalifIndividual.m
//  Xvaluapp
//
//  Created by Enrique Galicia on 02/04/14.
//  Copyright (c) 2014 Enrique Galicia. All rights reserved.
//

#import "CalifIndividual.h"

@implementation CalifIndividual
@synthesize idd,nombre,califica;
@synthesize Letra;

- (void)awakeFromNib
{
    idd.textColor=Letra;
    nombre.textColor=Letra;
    califica.textColor=Letra;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

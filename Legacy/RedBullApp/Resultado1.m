//
//  Resultados Finales.m
//  Xvaluapp
//
//  Created by Enrique Galicia on 02/04/14.
//  Copyright (c) 2014 Enrique Galicia. All rights reserved.
//

#import "Resultado1.h"

@implementation Resultado1
@synthesize idd=_idd;
@synthesize nombre=_nombre;
@synthesize calificacion=_calificacion;
@synthesize Letra=_Letra;
@synthesize SBandera=_SBandera;
@synthesize Bandera=_Bandera;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.backgroundColor=[UIColor clearColor];
        _idd.textColor=[UIColor blackColor];
        _nombre.textColor=[UIColor blackColor];
        _calificacion.textColor=[UIColor blackColor];
        contentview.backgroundColor=[UIColor clearColor];
        _Bandera.image=[UIImage imageNamed:_SBandera];

    }
    return self;
}
+ (NSString *)reuseIdentifier {
    return @"CellIdentifier";
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

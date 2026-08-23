//
//  Resultados Finales.m
//  Xvaluapp
//
//  Created by Enrique Galicia on 02/04/14.
//  Copyright (c) 2014 Enrique Galicia. All rights reserved.
//

#import "Resultado.h"

@implementation Resultado
@synthesize idd=_idd;
@synthesize nombre=_nombre;
@synthesize calificacion=_calificacion;
@synthesize Letra=_Letra;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.backgroundColor=[UIColor clearColor];
        _idd.textColor=_Letra;
        _nombre.textColor=_Letra;
        _calificacion.textColor=_Letra;
        contentview.backgroundColor=[UIColor clearColor];

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

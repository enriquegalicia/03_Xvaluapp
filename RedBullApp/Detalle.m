//
//  Detalle.m
//  Xvaluapp
//
//  Created by Enrique Galicia on 03/04/14.
//  Copyright (c) 2014 Enrique Galicia. All rights reserved.
//

#import "Detalle.h"

@implementation Detalle
@synthesize idd,Calificacion,Nombre,Rubros;
@synthesize delegadodetalle=_delegadodetalle;
@synthesize colorcalificacion;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setselected:(NSString*)seleccion fun:(int)fun{
    if (fun==7) {
        //NSLog(@"%@%@",Nombre.text,seleccion);
        [self.delegadodetalle getgrade:Nombre.text juez:seleccion];
    }
}

-(void)cargartablas:(NSDictionary*)dic campos:(NSArray*)campos{
    Calificacion.textColor=colorcalificacion;
    if (tabla.view) {
        [tabla.view removeFromSuperview];
    }
    
    tabla=[[BasicTable alloc]init];
    tabla.view.frame =IvTabla.frame;
    [tabla setTamtit:20];
    tabla.funcion=7;
    tabla.delegadobase=self;
    [tabla setTamsubtit:15];
    [tabla setTamtit:20];
    [tabla setCelheight:45];
    [self addSubview:tabla.view];
    tabla.view.backgroundColor=[UIColor clearColor];
    [tabla cargartablas:[self alltit:dic campos:campos]];
    
}
-(NSDictionary*)alltit:(NSDictionary*)dic campos:(NSArray*)campos{
    //NSLog(@"02 Y LA BASE RUGE ASI %@_%@",dic,campos);
    NSMutableDictionary *valores=[[NSMutableDictionary alloc]init];
    NSMutableArray *Titulos=[[NSMutableArray alloc]init];
    NSMutableArray *Subtitulos=[[NSMutableArray alloc]init];
    NSArray *campostot=[dic objectForKey:[campos objectAtIndex:0]];
    if ([campostot count]>0) {
        for (int a=0; a<=[campostot count]-1; a++) {
            NSString *titulos=@"";
            NSString *subtitulos=@"";
            
            titulos=[NSString stringWithFormat:@"%@_%@_%@",[[dic objectForKey:@"Id"] objectAtIndex:a],[[dic objectForKey:@"Juez"] objectAtIndex:a],[[dic objectForKey:@"Calificacion"] objectAtIndex:a]];
            subtitulos=[NSString stringWithFormat:@"Rank at %@",[self.delegadodetalle rankingLocal:[[dic objectForKey:@"Participante"] objectAtIndex:a] juez:[[dic objectForKey:@"Juez"] objectAtIndex:a]]];
            
            [Titulos addObject:titulos];
            [Subtitulos addObject:subtitulos];
        }
    }
    else{
        [Titulos addObject:@"No Info"];
        [Subtitulos addObject:@"No Info"];
    }
    NSArray *titulos2=[NSArray arrayWithArray:Titulos];
    NSArray *subtitulos2=[NSArray arrayWithArray:Subtitulos];
    [valores setObject:titulos2 forKey:@"Titulo"];
    [valores setObject:subtitulos2 forKey:@"Subtitulo"];
    NSDictionary *info=[NSDictionary dictionaryWithDictionary:valores];
    return info;
}



@end

//
//  Detalle.h
//  Xvaluapp
//
//  Created by Enrique Galicia on 03/04/14.
//  Copyright (c) 2014 Enrique Galicia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicTable.h"
#import "Subtitulados.h"
@protocol DetalleDelegado;

@interface Detalle : UIView<basictable>{
    id<DetalleDelegado>delegadodetalle;
    IBOutlet UILabel *idd;
    IBOutlet UILabel *Nombre;
    NSDictionary *Rubros;
    IBOutlet UILabel *Calificacion;
    IBOutlet UIImageView *IvTabla;
    UIColor *colorcalificacion;
    BasicTable *tabla;

    
    
}
@property(nonatomic,retain)id<DetalleDelegado>delegadodetalle;
@property(nonatomic,retain)IBOutlet UILabel *idd;
@property(nonatomic,retain)IBOutlet UILabel *Nombre;
@property(nonatomic,retain) NSDictionary *Rubros;
@property(nonatomic,retain)IBOutlet UILabel *Calificacion;
@property(nonatomic,retain)UIColor *colorcalificacion;
-(void)cargartablas:(NSDictionary*)dic campos:(NSArray*)campos;

@end
@protocol DetalleDelegado
-(NSString*)rankingLocal:(NSString*)participante juez:(NSString*)juez;
-(void)getgrade:(NSString*)participante juez:(NSString*)juez;

@end
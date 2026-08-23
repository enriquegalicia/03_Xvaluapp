//
//  BasicTable.h
//  Magma
//
//  Created by Enrique Galicia on 19/08/13.
//  Copyright (c) 2013 Enrique Galicia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Resultado.h"

@protocol restable;

@interface Resultados : UITableViewController{
    
    id<restable>delegadores;
    
    NSArray *idd;
    NSArray *idd2;
    NSArray *nombre;
    NSArray *nombre2;
    NSArray *calificacion;
    NSArray *calificacion2;
    NSArray *rubros;
    NSArray *rubros2;
    NSArray *colores;
    NSArray *colores2;
    
    NSUInteger cantidaddeelementos;
    NSMutableDictionary *valoresphp;
    int tamtit;
    int tamsubtit;
    int funcion;
    int celda;
    IBOutlet Resultado *resul;
}

@property(nonatomic,assign)int tamtit;
@property(nonatomic,assign)int funcion;
@property(nonatomic,assign)int tamsubtit;
@property(nonatomic,assign)int celda;
@property(nonatomic,retain)id<restable>delegadores;

@property(nonatomic,retain)NSDictionary *informacion;
@property (assign, nonatomic)IBOutlet Resultado *resul;

-(void)cargartablas:(NSDictionary*)informacion;

@end

@protocol restable

-(void)setselected:(NSString*)seleccion fun:(int)fun;

@end




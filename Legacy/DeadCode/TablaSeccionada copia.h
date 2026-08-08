//
//  TablaSeccionada.h
//  Xvaluapp
//
//  Created by Enrique Galicia on 02/04/14.
//  Copyright (c) 2014 Enrique Galicia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol secctable;

@interface TablaSeccionada : UITableViewController{
    
    id<secctable>delegadotase;
    
    NSArray *titulo;
    NSArray *titulo2;
    NSArray *subtitulo;
    NSArray *subtitulo2;
    NSUInteger cantidaddeelementos;
    NSMutableDictionary *valoresphp;
    int tamtit;
    int tamsubtit;
    int funcion;
    int firsttitle;
    int secciones;
    int divisionesafectadas;
    int remanda;
    int cierre;
    int total;
    int sfa;
    
}

@property(nonatomic,assign)int tamtit;
@property(nonatomic,assign)int funcion;
@property(nonatomic,assign)int tamsubtit;
@property(nonatomic,assign)int divisiones;
@property(nonatomic,retain)NSString* cabecera;
@property(nonatomic,retain)id<secctable>delegadotase;

@property(nonatomic,retain)NSDictionary *informacion;

-(void)cargartablas:(NSDictionary*)informacion;

@end

@protocol secctable

-(void)setselected:(NSString*)seleccion fun:(int)fun;

@end


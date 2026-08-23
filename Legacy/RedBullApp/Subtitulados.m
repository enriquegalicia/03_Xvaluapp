//
//  Subtitulados.m
//  RandyTheStudent
//
//  Created by Enrique Galicia on 10/02/14.
//  Copyright (c) 2014 Enrique Galicia. All rights reserved.
//

#import "Subtitulados.h"

@interface Subtitulados ()

@end

@implementation Subtitulados

//Subtitulado para Tablas
-(NSArray*)Banderas{
    NSArray *banderas=[NSArray arrayWithObjects:@"NL.png",@"MEX.png",@"AUS.png",@"USA.png",@"UK.png",@"UK.png",@"MEX.png",@"FRA.png",@"USA.png",@"FRA.png",@"CR.png",@"UK.png",@"COL.png",@"USA.png",@"USA.png",@"CAN.png",@"CAN.png",@"BRA.png",@"USA.png",@"USA.png",@"AUS.png",@"USA.png",@"UK.png",@"USA.png",@"USA.png",@"MEX.png",@"VEN.png", nil];
    return banderas;
}
-(NSArray*)Riders{
    NSArray *riders=[NSArray arrayWithObjects:@"Daniel Wedemeijer",@"Luis Medina",@"Ryan Guettler",@"Tyler Fernengel",@"Kriss Kyle",@"Ben Wallace",@"David Peraza",@"Kevin Kalkoff",@"Anthony Napolitan",@"Maxime Charveron",@"Kenneth Tencio",@"Ben Hennon",@"Santiago Muñoz",@"Ryan Nyquist",@"Rob Darden",@"Drew Bezanson",@"Mike Varga",@"Leandro Moreira",@"Daniel Sandoval",@"AJ Anaya",@"Corey Bohan",@"Dennis Enarson",@"Bas Keep",@"Pat Casey",@"Gary Young",@"Kevin Peraza",@"Daniel Dhers", nil];
    return riders;
}
-(NSArray*)Judges{
    NSArray *judges=[NSArray arrayWithObjects:@"Tim (Fuzzy) Hall",@"Keith Mulligan",@"Paul De Jong",@"Tobias Wicke",@"Patricio Rubio",nil];
    return judges;
}
-(NSArray*)Rubros{
    NSArray *judges=[NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",nil];
    return judges;
}


-(NSDictionary*)alltit:(NSDictionary*)dic campos:(NSArray*)campos{
    //NSLog(@"Y LA BASE RUGE ASI %@",dic);
    NSMutableDictionary *valores=[[NSMutableDictionary alloc]init];
    NSMutableArray *Titulos=[[NSMutableArray alloc]init];
    NSArray *Primer=[dic objectForKey:[campos objectAtIndex:0]];
    if ([campos count]>0) {
        for (int a=0; a<=[Primer count]-1; a++) {
            NSString *Titulo=@"";
            for (int b=0; b<=[campos count]-1; a++) {
                Titulo=[NSString stringWithFormat:@"%@ %@",Titulo,[dic objectForKey:[campos objectAtIndex:b]]];
            }
            [Titulos addObject:Titulo];
        }
    }
    else{
        [Titulos addObject:@"No Registry"];
    }
    
    NSArray *titulos2=[NSArray arrayWithArray:Titulos];
    [valores setObject:titulos2 forKey:@"Titulo"];
    NSDictionary *info=[NSDictionary dictionaryWithDictionary:valores];
    return info;
}

-(NSDictionary*)titc1c2:(NSDictionary*)dic c1:(NSString*)c1 c2:(NSString*)c2{
    NSMutableDictionary *valores=[[NSMutableDictionary alloc]init];
    NSMutableArray *Titulos=[[NSMutableArray alloc]init];
    NSMutableArray *Subtitulos=[[NSMutableArray alloc]init];
    NSArray *C1=[dic objectForKey:c1];
    NSArray *C2 =[dic objectForKey:c2];

    NSUInteger conteo=[C1 count];
    if (conteo>=1) {
        
        for (int a=0; a<=conteo-1; a++) {
            
            [Titulos addObject:[NSString stringWithFormat:@"%@_%@",[C1 objectAtIndex:a],[C2 objectAtIndex:a]]];
            [Subtitulos addObject:[NSString stringWithFormat:@""]];
        }
        
    }
    else{
        [Titulos addObject:@"No Registry"];
        [Subtitulos addObject:@"Save Information For the Match"];
    }
    
    NSArray *titulos2=[NSArray arrayWithArray:Titulos];
    NSArray *subtitulos2=[NSArray arrayWithArray:Subtitulos];
    [valores setObject:titulos2 forKey:@"Titulo"];
    [valores setObject:subtitulos2 forKey:@"Subtitulo"];
    NSDictionary *info=[NSDictionary dictionaryWithDictionary:valores];
    return info;
    
}
-(NSDictionary*)titidc1subc2c3:(NSDictionary*)dic c1:(NSString*)c1 c2:(NSString*)c2 c3:(NSString*)c3{
    NSMutableDictionary *valores=[[NSMutableDictionary alloc]init];
    NSMutableArray *Titulos=[[NSMutableArray alloc]init];
    NSMutableArray *Subtitulos=[[NSMutableArray alloc]init];
    NSArray *ID=[dic objectForKey:@"Id"];
    NSArray *C1=[dic objectForKey:c1];
    NSArray *C2 =[dic objectForKey:c2];
    NSArray *C3=[dic objectForKey:c3];
    NSUInteger conteo=[ID count];
    if (conteo>=1) {
        
        for (int a=0; a<=conteo-1; a++) {
            
            [Titulos addObject:[NSString stringWithFormat:@"%@_%@",[ID objectAtIndex:a],[C1 objectAtIndex:a]]];
            [Subtitulos addObject:[NSString stringWithFormat:@"%@_%@",[C2 objectAtIndex:a],[C3 objectAtIndex:a]]];
        }
        
    }
    else{
        [Titulos addObject:@"No Registry"];
        [Subtitulos addObject:@"Save Information For the Match"];
    }
    
    NSArray *titulos2=[NSArray arrayWithArray:Titulos];
    NSArray *subtitulos2=[NSArray arrayWithArray:Subtitulos];
    [valores setObject:titulos2 forKey:@"Titulo"];
    [valores setObject:subtitulos2 forKey:@"Subtitulo"];
    NSDictionary *info=[NSDictionary dictionaryWithDictionary:valores];
    return info;
    
}
-(NSDictionary*)titc1subc2c3:(NSDictionary*)dic c1:(NSString*)c1 c2:(NSString*)c2 c3:(NSString*)c3{
    NSMutableDictionary *valores=[[NSMutableDictionary alloc]init];
    NSMutableArray *Titulos=[[NSMutableArray alloc]init];
    NSMutableArray *Subtitulos=[[NSMutableArray alloc]init];
    NSArray *C1=[dic objectForKey:c1];
    NSArray *C2 =[dic objectForKey:c2];
    NSArray *C3=[dic objectForKey:c3];
    NSUInteger conteo=[C1 count];
    if (conteo>=1) {
        
        for (int a=0; a<=conteo-1; a++) {
            
            [Titulos addObject:[NSString stringWithFormat:@"%i_%@",a+1,[C1 objectAtIndex:a]]];
            [Subtitulos addObject:[NSString stringWithFormat:@"%@_%@",[C2 objectAtIndex:a],[C3 objectAtIndex:a]]];
        }
        
    }
    else{
        [Titulos addObject:@"No Registry"];
        [Subtitulos addObject:@"Save Information For the Match"];
    }
    
    NSArray *titulos2=[NSArray arrayWithArray:Titulos];
    NSArray *subtitulos2=[NSArray arrayWithArray:Subtitulos];
    [valores setObject:titulos2 forKey:@"Titulo"];
    [valores setObject:subtitulos2 forKey:@"Subtitulo"];
    NSDictionary *info=[NSDictionary dictionaryWithDictionary:valores];
    return info;
    
}

-(NSDictionary*)titidc1c2subc3c4:(NSDictionary*)dic c1:(NSString*)c1 c2:(NSString*)c2 c3:(NSString*)c3 c4:(NSString*)c4{
    NSMutableDictionary *valores=[[NSMutableDictionary alloc]init];
    NSMutableArray *Titulos=[[NSMutableArray alloc]init];
    NSMutableArray *Subtitulos=[[NSMutableArray alloc]init];
    NSArray *ID=[dic objectForKey:@"Id"];
    NSArray *C1=[dic objectForKey:c1];
    NSArray *C2 =[dic objectForKey:c2];
    NSArray *C3=[dic objectForKey:c3];
    NSArray *C4=[dic objectForKey:c4];
    NSUInteger conteo=[ID count];
    if (conteo>=1) {
        
        for (int a=0; a<=conteo-1; a++) {
            
            [Titulos addObject:[NSString stringWithFormat:@"%@_%@ %@",[ID objectAtIndex:a],[C1 objectAtIndex:a],[C2 objectAtIndex:a]]];
            [Subtitulos addObject:[NSString stringWithFormat:@"%@_%@",[C3 objectAtIndex:a],[C4 objectAtIndex:a]]];
        }
        
    }
    else{
        [Titulos addObject:@"No Registry"];
        [Subtitulos addObject:@"Save Information For the Match"];
    }
    
    NSArray *titulos2=[NSArray arrayWithArray:Titulos];
    NSArray *subtitulos2=[NSArray arrayWithArray:Subtitulos];
    [valores setObject:titulos2 forKey:@"Titulo"];
    [valores setObject:subtitulos2 forKey:@"Subtitulo"];
    NSDictionary *info=[NSDictionary dictionaryWithDictionary:valores];
    return info;
    
}
-(NSDictionary*)titidc1c2subc3c4c5:(NSDictionary*)dic c1:(NSString*)c1 c2:(NSString*)c2 c3:(NSString*)c3 c4:(NSString*)c4 c5:(NSString*)c5{
    NSMutableDictionary *valores=[[NSMutableDictionary alloc]init];
    NSMutableArray *Titulos=[[NSMutableArray alloc]init];
    NSMutableArray *Subtitulos=[[NSMutableArray alloc]init];
    NSArray *ID=[dic objectForKey:@"Id"];
    NSArray *C1=[dic objectForKey:c1];
    NSArray *C2 =[dic objectForKey:c2];
    NSArray *C3=[dic objectForKey:c3];
    NSArray *C4=[dic objectForKey:c4];
    NSArray *C5=[dic objectForKey:c5];
    NSUInteger conteo=[ID count];
    if (conteo>=1) {
        
        for (int a=0; a<=conteo-1; a++) {
            
            [Titulos addObject:[NSString stringWithFormat:@"%@_%@ %@",[ID objectAtIndex:a],[C1 objectAtIndex:a],[C2 objectAtIndex:a]]];
            [Subtitulos addObject:[NSString stringWithFormat:@"%@_%@_%@",[C3 objectAtIndex:a],[C4 objectAtIndex:a],[C5 objectAtIndex:a]]];
        }
        
    }
    else{
        [Titulos addObject:@"No Registry"];
        [Subtitulos addObject:@"Save Information For the Match"];
    }
    
    NSArray *titulos2=[NSArray arrayWithArray:Titulos];
    NSArray *subtitulos2=[NSArray arrayWithArray:Subtitulos];
    [valores setObject:titulos2 forKey:@"Titulo"];
    [valores setObject:subtitulos2 forKey:@"Subtitulo"];
    NSDictionary *info=[NSDictionary dictionaryWithDictionary:valores];
    return info;
    
}
-(NSDictionary*)titc1c2subc3c4:(NSDictionary*)dic c1:(NSString*)c1 c2:(NSString*)c2 c3:(NSString*)c3 c4:(NSString*)c4{
    NSMutableDictionary *valores=[[NSMutableDictionary alloc]init];
    NSMutableArray *Titulos=[[NSMutableArray alloc]init];
    NSMutableArray *Subtitulos=[[NSMutableArray alloc]init];
    NSArray *C1=[dic objectForKey:c1];
    NSArray *C2 =[dic objectForKey:c2];
    NSArray *C3=[dic objectForKey:c3];
    NSArray *C4=[dic objectForKey:c4];
    NSUInteger conteo=[C1 count];
    if (conteo>=1) {
        
        for (int a=0; a<=conteo-1; a++) {
            
            [Titulos addObject:[NSString stringWithFormat:@"%@_%@",[C1 objectAtIndex:a],[C2 objectAtIndex:a]]];
            [Subtitulos addObject:[NSString stringWithFormat:@"%@_%@",[C3 objectAtIndex:a],[C4 objectAtIndex:a]]];
        }
        
    }
    else{
        [Titulos addObject:@"No Registry"];
        [Subtitulos addObject:@"Save Information For the Match"];
    }
    
    NSArray *titulos2=[NSArray arrayWithArray:Titulos];
    NSArray *subtitulos2=[NSArray arrayWithArray:Subtitulos];
    [valores setObject:titulos2 forKey:@"Titulo"];
    [valores setObject:subtitulos2 forKey:@"Subtitulo"];
    NSDictionary *info=[NSDictionary dictionaryWithDictionary:valores];
    return info;
    
}






//Subtitulado para ComboBox

-(NSMutableArray*)titcbc1c2:(NSDictionary*)titsub c1:(NSString*)c1 c2:(NSString*)c2{
    NSMutableArray *Titulos=[[NSMutableArray alloc]init];
    NSArray *ID=[titsub objectForKey:c1];
    NSArray *Nombre=[titsub objectForKey:c2];
    NSUInteger conteo=[Nombre count];
    if (conteo>=1) {
        
        for (int a=0; a<=conteo-1; a++) {
            [Titulos addObject:[NSString stringWithFormat:@"%@_%@",[ID objectAtIndex:a],[Nombre objectAtIndex:a]]];
            
        }
        
    }
    else{
        [Titulos addObject:@"Not Files Available"];
    }
    
    return Titulos;
    
}
    
-(NSMutableArray*)titidc1:(NSDictionary*)titsub c1:(NSString*)c1{
    NSMutableArray *Titulos=[[NSMutableArray alloc]init];
    NSArray *ID=[titsub objectForKey:@"Id"];
    NSArray *Nombre=[titsub objectForKey:c1];
    NSUInteger conteo=[Nombre count];
    if (conteo>=1) {
        
        for (int a=0; a<=conteo-1; a++) {
            [Titulos addObject:[NSString stringWithFormat:@"%@_%@",[ID objectAtIndex:a],[Nombre objectAtIndex:a]]];
            
        }
        
    }
    else{
        [Titulos addObject:@"Not Files Available"];
    }
    
    return Titulos;
    
}
-(NSMutableArray*)MAtitc1:(NSDictionary*)titsub c1:(NSString*)c1{
    NSMutableArray *Titulos=[[NSMutableArray alloc]init];
    NSArray *Nombre=[titsub objectForKey:c1];
    NSUInteger conteo=[Nombre count];
    if (conteo>=1) {
        
        for (int a=0; a<=conteo-1; a++) {
            [Titulos addObject:[NSString stringWithFormat:@"%@",[Nombre objectAtIndex:a]]];
            
        }
        
    }
    else{
        [Titulos addObject:@"Not Files Available"];
    }
    
    return Titulos;
    
}
-(NSString*)tit1idc1:(NSDictionary*)titsub c1:(NSString*)c1{
    NSString *Titulos=@"";
    NSArray *ID=[titsub objectForKey:@"Id"];
    NSArray *Nombre=[titsub objectForKey:c1];
    NSUInteger conteo=[Nombre count];
    if (conteo>=1) {
        
        for (int a=0; a<=conteo-1; a++) {
            Titulos=[NSString stringWithFormat:@"%@_%@",[ID objectAtIndex:a],[Nombre objectAtIndex:a]];
            
        }
        
    }
    else{
        Titulos=@"No Files";
    }
    
    return Titulos;
    
}
-(NSString*)titc1:(NSDictionary*)titsub c1:(NSString*)c1{
    NSString *Titulos=@"";
    NSArray *Nombre=[titsub objectForKey:c1];
    NSUInteger conteo=[Nombre count];
    if (conteo>=1) {
        
        for (int a=0; a<=conteo-1; a++) {
            Titulos=[NSString stringWithFormat:@"%@",[Nombre objectAtIndex:a]];
            
        }
        
    }
    else{
        Titulos=@"No Files";
    }
    
    return Titulos;
    
}
//NSDictionarytoArray
-(NSArray*)DictoArrayc1c2c3:(NSDictionary*)dic c1:(NSString*)c1 c2:(NSString*)c2 c3:(NSString*)c3{
    NSMutableArray *Informacion=[[NSMutableArray alloc]init];
    NSArray *C1=[dic objectForKey:c1];
    NSArray *C2 =[dic objectForKey:c2];
    NSArray *C3=[dic objectForKey:c3];
    NSUInteger conteo=[C1 count];
    if (conteo>=1) {
        
        for (int a=0; a<=conteo-1; a++) {
            NSString *c1=[C1 objectAtIndex:a];
            NSString *c2=[C2 objectAtIndex:a];
            NSString *c3=[C3 objectAtIndex:a];

            NSArray *campo=[NSArray arrayWithObjects:c1,c2,c3,nil];
            [Informacion addObject:campo];
        }
        
    }
    else{
        NSString *c1=@"Sin Nombre";
        NSString *c2=@"Sin Apellido";
        NSString *c3=@"Sin Matricula";
        
        NSArray *campo=[NSArray arrayWithObjects:c1,c2,c3,nil];
        [Informacion addObject:campo];
    }
    
    NSArray *entrega=[NSArray arrayWithArray:Informacion];
    return entrega;
    
}

-(NSDictionary*)subgraf:(NSDictionary*)roles acumulados:(NSDictionary*)acum campos:(NSDictionary*)camp info:(NSArray*)info info2:(NSArray*)info2 info3:(NSArray*)info3 info4:(NSArray*)info4{
    //Roles
    NSArray *Campos=[roles objectForKey:[info objectAtIndex:0]];
    //Acumulados
    NSMutableArray *acumulacion=[[NSMutableArray alloc]init];
    NSArray *Posicion=[acum objectForKey:[info2 objectAtIndex:0]];
    NSArray *ccalif=[acum objectForKey:[info2 objectAtIndex:1]];
    NSArray *scalif=[acum objectForKey:[info2 objectAtIndex:2]];
    NSArray *cPosicion=[camp objectForKey:[info3 objectAtIndex:1]];
   // NSArray *cActividad=[acum objectForKey:[info3 objectAtIndex:0]];
    NSArray *cCalif=[camp objectForKey:[info3 objectAtIndex:2]];
    
    if ([Posicion count]>0) {
        for (int a=0; a<=[Posicion count]-1; a++) {
            if (([[ccalif objectAtIndex:a]floatValue]*100)>([[scalif objectAtIndex:a] floatValue])) {
                [acumulacion addObject:[NSString stringWithFormat:@"%f",[[ccalif objectAtIndex:a]floatValue]*100]];
            }
            else{
                [acumulacion addObject:[scalif objectAtIndex:a]];
            }
        }
    }
    NSArray *Acumulado=[NSArray arrayWithArray:acumulacion];
    
    //NSLog(@"INICIAL infernal1 %@, infernal2 %@",roles,acum);

    NSMutableArray *ccampos=[[NSMutableArray alloc]init];
    NSMutableArray *cvalor=[[NSMutableArray alloc]init];
    if ([Posicion count]>0) {
        for (int b=0; b<=[Posicion count]-1; b++) {
            NSMutableArray *campos=[[NSMutableArray alloc]init];
            NSMutableArray *valor=[[NSMutableArray alloc]init];
            int d=1;
            if ([cPosicion count]>0) {
                for (int c=0; c<=[cPosicion count]-1; c++) {
                    if ([[Posicion objectAtIndex:b] isEqualToString:[cPosicion objectAtIndex:c]]) {
                        [campos addObject:[NSString stringWithFormat:@"%i",d]];
                        [valor addObject:[cCalif objectAtIndex:c]];
                        d++;
                    }
                }
            }
            NSArray *acampos=[NSArray arrayWithArray:campos];
            NSArray *avalores=[NSArray arrayWithArray:valor];
            [ccampos addObject:acampos];
            [cvalor addObject:avalores];
        }
    }


NSArray *acampos=[NSArray arrayWithArray:ccampos];
NSArray *avalores=[NSArray arrayWithArray:cvalor];
    //NSLog(@"MEDIO infernal1 %@,Infernal 2%@, infernal3 %@",cPosicion,cActividad,cCalif);

NSMutableDictionary *informacion=[[NSMutableDictionary alloc]init];
[informacion setObject:Campos forKey:[info4 objectAtIndex:0]];
[informacion setObject:Acumulado forKey:[info4 objectAtIndex:1]];
[informacion setObject:acampos forKey:[info4 objectAtIndex:2]];
[informacion setObject:avalores forKey:[info4 objectAtIndex:3]];

NSDictionary *infofinal=[NSDictionary dictionaryWithDictionary:informacion];
    //NSLog(@"FINAL infernal %@",infofinal);
    return infofinal;
    
}
-(NSDictionary*)idaiNoCa:(NSDictionary*)dic nombre:(NSString*)c1  Calificacion:(NSString*)c2 informacion:(NSString*)info2{
    
    NSMutableDictionary *valores=[[NSMutableDictionary alloc]init];
    NSMutableArray *maidd=[[NSMutableArray alloc]init];
    NSMutableArray *maNombre=[[NSMutableArray alloc]init];
    NSMutableArray *maCalificacion=[[NSMutableArray alloc]init];
    NSMutableArray *maColores=[[NSMutableArray alloc]init];
    
    NSArray *C1=[dic objectForKey:c1];
    NSArray *C2 =[dic objectForKey:c2];
    NSUInteger conteo=[C1 count];
    if (conteo>=1) {
        
        for (int a=0; a<=conteo-1; a++) {
            
            [maidd addObject:[NSString stringWithFormat:@"%i",a+1]];
            [maNombre addObject:[C1 objectAtIndex:a]];
            [maCalificacion addObject:[NSString stringWithFormat:@"%.2f",[[C2 objectAtIndex:a] floatValue]]];
            if ([[C2 objectAtIndex:a] floatValue] == [info2 floatValue]) {
                [maColores addObject:[UIColor redColor]];
            }
            
            else{
            if (a==0) {
                if (conteo>1) {
                     float diferencia2=[[C2 objectAtIndex:a]floatValue]-[[C2 objectAtIndex:a+1] floatValue];
                    
                    if (fabsf(diferencia2)==0) {
                        //NSLog(@"A1 comparativa %@,%@",[C2 objectAtIndex:a],[C2 objectAtIndex:a+1]);
                        //NSLog(@"A1 resultado%f",([[C2 objectAtIndex:a]floatValue]-[[C2 objectAtIndex:a+1] floatValue]));
                        [maColores addObject:[UIColor redColor]];
                    }
                    else{
                        [maColores addObject:[UIColor whiteColor]];
                    }
                }
                else{
                   [maColores addObject:[UIColor whiteColor]];
                }
            }
            else if ((a<=conteo-2)&&(a>=1)) {
                float diferencia=[[C2 objectAtIndex:a]floatValue]-[[C2 objectAtIndex:a-1] floatValue];
                float diferencia2=[[C2 objectAtIndex:a]floatValue]-[[C2 objectAtIndex:a+1] floatValue];
                
                if (fabs(diferencia)==0) {
                    //NSLog(@"A2 comparativa %f",diferencia);
                    //NSLog(@"A2 resultado%f",fabs(diferencia));
                    [maColores addObject:[UIColor redColor]];
                }
                else if (fabs(diferencia2)==0) {
                    //NSLog(@"A3 comparativa %f",diferencia2);
                    //NSLog(@"A3 resultado%f",fabs(diferencia2));
                    [maColores addObject:[UIColor redColor]];
                }
                else{
                    [maColores addObject:[UIColor whiteColor]];
                }
            }
            else{
                float diferencia=[[C2 objectAtIndex:a]floatValue]-[[C2 objectAtIndex:a-1] floatValue];
                if (fabs(diferencia)==0) {
                    //NSLog(@"A4 comparativa %@,%@",[C2 objectAtIndex:a],[C2 objectAtIndex:a-1]);
                    //NSLog(@"A4 resultado%f",([[C2 objectAtIndex:a]floatValue]-[[C2 objectAtIndex:a-1] floatValue]));
                    [maColores addObject:[UIColor redColor]];
                }
                else{
                    [maColores addObject:[UIColor whiteColor]];
                    
                }
            }
            }
            
        }
        
    }
    else{
        [maidd addObject:@"00"];
        [maNombre addObject:@"No Information"];
        [maCalificacion addObject:@"0.0"];
        [maColores addObject:[UIColor whiteColor]];
    }
    
    NSArray *idd2=[NSArray arrayWithArray:maidd];
    NSArray *nombre2=[NSArray arrayWithArray:maNombre];
    NSArray *calificacion2=[NSArray arrayWithArray:maCalificacion];
    NSArray *colores2=[NSArray arrayWithArray:maColores];
    [valores setObject:idd2 forKey:@"Id"];
    [valores setObject:nombre2 forKey:@"Nombre"];
    [valores setObject:calificacion2 forKey:@"Calificacion"];
    [valores setObject:colores2 forKey:@"Colores"];
    NSDictionary *info=[NSDictionary dictionaryWithDictionary:valores];
    return info;

}
-(NSDictionary*)idaiNoCaBa:(NSDictionary*)dic nombre:(NSString*)c1  Calificacion:(NSString*)c2 Bandera:(NSString*)c3{
    
    NSMutableDictionary *valores=[[NSMutableDictionary alloc]init];
    NSMutableArray *maidd=[[NSMutableArray alloc]init];
    NSMutableArray *maNombre=[[NSMutableArray alloc]init];
    NSMutableArray *maCalificacion=[[NSMutableArray alloc]init];
    NSMutableArray *maColores=[[NSMutableArray alloc]init];
    NSMutableArray *maBandera=[[NSMutableArray alloc]init];
    
    NSArray *C1=[dic objectForKey:c1];
    NSArray *C2 =[dic objectForKey:c2];
    NSArray *C3 =[dic objectForKey:c3];
    NSUInteger conteo=[C1 count];
    if (conteo>=1) {
        
        for (int a=0; a<=conteo-1; a++) {
            
            [maidd addObject:[NSString stringWithFormat:@"%i",a+1]];
            [maNombre addObject:[C1 objectAtIndex:a]];
            [maCalificacion addObject:[NSString stringWithFormat:@"%.2f",[[C2 objectAtIndex:a] floatValue]]];
            [maBandera addObject:[NSString stringWithFormat:@"%@",[C3 objectAtIndex:a]]];
            
            /*if (a==0) {
                if (conteo>1) {
                    float diferencia2=[[C2 objectAtIndex:a]floatValue]-[[C2 objectAtIndex:a+1] floatValue];
                    
                    if (fabsf(diferencia2)==0) {
                        //NSLog(@"A1 comparativa %@,%@",[C2 objectAtIndex:a],[C2 objectAtIndex:a+1]);
                        //NSLog(@"A1 resultado%f",([[C2 objectAtIndex:a]floatValue]-[[C2 objectAtIndex:a+1] floatValue]));
                        [maColores addObject:[UIColor redColor]];
                    }
                    else{
                        [maColores addObject:[UIColor whiteColor]];
                    }
                }
                else{
                    [maColores addObject:[UIColor whiteColor]];
                }
            }
            else if ((a<=conteo-2)&&(a>=1)) {
                float diferencia=[[C2 objectAtIndex:a]floatValue]-[[C2 objectAtIndex:a-1] floatValue];
                float diferencia2=[[C2 objectAtIndex:a]floatValue]-[[C2 objectAtIndex:a+1] floatValue];
                
                if (fabs(diferencia)==0) {
                    //NSLog(@"A2 comparativa %f",diferencia);
                    //NSLog(@"A2 resultado%f",fabs(diferencia));
                    [maColores addObject:[UIColor redColor]];
                }
                else if (fabs(diferencia2)==0) {
                    //NSLog(@"A3 comparativa %f",diferencia2);
                    //NSLog(@"A3 resultado%f",fabs(diferencia2));
                    [maColores addObject:[UIColor redColor]];
                }
                else{
                    [maColores addObject:[UIColor whiteColor]];
                }
            }
            else{
                float diferencia=[[C2 objectAtIndex:a]floatValue]-[[C2 objectAtIndex:a-1] floatValue];
                if (fabs(diferencia)==0) {
                    //NSLog(@"A4 comparativa %@,%@",[C2 objectAtIndex:a],[C2 objectAtIndex:a-1]);
                    //NSLog(@"A4 resultado%f",([[C2 objectAtIndex:a]floatValue]-[[C2 objectAtIndex:a-1] floatValue]));
                    [maColores addObject:[UIColor redColor]];
                }
                else{
                    [maColores addObject:[UIColor whiteColor]];
                    
                }
            }*/
            
        }
        
    }
    else{
        [maidd addObject:@"00"];
        [maNombre addObject:@"No Information"];
        [maCalificacion addObject:@"0.0"];
        [maColores addObject:[UIColor whiteColor]];
         [maBandera addObject:@""];
    }
    
    NSArray *idd2=[NSArray arrayWithArray:maidd];
    NSArray *nombre2=[NSArray arrayWithArray:maNombre];
    NSArray *calificacion2=[NSArray arrayWithArray:maCalificacion];
    NSArray *colores2=[NSArray arrayWithArray:maColores];
    NSArray *bandera2=[NSArray arrayWithArray:maBandera];
    [valores setObject:idd2 forKey:@"Id"];
    [valores setObject:nombre2 forKey:@"Nombre"];
    [valores setObject:calificacion2 forKey:@"Calificacion"];
    [valores setObject:colores2 forKey:@"Colores"];
    [valores setObject:bandera2 forKey:@"Bandera"];
    NSDictionary *info=[NSDictionary dictionaryWithDictionary:valores];
    return info;
    
}
-(NSDictionary*)idaiNoCaBa:(NSDictionary*)dic nombre:(NSString*)c1  Calificacion:(NSString*)c2 Bandera:(NSString*)c3 start:(int)start{
    
    NSMutableDictionary *valores=[[NSMutableDictionary alloc]init];
    NSMutableArray *maidd=[[NSMutableArray alloc]init];
    NSMutableArray *maNombre=[[NSMutableArray alloc]init];
    NSMutableArray *maCalificacion=[[NSMutableArray alloc]init];
    NSMutableArray *maColores=[[NSMutableArray alloc]init];
    NSMutableArray *maBandera=[[NSMutableArray alloc]init];
    
    NSArray *C1=[dic objectForKey:c1];
    NSArray *C2 =[dic objectForKey:c2];
    NSArray *C3 =[dic objectForKey:c3];
    NSUInteger conteo=[C1 count];
    if (conteo>=1) {
        
        for (int a=0; a<=conteo-1; a++) {
            if (a+1>=start) {
            [maidd addObject:[NSString stringWithFormat:@"%i",a+1]];
            [maNombre addObject:[C1 objectAtIndex:a]];
            [maCalificacion addObject:[NSString stringWithFormat:@"%.2f",[[C2 objectAtIndex:a] floatValue]]];
            [maBandera addObject:[NSString stringWithFormat:@"%@",[C3 objectAtIndex:a]]];
            }
        
            
        }
        
    }
    else{
        [maidd addObject:@"00"];
        [maNombre addObject:@"No Information"];
        [maCalificacion addObject:@"0.0"];
        [maColores addObject:[UIColor whiteColor]];
        [maBandera addObject:@""];
    }
    
    NSArray *idd2=[NSArray arrayWithArray:maidd];
    NSArray *nombre2=[NSArray arrayWithArray:maNombre];
    NSArray *calificacion2=[NSArray arrayWithArray:maCalificacion];
    NSArray *colores2=[NSArray arrayWithArray:maColores];
    NSArray *bandera2=[NSArray arrayWithArray:maBandera];
    [valores setObject:idd2 forKey:@"Id"];
    [valores setObject:nombre2 forKey:@"Nombre"];
    [valores setObject:calificacion2 forKey:@"Calificacion"];
    [valores setObject:colores2 forKey:@"Colores"];
    [valores setObject:bandera2 forKey:@"Bandera"];
    NSDictionary *info=[NSDictionary dictionaryWithDictionary:valores];
    return info;
    
}

-(NSDictionary*)idNoCa:(NSDictionary*)dic nombre:(NSString*)c1  Calificacion:(NSString*)c2 Bandera:(NSString*)c3{
    
    NSMutableDictionary *valores=[[NSMutableDictionary alloc]init];
    NSMutableArray *maidd=[[NSMutableArray alloc]init];
    NSMutableArray *maNombre=[[NSMutableArray alloc]init];
    NSMutableArray *maCalificacion=[[NSMutableArray alloc]init];
    NSMutableArray *maColores=[[NSMutableArray alloc]init];
    NSMutableArray *maBandera=[[NSMutableArray alloc]init];
    //NSLog(@"Las Banderas%@",maBandera);
    NSArray *idd=[dic objectForKey:@"Id"];
    NSArray *C1=[dic objectForKey:c1];
    NSArray *C2 =[dic objectForKey:c2];
    NSArray *C3 =[dic objectForKey:c3];
    NSUInteger conteo=[C1 count];
    if (conteo>=1) {
        
        for (int a=0; a<=conteo-1; a++) {
            
            [maidd addObject:[idd objectAtIndex:a]];
            [maNombre addObject:[C1 objectAtIndex:a]];
            [maCalificacion addObject:[NSString stringWithFormat:@"%.2f",[[C2 objectAtIndex:a] floatValue]]];
            [maBandera addObject:[NSString stringWithFormat:@"%@",[C3 objectAtIndex:a]]];
            
            if (a==0) {
                if (conteo>1) {
                    float diferencia2=[[C2 objectAtIndex:a]floatValue]-[[C2 objectAtIndex:a+1] floatValue];
                    
                    if (fabsf(diferencia2)<0.2) {
                        [maColores addObject:[UIColor redColor]];
                    }
                    else{
                        [maColores addObject:[UIColor whiteColor]];
                    }
                }
                else{
                    [maColores addObject:[UIColor whiteColor]];
                }
            }
            else if ((a<=conteo-2)&&(a>=1)) {
                float diferencia=[[C2 objectAtIndex:a]floatValue]-[[C2 objectAtIndex:a-1] floatValue];
                float diferencia2=[[C2 objectAtIndex:a]floatValue]-[[C2 objectAtIndex:a+1] floatValue];
                
                if (fabs(diferencia)<0.2) {

                    [maColores addObject:[UIColor redColor]];
                }
                else if (fabs(diferencia2)<0.2) {
                    [maColores addObject:[UIColor redColor]];
                }
                else{
                    [maColores addObject:[UIColor whiteColor]];
                }
            }
            else{
                float diferencia=[[C2 objectAtIndex:a]floatValue]-[[C2 objectAtIndex:a-1] floatValue];
                if (fabs(diferencia)<0.2) {
                    [maColores addObject:[UIColor redColor]];
                }
                else{
                    [maColores addObject:[UIColor whiteColor]];
                    
                }
            }
            
        }
        
    }

    else{
        [maidd addObject:@"00"];
        [maNombre addObject:@"No Information"];
        [maCalificacion addObject:@"0.0"];
        [maColores addObject:[UIColor whiteColor]];
        [maBandera addObject:@""];
    }
    
    NSArray *idd2=[NSArray arrayWithArray:maidd];
    NSArray *nombre2=[NSArray arrayWithArray:maNombre];
    NSArray *calificacion2=[NSArray arrayWithArray:maCalificacion];
    NSArray *colores2=[NSArray arrayWithArray:maColores];
     NSArray *banderas2=[NSArray arrayWithArray:maBandera];
    [valores setObject:idd2 forKey:@"Id"];
    [valores setObject:nombre2 forKey:@"Nombre"];
    [valores setObject:calificacion2 forKey:@"Calificacion"];
    [valores setObject:colores2 forKey:@"Colores"];
    [valores setObject:banderas2 forKey:@"Bandera"];
    NSDictionary *info=[NSDictionary dictionaryWithDictionary:valores];
    return info;
    
}
-(NSDictionary*)idNoCaSC:(NSDictionary*)dic nombre:(NSString*)c1  Calificacion:(NSString*)c2 Bandera:(NSString*)c3 start:(int)start cant:(int)cant{
    
    NSMutableDictionary *valores=[[NSMutableDictionary alloc]init];
    NSMutableArray *maidd=[[NSMutableArray alloc]init];
    NSMutableArray *maNombre=[[NSMutableArray alloc]init];
    NSMutableArray *maCalificacion=[[NSMutableArray alloc]init];
    NSMutableArray *maColores=[[NSMutableArray alloc]init];
    NSMutableArray *maBandera=[[NSMutableArray alloc]init];
    //NSLog(@"Las Banderas%@",maBandera);
    NSArray *idd=[dic objectForKey:@"Id"];
    NSArray *C1=[dic objectForKey:c1];
    NSArray *C2 =[dic objectForKey:c2];
    NSArray *C3 =[dic objectForKey:c3];
    NSUInteger conteo=[C1 count];
    if (conteo>=1) {
        for (int a=0; a<=conteo-1; a++) {
            if ([[idd objectAtIndex:a] intValue]>=start) {
                [maidd addObject:[NSString stringWithFormat:@"%i",a+1]];
                [maNombre addObject:[C1 objectAtIndex:a]];
                [maCalificacion addObject:[NSString stringWithFormat:@"%.2f",[[C2 objectAtIndex:a] floatValue]]];
                [maBandera addObject:[NSString stringWithFormat:@"%@",[C3 objectAtIndex:a]]];
            
                if (a==0) {
                    if (conteo>1) {
                        float diferencia2=[[C2 objectAtIndex:a]floatValue]-[[C2 objectAtIndex:a+1] floatValue];
                    
                        if (fabsf(diferencia2)<0.2) {
                            [maColores addObject:[UIColor redColor]];
                        }
                        else{
                            [maColores addObject:[UIColor whiteColor]];
                        }
                    }
                    else{
                    [maColores addObject:[UIColor whiteColor]];
                    }
                }
                else if ((a<=conteo-2)&&(a>=1)) {
                    float diferencia=[[C2 objectAtIndex:a]floatValue]-[[C2 objectAtIndex:a-1] floatValue];
                    float diferencia2=[[C2 objectAtIndex:a]floatValue]-[[C2 objectAtIndex:a+1] floatValue];
                
                    if (fabs(diferencia)<0.2) {
                    
                        [maColores addObject:[UIColor redColor]];
                    }
                    else if (fabs(diferencia2)<0.2) {
                        [maColores addObject:[UIColor redColor]];
                    }
                    else{
                        [maColores addObject:[UIColor whiteColor]];
                    }
                }
                else{
                    float diferencia=[[C2 objectAtIndex:a]floatValue]-[[C2 objectAtIndex:a-1] floatValue];
                    if (fabs(diferencia)<0.2) {
                        [maColores addObject:[UIColor redColor]];
                    }
                    else{
                        [maColores addObject:[UIColor whiteColor]];
                    
                    }
                }
            }
            else{
                /*[maidd addObject:@"00"];
                [maNombre addObject:@"No Information"];
                [maCalificacion addObject:@"0.0"];
                [maColores addObject:[UIColor whiteColor]];
                [maBandera addObject:@""];*/
            }
            
        }
        
    }
    
    else{
        [maidd addObject:@"00"];
        [maNombre addObject:@"No Information"];
        [maCalificacion addObject:@"0.0"];
        [maColores addObject:[UIColor whiteColor]];
        [maBandera addObject:@""];
    }
    
    NSArray *idd2=[NSArray arrayWithArray:maidd];
    NSArray *nombre2=[NSArray arrayWithArray:maNombre];
    NSArray *calificacion2=[NSArray arrayWithArray:maCalificacion];
    NSArray *colores2=[NSArray arrayWithArray:maColores];
    NSArray *banderas2=[NSArray arrayWithArray:maBandera];
    [valores setObject:idd2 forKey:@"Id"];
    [valores setObject:nombre2 forKey:@"Nombre"];
    [valores setObject:calificacion2 forKey:@"Calificacion"];
    [valores setObject:colores2 forKey:@"Colores"];
    [valores setObject:banderas2 forKey:@"Bandera"];
    NSDictionary *info=[NSDictionary dictionaryWithDictionary:valores];
    return info;
    
}
-(NSDictionary*)idNoCag:(NSDictionary*)dic nombre:(NSString*)c1  Calificacion:(NSString*)c2{
    
    NSMutableDictionary *valores=[[NSMutableDictionary alloc]init];
    NSMutableArray *titulo=[[NSMutableArray alloc]init];

    //NSArray *idd=[dic objectForKey:@"Idd"];
    NSArray *C1=[dic objectForKey:c1];
    NSArray *C2 =[dic objectForKey:c2];
    NSUInteger conteo=[C1 count];
    if (conteo>=1) {
        
        for (int a=0; a<=conteo-1; a++) {
            
            [titulo addObject:[NSString stringWithFormat:@"%i %@ %.2f",a+1,[C1 objectAtIndex:a],[[C2 objectAtIndex:a] floatValue]]];

        }
        
    }
    else{
        [titulo addObject:@"No Files"];

    }
    
    NSArray *tTitulo=[NSArray arrayWithArray:titulo];
    [valores setObject:tTitulo forKey:@"Titulo"];
    NSDictionary *info=[NSDictionary dictionaryWithDictionary:valores];
    return info;
    
}


@end

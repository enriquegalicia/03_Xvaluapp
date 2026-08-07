//
//  GestorBD.m
//  GestorBIM
//
//  Created by Enrique Galicia on 20/03/14.
//
//

#import "GestorBD.h"

@implementation GestorBD
-(id)initwithdatabases:(NSString*)base{
    
    valores=[[NSMutableDictionary alloc]init];
    
    //Nivel1
    NSArray *artapa=[NSArray arrayWithObjects:@"PARTICIPANTES",@"IDD INTEGER",@"NOMBRE TEXT",@"PAIS TEXT",nil];
    NSArray *artaru=[NSArray arrayWithObjects:@"RUBROS",@"IDD INTEGER",@"NOMBRE TEXT",nil];
    NSArray *artaju=[NSArray arrayWithObjects:@"JUECES",@"IDD INTEGER",@"NOMBRE TEXT", nil];
    NSArray *artaev=[NSArray arrayWithObjects:@"EVALUACION",@"JUEZ TEXT",@"PARTICIPANTE TEXT",@"RUBRO TEXT",@"CALIFICACION FLOAT",nil];
    NSArray *artaevlo=[NSArray arrayWithObjects:@"EVALUACIONLO",@"JUEZ TEXT",@"PARTICIPANTE TEXT",@"RUBRO TEXT",@"CALIFICACION FLOAT",nil];
     NSArray *artabuf=[NSArray arrayWithObjects:@"BUFFER",@"JUEZ TEXT",@"PARTICIPANTE INTEGER",@"RUBRO TEXT",@"CALIFICACION FLOAT",@"APROBADO TEXT",nil];

    
    NSArray *BDN1A=[NSArray arrayWithObjects:@"Id",@"Idd",@"Nombre",@"Pais",nil];
    NSArray *BDN1AS=[NSArray arrayWithObjects:@"Idd",@"Nombre",@"Pais",nil];
    [valores setObject:BDN1A forKey:@"BDN1A"];
    [valores setObject:BDN1AS forKey:@"BDN1AS"];
    
    NSArray *BDN1=[NSArray arrayWithObjects:@"Id",@"Idd",@"Nombre", nil];
    NSArray *BDN1S=[NSArray arrayWithObjects:@"Idd",@"Nombre", nil];
    [valores setObject:BDN1 forKey:@"BDN1"];
    [valores setObject:BDN1S forKey:@"BDN1S"];
    
    NSArray *BDEV=[NSArray arrayWithObjects:@"Id",@"Juez",@"Participante",@"Rubro",@"Calificacion",nil];
    NSArray *BDEVS=[NSArray arrayWithObjects:@"Juez",@"Participante",@"Rubro",@"Calificacion",nil];
    [valores setObject:BDEV forKey:@"BDEV"];
    [valores setObject:BDEVS forKey:@"BDEVS"];
    
    NSArray *BDBUF=[NSArray arrayWithObjects:@"Id",@"Juez",@"Participante",@"Rubro",@"Calificacion",@"Aprobado",nil];
    NSArray *BDBUFS=[NSArray arrayWithObjects:@"Juez",@"Participante",@"Rubro",@"Calificacion",@"Aprobado",nil];
    [valores setObject:BDBUF forKey:@"BDBUF"];
    [valores setObject:BDBUFS forKey:@"BDBUFS"];
    
    //Nivel2
    
    [valores setObject:artapa forKey:@"PARTICIPANTES"];
    [valores setObject:artaju forKey:@"JUECES"];
    [valores setObject:artaru forKey:@"RUBROS"];
    [valores setObject:artaev forKey:@"EVALUACION"];
    [valores setObject:artaevlo forKey:@"EVALUACIONLO"];
    [valores setObject:artabuf forKey:@"BUFFER"];
    
    NSArray *completo =[NSArray arrayWithObjects:artapa,artaju,artaru,artaev,artaevlo,artabuf,nil];

    Basedatos=[[DataBase alloc]initDB:base Tablas:completo];
    
    return self;
    
}

-(void)saveinfo:(NSArray*)info val:(NSString*)val testigo:(NSString*)testigo tabla:(NSString*)tabla campo:(NSString*)campo nombre:(NSString*)nombre{

    [Basedatos revisarBD:[valores objectForKey:val] Valores:info Testigo:testigo Tabla:tabla Campo:campo Nombre:nombre];
}
-(void)saveinfo2:(NSArray*)info val:(NSString*)val testigo:(NSString*)testigo tabla:(NSString*)tabla campo:(NSString*)campo nombre:(NSString*)nombre campo2:(NSString*)campo2 nombre2:(NSString*)nombre2{
    [Basedatos revisarBD2T:[valores objectForKey:val] Valores:info  Testigo:testigo Tabla:tabla Campo:campo Nombre:nombre Campo2:campo2 Nombre2:nombre2 ];
}
-(void)saveinfo2update:(NSArray*)info val:(NSString*)val testigo:(NSString*)testigo tabla:(NSString*)tabla campo:(NSString*)campo nombre:(NSString*)nombre campo2:(NSString*)campo2 nombre2:(NSString*)nombre2 cupdate:(NSString*)cupdate vupdate:(NSString*)vupdate{
    //NSLog(@"Actualizar");
    [Basedatos revisarBD2Tupdate:[valores objectForKey:val] Valores:info  Testigo:testigo Tabla:tabla Campo:campo Nombre:nombre Campo2:campo2 Nombre2:nombre2 cupdate:cupdate vupdate:vupdate];
}

-(void)updateinfo:(NSString*)info{
    [Basedatos update:info];
}
-(NSDictionary*)getalltb:(NSString*)tabla val:(NSString*)val{
    return [Basedatos getalltablesfromDB:tabla campos:[valores objectForKey:val]];
}

-(NSDictionary*)getselecteddatatb:(NSString*)tabla val:(NSArray*)val{
    return [Basedatos getalltablesfromDB:tabla campos:val];
}

-(NSDictionary*)getselecteddatast:(NSString*)st val:(NSArray*)val{
    return [Basedatos getalldatafromstatement:st campos:val];
}
-(NSString*)getsingle:(NSString*)statement{
    return [Basedatos getselecteddatafromstatement:statement];
}
-(void)renewal:(NSString*)tabla tablas:(NSString*)tablas{
    [Basedatos deletetable:tabla Tablas:[valores objectForKey:tablas]];
}




@end

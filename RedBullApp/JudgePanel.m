//
//  ConnectDevices.m
//  RedBullApp
//
//  Created by Enrique Galicia on 30/01/14.
//  Copyright (c) 2014 Enrique Galicia. All rights reserved.
//

#import "JudgePanel.h"



@interface JudgePanel ()

@end

@implementation JudgePanel
@synthesize delegadojuez=_delegadojuez;
@synthesize perfil;
@synthesize myPeerID;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)getgrade:(NSString*)participante juez:(NSString*)juez{
    //NSLog(@"participante %@ juez %@",participante,juez);
    NSString *idparticipante=[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT id FROM participantes WHERE nombre=\"%@\"",participante]];
    NSString *calificacion=[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT calificacion FROM buffer WHERE participante=\"%@\" AND juez=\"%@\"",idparticipante,juez]];
    //NSLog(@"participante %@ juez %@ calificacion ",idparticipante,juez);
    if ([calificacion isEqualToString:@""]) {
        TfUpdateLocalGrade.text=@"";
    }
    else{
        TfUpdateLocalGrade.text=calificacion;
    }
    
    //NSLog(@"Jueces %@ %@",idparticipante,idjuez);
    [valoresphp setObject:idparticipante forKey:@"LocalPar"];
    [valoresphp setObject:juez forKey:@"LocalJue"];
    
}

//Seleccionado Tabla
-(void)setselected:(NSString*)seleccion fun:(int)fun{
    //Start Configuration
    if (fun==1) {
        [valoresphp setObject:seleccion forKey:@"Modificar"];
        TfCampo.text=[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT Nombre FROM %@ WHERE idd=\"%@\"",[valoresphp objectForKey:@"Lista"],seleccion]];
    }
    //Seleccion de Anterior
    if (fun==2) {
        [valoresphp setObject:@"2" forKey:@"Funcion"];
        [valoresphp setObject:[NSString stringWithFormat:@"%i",[seleccion intValue]] forKey:@"Participante"];
        //NSLog(@"valor%@",[valoresphp objectForKey:@"Participante"]);
        LaEvParcial.text=@"";
    }
    //Seleccion de Siguiente
    if (fun==3) {
        [valoresphp setObject:@"3" forKey:@"Funcion"];
        [valoresphp setObject:seleccion forKey:@"Participante"];
        //NSLog(@"valor3%@",[valoresphp objectForKey:@"Participante"]);
        LaEvParcial.text=@"";
    }
    //Seleccion en Detalle de Maestro
    if (fun==5) {
        //NSLog(@"El Participante es %@",seleccion);
        [valoresphp setObject:@"5" forKey:@"Funcion"];
        [valoresphp setObject:seleccion forKey:@"Participante"];



        NSString *id1=[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT id FROM participantes WHERE nombre=\"%@\"",seleccion]];
        NSString *idd=[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT idd FROM participantes WHERE nombre=\"%@\"",seleccion]];
        [prefs setObject:id1 forKey:@"Participante"];
        //NSLog(@"El Numero %@",[prefs objectForKey:@"Participante"]);
        //NSLog(@"El Participante es%@ %@",id1,idd);
        IvDetalle.idd.text=idd;
        IvDetalle.Nombre.text=seleccion;
        [valoresphp setObject:id1 forKey:@"Party"];
        if ([idd intValue]>0) {
        IvDetalle.Calificacion.text=[NSString stringWithFormat:@"%.2f",[[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT AVG(calificacion) FROM buffer WHERE participante=\"%@\"",idd]] floatValue]];
        IvDetalle.colorcalificacion=[self ColorCalifa:[NSString stringWithFormat:@"%.2f",[[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT AVG(calificacion) FROM buffer WHERE participante=\"%@\"",idd]] floatValue]]];
        }
        [self cargarDetalle:id1];
        [valoresphp setObject:@"0" forKey:@"LocalPar"];
        [valoresphp setObject:@"0" forKey:@"LocalJue"];
        TfUpdateLocalGrade.text=@"";
    }
}
-(UIColor*)ColorCalifa:(NSString*)califa1{
    NSArray *indices=[NSArray arrayWithObjects:@"Calificacion", nil];
    NSDictionary *lleno=[BDParticipantes getalltb:@"evaluacion" val:@"BDEV"];
    //NSLog(@"AA%@",lleno);
    if ([[lleno objectForKey:@"Id"] count]>0) {
    NSDictionary *califasiguales=[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT AVG(calificacion) FROM evaluacion GROUP BY participante"] val:indices];
    NSArray *califencontradas=[califasiguales objectForKey:@"Calificacion"];
    //NSLog(@"califas encontradas%@ califa%@",califencontradas,califa1);
    int b=0;
    if ([califencontradas count]>0) {
        for (int a=0; a<=[califencontradas count]-1; a++) {
            if ([[califencontradas objectAtIndex:a] floatValue ]==[califa1 floatValue]) {
                //NSLog(@"Encontre");
                b=1;
            }
        }
    }
    //NSLog(@"%i",b);
    if (b==0) {
        return [UIColor whiteColor];
    }
    else{
        return [UIColor redColor];
    }
    }
return  [UIColor whiteColor];
}
-(IBAction)FRank:(id)sender{
    //NSLog(@"EjecuteFrank");
    if (totales) {
        ResultadosGlobales.view.alpha=0;
        ResultadosRondas.view.alpha=1;
        IvFondo.image=[UIImage imageNamed:@"Heat general.png"];
        [self.view bringSubviewToFront:ResultadosRondas.view];
        [self loadlastheatavailablerounds];
        totales=FALSE;
        
    }
    else{
        ResultadosRondas.view.alpha=0;
        ResultadosGlobales.view.alpha=1;
         IvFondo.image=[UIImage imageNamed:@"Ranking general.png"];
        [self.view bringSubviewToFront:ResultadosGlobales.view];
        [self cargarresultadosglobales:1 cantidad:[[valoresphp objectForKey:@"totalidad"] intValue]];
        totales=TRUE;
        
    }
    
    
    
}

-(IBAction)Play:(id)sender{
    if (!totales) {

    if (timer1) {
        [timer1 invalidate];
    }
    if ([arreglotimers count]>0) {
        //NSLog(@"Numero de timers%i",[arreglotimers count]);
        for (int a=0; a<=[arreglotimers count]-1; a++) {
            if ([arreglotimers objectAtIndex:a]) {
                [[arreglotimers objectAtIndex:a] invalidate];
            }
        }
    }
    if (timer3) {
        [timer1 invalidate];
    }
    if (timer4) {
        [timer1 invalidate];
    }
    ResultadosGlobales.view.alpha=0;
    [self loadlastheatavailablerounds];
    
    if ([[prefs objectForKey:@"Archivo"] isEqualToString:@"DirtConquers1.db"]) {
        //NSLog(@"numero pan%i",[self numerodepantallas]);
        timer1=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(apagarrondas) userInfo:nil repeats:NO];
        primero=0;
        IvFondo.image=[UIImage imageNamed:@"Ranking general.png"];
        for (int a=0; a<=[self numerodepantallas]-1; a++) {
            NSTimer *timer2=[NSTimer scheduledTimerWithTimeInterval:((4*a)+1) target:self selector:@selector(ranking) userInfo:nil repeats:NO];
            [arreglotimers addObject:timer2];
        }
        timer3=[NSTimer scheduledTimerWithTimeInterval:((4*([self numerodepantallas]))+1) target:self selector:@selector(prenderronda) userInfo:nil repeats:NO];
    }
    else{
            timer1=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(apagarrondas) userInfo:nil repeats:NO];
            primero=0;
            IvFondo.image=[UIImage imageNamed:@"Ranking general.png"];
            for (int a=0; a<=[self numerodepantallas]-1; a++) {
                NSTimer *timer2=[NSTimer scheduledTimerWithTimeInterval:((4*a)+1) target:self selector:@selector(ranking) userInfo:nil repeats:NO];
                [arreglotimers addObject:timer2];
            }
            timer3=[NSTimer scheduledTimerWithTimeInterval:((4*([self numerodepantallas]))+1) target:self selector:@selector(prenderronda) userInfo:nil repeats:NO];
    }
    }
}
-(int)numerodepantallas{
    int pantallas=0;
    int total=[[valoresphp objectForKey:@"Activos"]intValue];
    if ( total % 6 == 0) {
        pantallas=total/6;
    }
    else{
        pantallas=(total/6)+1;
    }
    return pantallas;
}

-(void)apagarrondas{
    [funa fadeOutView:ResultadosRondas.view withDuration:1 andWait:0];
}
-(void)ranking{
    [arreglotimers removeObjectAtIndex:0];
    [self cargarresultadosglobales:(primero*6)+1 cantidad:6];
    [funa fadeInView:ResultadosGlobales.view withDuration:1 andWait:0];
    primero++;
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(apagarranking) userInfo:nil repeats:NO];
}
-(void)apagarranking{
    [funa fadeOutView:ResultadosGlobales.view withDuration:1 andWait:0];
}
-(void)prenderronda{
    IvFondo.image=[UIImage imageNamed:@"Heat general.png"];
    [funa fadeInView:ResultadosRondas.view withDuration:1 andWait:0];
                                                     
}

-(void)loadlastheatavailablerounds{

    NSArray *arid=[NSArray arrayWithObjects:@"Id",nil];

    NSDictionary *evaluados=[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT participante FROM evaluacion GROUP BY participante ORDER BY participante ASC"] val:arid];

    //NSLog(@"evaluados%@",evaluados);
    NSArray *aid=[evaluados objectForKey:@"Id"];
    [valoresphp setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[aid count]] forKey:@"totalidad"];

    //NSLog(@"INICIO %i Y DURACION %i",[self getlastheat:[aid count]],[self getlastquantity]);
    
    [self cargarresultadosrondas:[self getlastheat:[aid count]] cantidad:[self getlastquantity]];

}
-(int)getlastheat:(int)cantidad{
    [valoresphp setObject:[NSString stringWithFormat:@"%i",cantidad] forKey:@"Activos"];
    int divisiones=[[prefs objectForKey:@"Divisiones"] intValue];
    NSDictionary *participantes=[BDParticipantes getalltb:@"participantes" val:@"BDN1"];
    NSArray *arpar=[participantes objectForKey:@"Id"];
    //NSLog(@"numeros1%@",arpar);
    int totalparticipantes=[arpar count];
    [valoresphp setObject:[NSString stringWithFormat:@"%i",totalparticipantes] forKey:@"totalp"];
    int secciones=totalparticipantes/divisiones;
    float fsec=secciones;
    float ftotal=totalparticipantes;
    float fdivi=ftotal/fsec;
    [valoresphp setObject:[NSString stringWithFormat:@"%f",fdivi] forKey:@"factord"];
    NSLog(@"cantidad1 %i Divisiones %i",cantidad,divisiones);
    int numeros=cantidad/divisiones;
    NSLog(@"numeros %i diviciones*numero %i",numeros,(numeros*divisiones));
    int primerid=0;
    if (totalparticipantes % divisiones == 0) {
        int distancia=cantidad/divisiones;
        
        if (cantidad==totalparticipantes) {
            primerid=cantidad-(divisiones)+1;
            NSLog(@"Caso1");
        }
        else{
            if (distancia>0) {
                if (cantidad<(divisiones*(distancia+1))) {
                    
                    if (cantidad % divisiones == 0){
                        NSLog(@"Caso2");
                        primerid=(divisiones*(distancia-1))+1;
                    }
                    
                     else{
                         NSLog(@"Caso3");
                       primerid=(divisiones*(distancia))+1;
                     }
                }else{
                    NSLog(@"Caso4");
                    primerid=cantidad-(divisiones*(distancia));
                }

            }
            else{
                if (cantidad<divisiones) {
                    NSLog(@"Caso5");
                    primerid=(divisiones*(distancia-1));
                    if (primerid<0) {
                        primerid=0;
                    }
                }else{
                    NSLog(@"Caso6");
                    primerid=cantidad-(divisiones*(distancia));
                }
            }
        }
    }
    else {
        if (cantidad==totalparticipantes) {
            NSLog(@"Caso7");
            primerid=totalparticipantes-((numeros*divisiones)-((numeros-1)*divisiones))+2;
            
        }
        else{
             if (cantidad % divisiones == 0) {
                NSLog(@"Caso8A");
                primerid=((numeros*divisiones)-divisiones)+1;
            }
            else{
                 NSLog(@"Caso8B");
                primerid=(numeros*divisiones)+1;
            }
            
        }
        
    }
    NSLog(@"primerid  %i",primerid);
    
    [valoresphp setObject:[NSString stringWithFormat:@"%i",primerid] forKey:@"pheat"];
    
    return primerid;
    
}
-(int)getlastquantity{
 
    int elementos=[[valoresphp objectForKey:@"totalp"]intValue]-[[valoresphp objectForKey:@"pheat"]intValue];
    //NSLog(@"Totales %i, Numero Actual %i",[[valoresphp objectForKey:@"totalp"]intValue],[[valoresphp objectForKey:@"pheat"]intValue]);
    return elementos;
}

//Seleccionado ComboBox
-(void)sendselection:(int)sendselection titulo:(NSString*)titulo{
    
    if ([titulo isEqualToString:@"Juez"]) {
        [prefs setObject:[NSString stringWithFormat:@"%i",sendselection] forKey:@"Juez"];
        [prefs setObject:[NSString stringWithFormat:@"%i",sendselection] forKey:@"Rubro"];
        [prefs synchronize];
        LaJuez.text=[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT nombre FROM jueces WHERE idd=\"%i\" ORDER BY idd DESC",sendselection]];
        LaRubro.text=[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT nombre FROM rubros WHERE idd=\"%i\" ORDER BY idd DESC",sendselection]];
        [self cargaanteriores];
        [self cargasiguientes];
    }
}
-(IBAction)Extract:(id)sender{
    //NSLog(@"Extraccion Lista");
    NSMutableDictionary *informacion=[[NSMutableDictionary alloc]init];
    [informacion setObject:@"JuezRev2" forKey:@"Acceso"];
    NSDictionary *informacion2=[NSDictionary dictionaryWithDictionary:informacion];
    NSError *error;
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:informacion2];
    [self.mySession sendData:myData toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataReliable error:&error];

}

-(void)sendselection1:(NSString*)sendselection titulo:(NSString*)titulo{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //INICIALIZACIONES
    valoresphp=[[NSMutableDictionary alloc]init];
    prefs = [NSUserDefaults standardUserDefaults];
    peercon=[[NSMutableArray alloc]init];
    peerstate=[[NSMutableDictionary alloc]init];
    conectados=[[NSDictionary alloc]init];
    sub=[[Subtitulados alloc]init];
    funa=[[Funciones alloc]init];
    arreglotimers=[[NSMutableArray alloc]init];
    totales=FALSE;

    //COMBOBOX
    CBJueces=[[ComboBox alloc]init];
    CBJueces.delegadocombo=self;
    [CBJueces setActivo:1];
    CBJueces.titulo=@"Juez";
    CBJueces.view.frame=IvCbJueces.frame;
    [self.view addSubview:CBJueces.view];
    
    /*CBRubros=[[ComboBox alloc]init];
    CBRubros.delegadocombo=self;
    [CBRubros setActivo:1];
    CBRubros.titulo=@"Rubro";
    CBRubros.view.frame=IvCbRubros.frame;
    [self.view addSubview:CBRubros.view];*/
    
    BDParticipantes=[[GestorBD alloc]initwithdatabases:[prefs objectForKey:@"Archivo"]];
    if ([[prefs objectForKey:@"Archivo"] isEqualToString:@"DirtConquers1.db"]) {
        NSArray *riders=[sub Riders];
        NSArray *banderas=[sub Banderas];
        NSArray *judges=[sub Judges];
        NSArray *rubros=[sub Rubros];
        //NSLog(@"%@%@%@%@",riders,banderas,judges,rubros);
        if ([riders count]>0) {
            for (int a=0; a<=[riders count]-1; a++) {
                NSArray *aPID=[NSArray arrayWithObjects:[NSString stringWithFormat:@"%i",a+1],[riders objectAtIndex:a],[banderas objectAtIndex:a],nil];
                [BDParticipantes saveinfo2:aPID val:@"BDN1AS" testigo:@"nombre" tabla:@"participantes" campo:@"nombre" nombre:[riders objectAtIndex:a] campo2:@"idd" nombre2:[NSString stringWithFormat:@"%i",a+1]];
            }
        }
        if ([rubros count]>0) {
            for (int a=0; a<=[rubros count]-1; a++) {
                NSArray *aRID=[NSArray arrayWithObjects:[NSString stringWithFormat:@"%i",a+1],[rubros objectAtIndex:a], nil];
                [BDParticipantes saveinfo2:aRID val:@"BDN1S" testigo:@"nombre" tabla:@"rubros" campo:@"nombre" nombre:[rubros objectAtIndex:a] campo2:@"idd" nombre2:[NSString stringWithFormat:@"%i",a+1]];
            }
        }
        if ([judges count]>0) {
            for (int a=0; a<=[judges count]-1; a++) {
                NSArray *aJID=[NSArray arrayWithObjects:[NSString stringWithFormat:@"%i",a+1],[judges objectAtIndex:a], nil];
                [BDParticipantes saveinfo2:aJID val:@"BDN1S" testigo:@"nombre" tabla:@"jueces" campo:@"nombre" nombre:[judges objectAtIndex:a] campo2:@"idd" nombre2:[NSString stringWithFormat:@"%i",a+1]];
            }
        }
        //NSLog(@"%@",[BDParticipantes getalltb:@"participantes" val:@"BDN1A"]);
    }
    
    //PREFERENCIAS
    if (![prefs stringForKey:@"Divisiones"]) {
        [prefs setObject:@"4" forKey:@"Divisiones"];
    }
    if (![prefs stringForKey:@"Cabecera"]) {
        [prefs setObject:@"Heat" forKey:@"Cabecera"];
        
    }
    if (![prefs objectForKey:@"Juez"]) {
        [prefs setObject:@"0" forKey:@"Juez"];
        CBJueces.view.hidden=FALSE;
    }
    else if([[prefs objectForKey:@"Juez"] isEqualToString:@"A"]){
        LaJuez.text=@"";
        CBJueces.view.hidden=FALSE;
    }
    else{
        LaJuez.text=[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT nombre FROM jueces WHERE idd=\"%i\"",[[prefs stringForKey:@"Juez"] intValue]]];
        CBJueces.view.hidden=TRUE;
    }
    if (![prefs stringForKey:@"Rubro"]) {
        [prefs setObject:@"0" forKey:@"Rubro"];
        CBRubros.view.hidden=FALSE;
    }
    else if([[prefs objectForKey:@"Rubro"] isEqualToString:@"A"]){
        LaRubro.text=@"";
        CBRubros.view.hidden=FALSE;
    }
    else{
        LaRubro.text=[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT nombre FROM rubros WHERE idd=\"%i\"",[[prefs stringForKey:@"Rubro"] intValue]]];
        CBRubros.view.hidden=TRUE;
    }
    [prefs synchronize];
    //NSLog(@"El Rubro es %@",[prefs objectForKey:@"Rubro"]);
    
    //DICCIONARIO
    [valoresphp setObject:@"0" forKey:@"Participante"];
    [valoresphp setObject:@"participantes" forKey:@"Lista"];
    [valoresphp setObject:@"Participantes" forKey:@"Titulo"];
    [valoresphp setObject:@"0" forKey:@"LocalPar"];
    [valoresphp setObject:@"0" forKey:@"LocalJue"];

    //CONFIGURACION ADICIONAL
    TfCabecera.text=[prefs objectForKey:@"Cabecera"];
    TfDivisiones.text=[prefs objectForKey:@"Divisiones"];
    LaSeleccion.text=[valoresphp objectForKey:@"Titulo"];

    LaEvParcial.text=@"";
    accesado=[prefs objectForKey:@"Accesado"];
    IvSeleccion.hidden=FALSE;

    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    
    if ([[prefs objectForKey:@"Accesado"] isEqualToString:@"1"]) {
        self.myPeerID.accessibilityLabel=@"Maestra";
    }
    if ([[prefs objectForKey:@"Accesado"] isEqualToString:@"2"]) {
        self.myPeerID.accessibilityLabel=@"Juez";
    }
    if ([[prefs objectForKey:@"Accesado"] isEqualToString:@"3"]) {
        self.myPeerID.accessibilityLabel=@"Pantalla";
    }
    [self setUpMultipeer];

    
    //CONFIGURACION
    Configuracion=[[TablaSeccionada alloc]init];
    Configuracion.view.frame =IvLista.frame;
    Configuracion.delegadotase=self;
    Configuracion.funcion=1;
    Configuracion.divisiones=[[prefs objectForKey:@"Divisiones"] intValue];
    Configuracion.cabecera=[prefs objectForKey:@"Cabecera"];
    [Configuracion setTamsubtit:12];
    [Configuracion setTamtit:20];
    [self.view addSubview:Configuracion.view];
    Configuracion.view.backgroundColor=[UIColor clearColor];

    //ANTERIORES
    Anteriores=[[BasicTable alloc]init];
    Anteriores.view.frame =IvTbAnteriores.frame;
    Anteriores.delegadobase=self;
    Anteriores.funcion=2;
    [Anteriores setTamsubtit:15];
    [Anteriores setTamtit:25];
    [self.view addSubview:Anteriores.view];
    Anteriores.view.backgroundColor=[UIColor clearColor];
    
    //SIGUIENTES
    Siguientes=[[TablaSeccionada alloc]init];
    Siguientes.view.frame =IvTbSiguientes.frame;
    Siguientes.delegadotase=self;
    Siguientes.funcion=3;
    Siguientes.divisiones=[[prefs objectForKey:@"Divisiones"] intValue];
    Siguientes.cabecera=[prefs objectForKey:@"Cabecera"];
    [Siguientes setTamsubtit:15];
    [Siguientes setTamtit:25];
    [self.view addSubview:Siguientes.view];
    Siguientes.view.backgroundColor=[UIColor clearColor];
    
    //CONEXIONES
    /*Conexiones=[[BasicTable alloc]init];
    Conexiones.view.frame =IvConectados.frame;
    Conexiones.delegadobase=self;
    Conexiones.funcion=1;
    [Conexiones setTamsubtit:12];
    [Conexiones setTamtit:20];
    //[self.view addSubview:Conexiones.view];
    Conexiones.view.backgroundColor=[UIColor clearColor];*/
    
    //Funcion 5
    ResultadosM=[[Resultados alloc]init];
    ResultadosM.view.frame =IvRonda.frame;
    ResultadosM.delegadores=self;
    ResultadosM.funcion=5;
    [self.view addSubview:ResultadosM.view];
    ResultadosM.view.backgroundColor=[UIColor clearColor];
 
    //RESULTADOS
    ResultadosGlobales=[[Resultados1 alloc]init];
    ResultadosGlobales.view.frame =IvTbResultados.frame;
    [self.view addSubview:ResultadosGlobales.view];
    ResultadosGlobales.view.backgroundColor=[UIColor clearColor];
    ResultadosGlobales.view.alpha=0;
    
    ResultadosRondas=[[Resultados1 alloc]init];
    ResultadosRondas.view.frame =IvTbResultados.frame;
    [self.view addSubview:ResultadosRondas.view];
    ResultadosRondas.view.backgroundColor=[UIColor clearColor];

    
    //INFORMACION TABLAS
    [self cargaanteriores];
    [self cargasiguientes];
    //[self cargarresultadosglobales];
    [self loadlastheatavailablerounds];
    
    NSArray *BDN1=[NSArray arrayWithObjects:@"Id",@"Idd",@"Nombre", nil];
    
    [Configuracion cargartablas:[sub titc1c2:[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY idd",[valoresphp objectForKey:@"Lista"]] val:BDN1] c1:@"Idd" c2:@"Nombre"]];
    
    [CBJueces setComboData:[sub titcbc1c2:[BDParticipantes getalltb:@"jueces" val:@"BDN1"] c1:@"Idd" c2:@"Nombre"]];
    [CBRubros setComboData:[sub titcbc1c2:[BDParticipantes getalltb:@"rubros" val:@"BDN1"] c1:@"Idd" c2:@"Nombre"]];
    

    ResultadosM.view.hidden=TRUE;
    
    IvDetalle.idd.text=@"";
    IvDetalle.Nombre.text=@"";
    IvDetalle.Calificacion.text=@"";
    IvDetalle.delegadodetalle=self;
    IvDetalle.Rubros=nil;
    TfUpdateLocalGrade.hidden=TRUE;
    BtSendUpdate.hidden=TRUE;
    BtSyncronizeAll.hidden=TRUE;
    Extract.hidden=TRUE;
    Syncronize.hidden=TRUE;
    BacktoList.hidden=TRUE;
}

-(void)cargaanteriores{
    NSArray *AIdNoRuCa=[NSArray arrayWithObjects:@"Idd",@"Nombre",@"Calificacion", nil];
    [valoresphp setObject:AIdNoRuCa forKey:@"AIdNoRuCa"];
    [Anteriores cargartablas:[sub idNoCag:[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT participantes.Idd,participantes.nombre,AVG(evaluacion.calificacion) FROM evaluacion INNER JOIN participantes ON participantes.id=evaluacion.participante GROUP BY participantes.nombre ORDER BY AVG(evaluacion.calificacion) DESC"] val:[valoresphp objectForKey:@"AIdNoRuCa"]] nombre:@"Nombre" Calificacion:@"Calificacion"]];
}
-(void)cargasiguientes{
    NSArray *arreglo=[NSArray arrayWithObjects:@"Idd",@"Participante", nil];
    [Siguientes cargartablas:[sub titc1c2:[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT participantes.idd,participantes.nombre FROM participantes WHERE NOT EXISTS (SELECT * FROM evaluacionlo WHERE evaluacionlo.participante = participantes.id AND evaluacionlo.rubro =\"%@\") ORDER BY idd",[prefs objectForKey:@"Rubro"]] val:arreglo] c1:@"Idd" c2:@"Participante"]];
}
-(void)cargarresultadosglobales:(int)start cantidad:(int)cantidad{
    NSLog(@"El inicial%i",start);
    NSArray *AParCal=[NSArray arrayWithObjects:@"Id",@"Participante",@"Calificacion",@"Bandera",nil];
    [valoresphp setObject:AParCal forKey:@"ArrParCal"];
    [ResultadosGlobales cargartablas:[sub idaiNoCaBa:[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT participantes.idd,participantes.nombre,AVG(evaluacion.calificacion),participantes.pais FROM evaluacion INNER JOIN participantes ON participantes.id=evaluacion.participante GROUP BY participantes.nombre ORDER BY AVG(evaluacion.calificacion) DESC"] val:[valoresphp objectForKey:@"ArrParCal"]] nombre:@"Participante" Calificacion:@"Calificacion" Bandera:@"Bandera" start:start]];
    //NSLog(@"Consulta%@",[sub idaiNoCaBa:[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT participantes.idd,participantes.nombre,AVG(evaluacion.calificacion),participantes.pais FROM evaluacion INNER JOIN participantes ON participantes.id=evaluacion.participante WHERE participantes.idd >%i GROUP BY participantes.nombre ORDER BY AVG(evaluacion.calificacion) DESC",start] val:[valoresphp objectForKey:@"ArrParCal"]] nombre:@"Participante" Calificacion:@"Calificacion" Bandera:@"Bandera" start:start]);
}

-(void)cargarresultadosrondas:(int)start cantidad:(int)cantidad{
    NSLog(@"ST %i CA %i",start, cantidad);
    NSArray *AIdParCal=[NSArray arrayWithObjects:@"Id",@"Participante",@"Calificacion",@"Bandera",nil];
    [valoresphp setObject:AIdParCal forKey:@"ArrIdParCal"];
    //NSLog(@"ST %@",[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT participantes.idd,participantes.nombre,AVG(evaluacion.calificacion),participantes.pais FROM evaluacion INNER JOIN participantes ON participantes.id=evaluacion.participante GROUP BY participantes.nombre ORDER BY AVG(evaluacion.calificacion) DESC"] val:[valoresphp objectForKey:@"ArrIdParCal"]]);
     //NSLog(@"ST2 %@",[sub idNoCaSC:[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT participantes.idd,participantes.nombre,AVG(evaluacion.calificacion),participantes.pais FROM evaluacion INNER JOIN participantes ON participantes.id=evaluacion.participante GROUP BY participantes.nombre ORDER BY AVG(evaluacion.calificacion) DESC"] val:[valoresphp objectForKey:@"ArrIdParCal"]] nombre:@"Participante" Calificacion:@"Calificacion" Bandera:@"Bandera" start:start cant:cantidad]);
    
    [ResultadosRondas cargartablas:[sub idNoCaSC:[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT participantes.idd,participantes.nombre,AVG(evaluacion.calificacion),participantes.pais FROM evaluacion INNER JOIN participantes ON participantes.id=evaluacion.participante GROUP BY participantes.nombre ORDER BY AVG(evaluacion.calificacion) DESC"] val:[valoresphp objectForKey:@"ArrIdParCal"]] nombre:@"Participante" Calificacion:@"Calificacion" Bandera:@"Bandera" start:start cant:cantidad]];
}

-(void)cargarresultadosm{
    NSArray *camposar=[NSArray arrayWithObjects:@"Participante",@"Calificacion",nil];
    [ResultadosM cargartablas:[sub idaiNoCa:[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT participantes.nombre,AVG(evaluacion.calificacion) FROM evaluacion INNER JOIN participantes ON participantes.id=evaluacion.participante GROUP BY participantes.nombre ORDER BY AVG(evaluacion.calificacion) DESC"] val:camposar] nombre:@"Participante" Calificacion:@"Calificacion" informacion:[self califadiscordia]]];
}

-(void)cargarDetalle:(NSString*)id1{
    NSArray *arreglo1=[NSArray arrayWithObjects:@"Id",@"Juez",@"Participante",@"Rubro",@"Calificacion", nil];
    [IvDetalle cargartablas:[self ComplementJudgesDictionary:[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT jueces.id, jueces.nombre,buffer.participante,rubros.nombre,calificacion FROM buffer INNER JOIN jueces ON jueces.idd=buffer.juez INNER JOIN rubros ON rubros.idd=buffer.rubro WHERE participante=\"%@\" ORDER BY jueces.id ASC",id1] val:arreglo1]par:id1] campos:arreglo1];
}
-(NSString*)califadiscordia{
    //NSLog(@"QUien Soy %@",[prefs objectForKey:@"Participante"]);
    NSString *califa=[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT AVG(calificacion) FROM buffer WHERE participante=\"%@\" GROUP BY participante",[prefs objectForKey:@"Participante"]]];
    //NSLog(@"Califa Discordia%@",califa);
    return califa;
}

//GLOBALES SALIDA
-(IBAction)Desactivado:(id)sender{
    if ([TfPassword.text isEqualToString:@"Salida"]){
        [prefs setObject:@"0" forKey:@"Accesado"];
        CBJueces.view.hidden=FALSE;
        CBRubros.view.hidden=FALSE;
        BtGuardar.hidden=FALSE;
        TfPassword.text=@"";
        [prefs setObject:@"A" forKey:@"Juez"];
        [prefs setObject:@"A" forKey:@"Rubro"];
        [prefs synchronize];
        [self.delegadojuez JudgeDidFinish:self];
    }
    else if ([TfPassword.text isEqualToString:@"Clean"]){
        //NSLog(@"Limpio");
        [BDParticipantes renewal:@"evaluacion" tablas:@"EVALUACION"];
        [BDParticipantes renewal:@"evaluacionlo" tablas:@"EVALUACIONLO"];
        [BDParticipantes renewal:@"buffer" tablas:@"BUFFER"];
        TfPassword.text=@"";
        dispatch_async(dispatch_get_main_queue(), ^{
        [self cargaanteriores];
        [self cargasiguientes];
        //[self cargarresultadosglobales];
        [self loadlastheatavailablerounds];
        [self cargarresultadosm];
        [self buferinfo];
        [self visibilidad];
        });
    }
    else if ([TfPassword.text isEqualToString:@"Purgar"]){
        //NSLog(@"PURGADO");
        TfPassword.text=@"";
        [self Purgar:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
        [self cargaanteriores];
        [self cargasiguientes];
        [self cargarresultadosm];
        [self buferinfo];
        [self visibilidad];
        });
    }
    else if ([TfPassword.text isEqualToString:@"Finales"]){
        //NSLog(@"Finales");
        TfPassword.text=@"";
        [self ProximaEliminatoria:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self cargaanteriores];
            [self cargasiguientes];
            [self cargarresultadosm];
            [self buferinfo];
            [self visibilidad];
        });
    }
    else if ([TfPassword.text isEqualToString:@"Sincronizar"]){
        TfPassword.text=@"";
        [self Syncronizeall:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self cargaanteriores];
            [self cargasiguientes];
            [self cargarresultadosm];
            [self buferinfo];
            [self visibilidad];
        });
    }
    else if ([TfPassword.text isEqualToString:@"Extraer"]){
        TfPassword.text=@"";
        [self Extract:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self cargaanteriores];
            [self cargasiguientes];
            [self cargarresultadosm];
            [self buferinfo];
            [self visibilidad];
        });
    }
    else if ([TfPassword.text isEqualToString:@"Reset"]){
        TfPassword.text=@"";
        [self restart];
        [self clean];
        [self purge];
        BDParticipantes=[[GestorBD alloc]initwithdatabases:@"DirtConquers1.db"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self cargaanteriores];
            [self cargasiguientes];
            [self cargarresultadosm];
            [self buferinfo];
            [self visibilidad];
        });
    }


}

-(void)clean{
    GestorBD *DBfinales=[[GestorBD alloc]initwithdatabases:@"DirtConquers1.db"];
    [DBfinales renewal:@"buffer" tablas:@"BUFFER"];
    [DBfinales renewal:@"evaluacion" tablas:@"EVALUACION"];
    [DBfinales renewal:@"evaluacionlo" tablas:@"EVALUACIONLO"];
}
-(void)purge{
    GestorBD *DBfinales1=[[GestorBD alloc]initwithdatabases:@"DirtConquersFinals1.db"];
    [DBfinales1 renewal:@"participantes" tablas:@"PARTICIPANTES"];
    [DBfinales1 renewal:@"jueces" tablas:@"JUECES"];
    [DBfinales1 renewal:@"rubros" tablas:@"RUBROS"];
    [DBfinales1 renewal:@"evaluacion" tablas:@"EVALUACION"];
    [DBfinales1 renewal:@"evaluacionlo" tablas:@"EVALUACIONLO"];
    [DBfinales1 renewal:@"buffer" tablas:@"BUFFER"];
}
-(void)restart{
    NSMutableDictionary *informacion=[[NSMutableDictionary alloc]init];
    [informacion setObject:@"CleanThemAll" forKey:@"Acceso"];
    NSDictionary *informacion2=[NSDictionary dictionaryWithDictionary:informacion];
    NSError *error;
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:informacion2];
[self.mySession sendData:myData toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataReliable error:&error];
}

//RELOAD CONFIGURACION
-(void)visibilidad{
    NSArray *BDN1=[NSArray arrayWithObjects:@"Id",@"Idd",@"Nombre", nil];
    [Configuracion cargartablas:[sub titc1c2:[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY idd",[valoresphp objectForKey:@"Lista"]] val:BDN1] c1:@"Idd" c2:@"Nombre"]];
}
//PRIMER SCREEN
-(IBAction)Participante:(id)sender{
    [valoresphp setObject:@"participantes" forKey:@"Lista"];
    [valoresphp setObject:@"Participantes" forKey:@"Titulo"];
    Configuracion.divisiones=[[prefs objectForKey:@"Divisiones"] intValue];
    Configuracion.cabecera=[prefs objectForKey:@"Cabecera"];
    LaSeleccion.text=[valoresphp objectForKey:@"Titulo"];
    [self visibilidad];
    
}
-(IBAction)Juez:(id)sender{
    [valoresphp setObject:@"jueces" forKey:@"Lista"];
    [valoresphp setObject:@"Jueces" forKey:@"Titulo"];
    Configuracion.divisiones=0;
    Configuracion.cabecera=@"";
    LaSeleccion.text=[valoresphp objectForKey:@"Titulo"];
    [self visibilidad];
    
}
-(IBAction)Rubros:(id)sender{
    [valoresphp setObject:@"rubros" forKey:@"Lista"];
    [valoresphp setObject:@"Rubros" forKey:@"Titulo"];
    Configuracion.divisiones=0;
    Configuracion.cabecera=@"";
    LaSeleccion.text=[valoresphp objectForKey:@"Titulo"];
    [self visibilidad];
    
}
//CONFIGURACION LISTAS
-(IBAction)Nuevo:(id)sender{
    if (![TfCampo.text isEqualToString:@""]) {
        NSDictionary *valores=[BDParticipantes getalltb:[valoresphp objectForKey:@"Lista"] val:@"BDN1"];
        NSString *idmm=[NSString stringWithFormat:@"%i",[self getmaxid:valores valor:@"Idd"]];
        NSArray *info=[NSArray arrayWithObjects:idmm,TfCampo.text, nil];
        [BDParticipantes saveinfo:info val:@"BDN1S" testigo:@"nombre" tabla:[valoresphp objectForKey:@"Lista"] campo:@"nombre" nombre:TfCampo.text];
        [self visibilidad];
        TfCampo.text=@"";
    }
}
-(IBAction)Modificar:(id)sender{
    if (![TfCampo.text isEqualToString:@""]) {
        [BDParticipantes updateinfo:[NSString stringWithFormat:@"UPDATE %@ SET nombre=\"%@\" WHERE idd=\"%@\"",[valoresphp objectForKey:@"Lista"],TfCampo.text,[valoresphp objectForKey:@"Modificar"]]];
        [self visibilidad];
    }
    TfCampo.text=@"";
}
-(IBAction)Borrar:(id)sender{
    if (![TfCampo.text isEqualToString:@""]) {
        [BDParticipantes updateinfo:[NSString stringWithFormat:@"DELETE FROM %@ WHERE idd=\"%@\"",[valoresphp objectForKey:@"Lista"],[valoresphp objectForKey:@"Modificar"]]];
        int iddi=[[valoresphp objectForKey:@"Modificar"] intValue];
        NSMutableArray *cambioids=[[NSMutableArray alloc]init];
        NSDictionary *total=[BDParticipantes getalltb:[valoresphp objectForKey:@"Lista"] val:@"BDN1"];
        NSArray *aidd=[total objectForKey:@"Idd"];
        NSArray *aid=[total objectForKey:@"Id"];
        if ([aidd count]>0) {
            for (int a=0; a<=[aidd count]-1; a++) {
                if ([[aidd objectAtIndex:a]intValue]>iddi) {
                    [cambioids addObject:[aid objectAtIndex:a]];
                }
            }
        }
        NSArray *acambioids=[NSArray arrayWithArray:cambioids];
        if ([acambioids count]>0) {
            for (int a=0; a<=[acambioids count]-1; a++) {
                NSString *iddd=[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT idd FROM %@ WHERE id=\"%@\"",[valoresphp objectForKey:@"Lista"],[acambioids objectAtIndex:a]]];
                [BDParticipantes updateinfo:[NSString stringWithFormat:@"UPDATE %@ SET idd=\"%@\" WHERE id=\"%@\"",[valoresphp objectForKey:@"Lista"],[NSString stringWithFormat:@"%i",[iddd intValue]-1],[acambioids objectAtIndex:a]]];
            }
        }
    }
    [self visibilidad];
    TfCampo.text=@"";
}
-(NSString*)rankingLocal:(NSString*)participante juez:(NSString*)juez{
    //NSLog(@"Nombre Participante %@,%@",participante ,juez);
    NSString *juezid=[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT id FROM jueces WHERE nombre=\"%@\"",juez]];
    
    NSString *ranking=@"0";
    NSArray *ARanking=[NSArray arrayWithObjects:@"Juez",@"Nombre", nil];
    NSDictionary *overallranking=[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT juez,participante FROM buffer WHERE juez=\"%@\" ORDER BY calificacion DESC",juezid] val:ARanking];
    
    NSArray *nombres=[overallranking objectForKey:@"Nombre"];
    //NSLog(@"Info Overall %@",nombres);
    int a=0;
    if ([nombres count]>0) {
    for (int b=0; b<=[nombres count]-1; b++) {
            if ([[nombres objectAtIndex:b] isEqualToString:participante]) {
                ranking=[NSString stringWithFormat:@"%i",a+1];
                
            }
            a++;
    }
    }
    
    
    return ranking;
}
-(IBAction)updatelocalgrade:(id)sender{
    if (![[valoresphp objectForKey:@"LocalPar"] isEqualToString:@"0"]) {
        if (![[valoresphp objectForKey:@"LocalJue"] isEqualToString:@"0"]) {
            if (![TfUpdateLocalGrade.text isEqualToString:@"0"]) {
                //NSLog(@"Valores para Obtener%@_%@_%@",[valoresphp objectForKey:@"LocalPar"],[valoresphp objectForKey:@"LocalJue"],TfUpdateLocalGrade.text);
                //NSString *nrubro=[valoresphp objectForKey:@"LocalJue"];
                NSArray *informacion=[NSArray arrayWithObjects:[valoresphp objectForKey:@"LocalJue"],[valoresphp objectForKey:@"LocalPar"],[valoresphp objectForKey:@"LocalJue"],TfUpdateLocalGrade.text,@"0",nil];
                //NSArray *informacion2=[NSArray arrayWithObjects:[valoresphp objectForKey:@"LocalJue"],[valoresphp objectForKey:@"LocalPar"],[valoresphp objectForKey:@"LocalJue"],TfUpdateLocalGrade.text,nil];
                [BDParticipantes saveinfo2update:informacion val:@"BDBUFS" testigo:@"participante" tabla:@"buffer" campo:@"juez" nombre:[valoresphp objectForKey:@"LocalJue"] campo2:@"participante" nombre2:[valoresphp objectForKey:@"LocalPar"] cupdate:@"calificacion" vupdate:TfUpdateLocalGrade.text];
                //[BDParticipantes saveinfo2update:informacion2 val:@"BDEVS" testigo:@"participante" tabla:@"evaluacion" campo:@"juez" nombre:[valoresphp objectForKey:@"LocalJue"] campo2:@"participante" nombre2:[valoresphp objectForKey:@"LocalPar"] cupdate:@"calificacion" vupdate:TfUpdateLocalGrade.text];
                //[self sendCalificacion2:[valoresphp objectForKey:@"LocalJue"] Participante:[valoresphp objectForKey:@"LocalPar"] Rubro:nrubro Calificacion:[TfUpdateLocalGrade.text floatValue]];
            }
        }
    }
    [self cargarresultadosm];

    [self buferinfo];
}
//SUBIR BAJAR INFO
-(IBAction)Subir:(id)sender{
    if ([[valoresphp objectForKey:@"Modificar"]intValue]>1) {
        NSString *idd1=[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT id FROM %@ WHERE idd=\"%@\"",[valoresphp objectForKey:@"Lista"],[NSString stringWithFormat:@"%i",[[valoresphp objectForKey:@"Modificar"] intValue]-1]]];
        NSString *idd2=[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT id FROM %@ WHERE idd=\"%@\"",[valoresphp objectForKey:@"Lista"],[valoresphp objectForKey:@"Modificar"]]];
        [BDParticipantes updateinfo:[NSString stringWithFormat:@"UPDATE %@ SET idd=\"%@\" WHERE id=\"%@\"",[valoresphp objectForKey:@"Lista"],[valoresphp objectForKey:@"Modificar"],idd1]];
        [BDParticipantes updateinfo:[NSString stringWithFormat:@"UPDATE %@ SET idd=\"%@\" WHERE id=\"%@\"",[valoresphp objectForKey:@"Lista"],[NSString stringWithFormat:@"%i",[[valoresphp objectForKey:@"Modificar"] intValue]-1],idd2]];
        [valoresphp setObject:[NSString stringWithFormat:@"%i",[[valoresphp objectForKey:@"Modificar"] intValue]-1] forKey:@"Modificar"];
    }
    [self visibilidad];
}
-(IBAction)Bajar:(id)sender{
    NSDictionary *info=[BDParticipantes getalltb:[valoresphp objectForKey:@"Lista"] val:@"BDN1"];
    NSArray *ainfo=[info objectForKey:@"Idd"];
    if ([ainfo count]>0) {
        if ([[valoresphp objectForKey:@"Modificar"]intValue]<[ainfo count]) {
            NSString *idd1=[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT id FROM %@ WHERE idd=\"%@\"",[valoresphp objectForKey:@"Lista"],[NSString stringWithFormat:@"%i",[[valoresphp objectForKey:@"Modificar"] intValue]+1]]];
            NSString *idd2=[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT id FROM %@ WHERE idd=\"%@\"",[valoresphp objectForKey:@"Lista"],[valoresphp objectForKey:@"Modificar"]]];
            [BDParticipantes updateinfo:[NSString stringWithFormat:@"UPDATE %@ SET idd=\"%@\" WHERE id=\"%@\"",[valoresphp objectForKey:@"Lista"],[valoresphp objectForKey:@"Modificar"],idd1]];
            [BDParticipantes updateinfo:[NSString stringWithFormat:@"UPDATE %@ SET idd=\"%@\" WHERE id=\"%@\"",[valoresphp objectForKey:@"Lista"],[NSString stringWithFormat:@"%i",[[valoresphp objectForKey:@"Modificar"] intValue]+1],idd2]];
            [valoresphp setObject:[NSString stringWithFormat:@"%i",[[valoresphp objectForKey:@"Modificar"] intValue]+1] forKey:@"Modificar"];
        }
    }
    [self visibilidad];
}
//DIVIDIR INFO
-(IBAction)Dividir:(id)sender{
    [prefs setObject:TfCabecera.text forKey:@"Cabecera"];
    [prefs setObject:TfDivisiones.text forKey:@"Divisiones"];
    [prefs synchronize];
    NSString *cabtem=[prefs objectForKey:@"Cabecera"];
    int divtem=[[prefs objectForKey:@"Divisiones"] intValue];
    Configuracion.cabecera=cabtem;
    Configuracion.divisiones=divtem;
    Siguientes.cabecera=cabtem;
    Siguientes.divisiones=divtem;
    NSArray *BDN1=[NSArray arrayWithObjects:@"Id",@"Idd",@"Nombre", nil];
    [Configuracion cargartablas:[sub titc1c2:[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY idd",[valoresphp objectForKey:@"Lista"]] val:BDN1] c1:@"Idd" c2:@"Nombre"]];
    [self cargaanteriores];
    [self cargasiguientes];
    
}

-(IBAction)BackList:(id)sender{
    [self buferinfo];
}
-(IBAction)Edicion:(id)sender{
    LaSeleccion.hidden=FALSE;
    BtParticipantes.hidden=FALSE;
    BtJueces.hidden=FALSE;
    BtRubros.hidden=FALSE;
    BtNuevo.hidden=FALSE;
    BtModificar.hidden=FALSE;
    BtBorrar.hidden=FALSE;
    TfCampo.hidden=FALSE;
    TfCabecera.hidden=FALSE;
    TfDivisiones.hidden=FALSE;
    BtDividir.hidden=FALSE;
    //BtSubir.hidden=FALSE;
    //BtBajar.hidden=FALSE;
    Configuracion.view.hidden=FALSE;
    //RondasM.view.hidden=TRUE;
    ResultadosM.view.hidden=TRUE;
    LaSeleccion.text=[valoresphp objectForKey:@"Titulo"];
    IvDetalle.hidden=TRUE;
    TfUpdateLocalGrade.hidden=TRUE;
    BtSendUpdate.hidden=TRUE;
    //UpdateOrder.hidden=FALSE;
    IvLista.hidden=FALSE;
    BtSyncronizeAll.hidden=TRUE;
    Extract.hidden=TRUE;
    Syncronize.hidden=TRUE;
    BacktoList.hidden=TRUE;
    
    [self.view bringSubviewToFront:IvLista];

}
-(IBAction)Monitoreo:(id)sender{
    LaSeleccion.hidden=TRUE;
    BtParticipantes.hidden=TRUE;
    BtJueces.hidden=TRUE;
    BtRubros.hidden=TRUE;
    BtNuevo.hidden=TRUE;
    BtModificar.hidden=TRUE;
    BtBorrar.hidden=TRUE;
    TfCampo.hidden=TRUE;
    TfCabecera.hidden=TRUE;
    TfDivisiones.hidden=TRUE;
    BtDividir.hidden=TRUE;
    BtSubir.hidden=TRUE;
    BtBajar.hidden=TRUE;
    Configuracion.view.hidden=TRUE;
    //RondasM.view.hidden=FALSE;
    ResultadosM.view.hidden=FALSE;
    IvDetalle.hidden=FALSE;
    TfUpdateLocalGrade.hidden=FALSE;
    BtSendUpdate.hidden=FALSE;
    UpdateOrder.hidden=TRUE;
    IvLista.hidden=TRUE;
    //BtSyncronizeAll.hidden=FALSE;
    Extract.hidden=FALSE;
    Syncronize.hidden=FALSE;
    BacktoList.hidden=FALSE;
    [self.view bringSubviewToFront:IvDetalle];
    [self cargarresultadosm];
    /*NSArray *rondasar=[NSArray arrayWithObjects:@"Id",@"Participante",@"Calificacion",nil];
    [RondasM cargartablas:[sub idNoCa:[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT participantes.idd,participantes.nombre,AVG(evaluacion.calificacion) FROM evaluacion INNER JOIN participantes ON participantes.id=evaluacion.participante GROUP BY participantes.nombre ORDER BY MAX(evaluacion.id) DESC"] val:rondasar] nombre:@"Participante" Calificacion:@"Calificacion"]];*/
    [self buferinfo];
    

}
-(void)buferinfo{
    //GENERA VISIBILIDAD BUFFER
    NSArray *participa=[NSArray arrayWithObjects:@"participante", nil];
    NSDictionary *buffervaluesdic=[BDParticipantes getselecteddatast:@"SELECT participante FROM buffer WHERE aprobado=0 ORDER BY participante ASC" val:participa];
    NSArray *buffervalues=[buffervaluesdic objectForKey:@"participante"];
    if ([buffervalues count]>0) {
        //NSLog(@" APROVED %@",[buffervalues objectAtIndex:0]);
    }
    //NSDictionary *rbuffer=[BDParticipantes getalltb:@"buffer" val:@"BDBUF"];
    //NSLog(@"%@_%@",rbuffer,buffervalues);
    if ([buffervalues count]==0) {
        NSDictionary *buffervaluesdic2=[BDParticipantes getselecteddatast:@"SELECT participante FROM buffer ORDER BY participante DESC LIMIT 1" val:participa];
        NSArray *buffervalues2=[buffervaluesdic2 objectForKey:@"participante"];
        NSString* id1=@"";
        if ([buffervalues2 count]>0) {
            id1=[NSString stringWithFormat:@"%i",[[buffervalues2 objectAtIndex:0] intValue]+1];
            [valoresphp setObject:id1 forKey:@"Party"];
            [prefs setObject:id1 forKey:@"Participante"];
            [prefs synchronize];
        }else{
            id1=[NSString stringWithFormat:@"%i",1];
            [valoresphp setObject:id1 forKey:@"Party"];
            [prefs setObject:id1 forKey:@"Participante"];
            [prefs synchronize];
        }
        
        [prefs setObject:id1 forKey:@"Participante"];
        [prefs synchronize];
        NSString *idd=[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT idd FROM participantes WHERE id=\"%@\"",id1]];
        NSString *nombre=[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT nombre FROM participantes WHERE id=\"%@\"",id1]];
        //NSLog(@"id%@ ,nombre%@",idd,nombre);
        IvDetalle.idd.text=idd;
        IvDetalle.Nombre.text=nombre;
        if ([idd intValue]>0) {
            IvDetalle.Calificacion.text=@"00";
            IvDetalle.colorcalificacion=[UIColor whiteColor];
        }
        NSArray *arreglo1=[NSArray arrayWithObjects:@"Id",@"Juez",@"Participante",@"Rubro",@"Calificacion", nil];
        [IvDetalle cargartablas:[self ComplementJudgesDictionary:nil par:id1] campos:arreglo1];
        [valoresphp setObject:@"0" forKey:@"LocalPar"];
        [valoresphp setObject:@"0" forKey:@"LocalJue"];
        TfUpdateLocalGrade.text=@"";
        
    }
    else {
        NSString *id1=[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT participante FROM buffer WHERE participante=\"%@\" ORDER BY id ASC LIMIT 1",[buffervalues objectAtIndex:0]]];
        //NSLog(@"IDD,%@",id1);
        [valoresphp setObject:id1 forKey:@"Party"];
        [prefs setObject:id1 forKey:@"Participante"];
        [prefs synchronize];
        NSString *idd=[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT idd FROM participantes WHERE id=\"%@\"",id1]];
        NSString *nombre=[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT nombre FROM participantes WHERE id=\"%@\"",id1]];
        IvDetalle.idd.text=idd;
        IvDetalle.Nombre.text=nombre;
        if ([idd intValue]>0) {
            IvDetalle.Calificacion.text=[NSString stringWithFormat:@"%.2f",[[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT AVG(calificacion) FROM buffer WHERE participante=\"%@\"",id1]] floatValue]];
            IvDetalle.colorcalificacion=[self ColorCalifa:[NSString stringWithFormat:@"%.2f",[[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT AVG(calificacion) FROM buffer WHERE participante=\"%@\"",id1]] floatValue]]];
        }
        [self cargarDetalle:id1];
        [valoresphp setObject:@"0" forKey:@"LocalPar"];
        [valoresphp setObject:@"0" forKey:@"LocalJue"];
        TfUpdateLocalGrade.text=@"";
    }
}
-(NSDictionary*)ComplementJudgesDictionary:(NSDictionary*)com par:(NSString*)par{

    NSArray *jueces=[com objectForKey:@"Juez"];
    NSArray *jid=[com objectForKey:@"Id"];
    NSArray *jpar=[com objectForKey:@"Participante"];
    NSArray *jrub=[com objectForKey:@"Rubro"];
    NSArray *jcal=[com objectForKey:@"Calificacion"];
    NSDictionary *alljueces=[BDParticipantes getalltb:@"jueces" val:@"BDN1"];
    
    if ([jueces count]<[[alljueces objectForKey:@"Id"] count]) {
        NSMutableDictionary *nexjueces=[[NSMutableDictionary alloc]init];
        NSMutableArray *maidd=[[NSMutableArray alloc]init];
        NSMutableArray *majuez=[[NSMutableArray alloc]init];
        NSMutableArray *maparticipante=[[NSMutableArray alloc]init];
        NSMutableArray *marubro=[[NSMutableArray alloc]init];
        NSMutableArray *macalificacion=[[NSMutableArray alloc]init];
        if ([jueces count]>0) {
            for (int a=0; a<=[jueces count]-1; a++) {
                [maidd addObject:[jid objectAtIndex:a]];
                [majuez addObject:[jueces objectAtIndex:a]];
                [maparticipante addObject:[jpar objectAtIndex:a]];
                [marubro addObject:[jrub objectAtIndex:a]];
                [macalificacion addObject:[jcal objectAtIndex:a]];
            }
        }
        NSArray *arallJueces=[alljueces objectForKey:@"Nombre"];
        NSArray *idJueces=[alljueces objectForKey:@"Idd"];
        for (int e=0;e<=[arallJueces count]-1; e++) {
            int a=0;
            if ([jueces count]>0) {
                for (int d=0; d<=[jueces count]-1; d++) {
                    if ([[arallJueces objectAtIndex:e] isEqualToString:[jueces objectAtIndex:d]]) {
                        a=1;
                    }
                }
            }
            if (a==0) {
                [maidd addObject:[idJueces objectAtIndex:e]];
                [majuez addObject:[arallJueces objectAtIndex:e]];
                [maparticipante addObject:par];
                [marubro addObject:@"0"];
                [macalificacion addObject:@"0"];
            }
        }
        NSArray *aidd=[NSArray arrayWithArray:maidd];
        NSArray *ajuez=[NSArray arrayWithArray:majuez];
        NSArray *aparticipante=[NSArray arrayWithArray:maparticipante];
        NSArray *arubro=[NSArray arrayWithArray:marubro];
        NSArray *acalificacion=[NSArray arrayWithArray:macalificacion];
        [nexjueces setObject:aidd forKey:@"Id"];
        [nexjueces setObject:ajuez forKey:@"Juez"];
        [nexjueces setObject:aparticipante forKey:@"Participante"];
        [nexjueces setObject:arubro forKey:@"Rubro"];
        [nexjueces setObject:acalificacion forKey:@"Calificacion"];
        NSDictionary *nextfinal=[NSDictionary dictionaryWithDictionary:nexjueces];
        return nextfinal;
    }
    else{
        return com;
    }

}

//PURGAR BD
-(IBAction)Purgar:(id)sender{
    [BDParticipantes renewal:@"participantes" tablas:@"PARTICIPANTES"];
    [BDParticipantes renewal:@"jueces" tablas:@"JUECES"];
    [BDParticipantes renewal:@"rubros" tablas:@"RUBROS"];
    [BDParticipantes renewal:@"evaluacion" tablas:@"EVALUACION"];
    [BDParticipantes renewal:@"evaluacionlo" tablas:@"EVALUACIONLO"];
    [BDParticipantes renewal:@"buffer" tablas:@"BUFFER"];
    [CBJueces setComboData:[sub titcbc1c2:[BDParticipantes getalltb:@"jueces" val:@"BDN1"] c1:@"Idd" c2:@"Nombre"]];
    [CBRubros setComboData:[sub titcbc1c2:[BDParticipantes getalltb:@"rubros" val:@"BDN1"] c1:@"Idd" c2:@"Nombre"]];
    NSArray *BDN1=[NSArray arrayWithObjects:@"Id",@"Idd",@"Nombre", nil];
    [Configuracion cargartablas:[sub titc1c2:[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY idd",[valoresphp objectForKey:@"Lista"]] val:BDN1] c1:@"Idd" c2:@"Nombre"]];
}

//SEGUNDO SCREEN
-(IBAction)Guardar:(id)sender{
    CBJueces.view.hidden=TRUE;
    CBRubros.view.hidden=TRUE;
    BtGuardar.hidden=TRUE;
    [prefs setObject:[NSString stringWithFormat:@"%i",[CBJueces.selectedText intValue]] forKey:@"Juez"];
    [prefs setObject:[NSString stringWithFormat:@"%i",[CBJueces.selectedText intValue]] forKey:@"Rubro"];
}
-(IBAction)BorrarP:(id)sender{
    LaEvParcial.text=@"";
}
- (IBAction)calificacion:(id)sender {
    UIButton * PressedButton = (UIButton*)sender;
    switch(PressedButton.tag)
    {
        case 1:
            [self escribecalif:1];
            break;
        case 2:
            [self escribecalif:2];
            break;
        case 3:
            [self escribecalif:3];
            break;
        case 4:
            [self escribecalif:4];
            break;
        case 5:
            [self escribecalif:5];
            break;
            
        case 6:
            [self escribecalif:6];
            break;
        case 7:
            [self escribecalif:7];
            break;
        case 8:
            [self escribecalif:8];
            break;
        case 9:
            [self escribecalif:9];
            break;
        case 0:
            [self escribecalif:0];
            break;
    }
}
-(void)escribecalif:(int)cali{
    if (LaEvParcial.text.length==4) {
        NSString* ultimos2=[NSString stringWithFormat:@"%i",[[LaEvParcial.text substringWithRange:NSMakeRange(1, 1)] intValue]];
        NSString* ultimos3=[NSString stringWithFormat:@"%i",[[LaEvParcial.text substringWithRange:NSMakeRange(3, 1)] intValue]];
        LaEvParcial.text=[NSString stringWithFormat:@"%@%@.%i",ultimos2,ultimos3,cali];
    }
    if (LaEvParcial.text.length==3) {
        NSString* ultimos2=[NSString stringWithFormat:@"%i",[[LaEvParcial.text substringWithRange:NSMakeRange(0, 1)] intValue]];
        NSString* ultimos3=[NSString stringWithFormat:@"%i",[[LaEvParcial.text substringWithRange:NSMakeRange(2, 1)] intValue]];
        LaEvParcial.text=[NSString stringWithFormat:@"%@%@.%i",ultimos2,ultimos3,cali];
    }
    else if (LaEvParcial.text.length==1) {
        LaEvParcial.text=[NSString stringWithFormat:@"%@.%i",LaEvParcial.text,cali];
    }
    else if (LaEvParcial.text.length==0) {
        LaEvParcial.text=[NSString stringWithFormat:@"%i",cali];
    }
}
-(IBAction)EnviarP:(id)sender{
    if (![[prefs objectForKey:@"Juez"] isEqualToString:@"0"]) {
        if (![[valoresphp objectForKey:@"Participante"] isEqualToString:@"0"]) {
            if (![[prefs objectForKey:@"Rubro"] isEqualToString:@"0"]) {
                if ([LaEvParcial.text floatValue]>=10) {
                    NSArray *arreglo=[NSArray arrayWithObjects:@"Idd",@"Participante", nil];
                NSDictionary *grader=[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT participantes.idd,participantes.nombre FROM participantes WHERE NOT EXISTS (SELECT * FROM evaluacionlo WHERE evaluacionlo.participante = participantes.id AND evaluacionlo.rubro =\"%@\") ORDER BY idd",[prefs objectForKey:@"Rubro"]] val:arreglo];
                NSString *iddendiscordia=[[grader objectForKey:@"Idd"] objectAtIndex:0];
                if ([[valoresphp objectForKey:@"Participante"] isEqualToString:iddendiscordia]) {
                NSString *nombre=[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT id FROM participantes WHERE idd=\"%@\"",[valoresphp objectForKey:@"Participante"]]];
                NSArray *info=[NSArray arrayWithObjects:[prefs objectForKey:@"Juez"],nombre,[prefs objectForKey:@"Rubro"],LaEvParcial.text, nil];
                if ([[valoresphp objectForKey:@"Funcion"] isEqualToString:@"3"]) {
                    [BDParticipantes saveinfo2:info val:@"BDEVS" testigo:@"participante" tabla:@"evaluacionlo" campo:@"participante" nombre:nombre campo2:@"juez" nombre2:[prefs objectForKey:@"Juez"]];
                    //[BDParticipantes saveinfo2:info val:@"BDEVS" testigo:@"participante" tabla:@"evaluacion" campo:@"participante" nombre:nombre campo2:@"juez" nombre2:[prefs objectForKey:@"Juez"]];
                }
                else {
                    NSString *nid=[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT id FROM participantes WHERE idd=\"%@\"",[valoresphp objectForKey:@"Participante"]]];
                    [BDParticipantes updateinfo:[NSString stringWithFormat:@"UPDATE evaluacionlo SET calificacion=\"%@\" WHERE participante=\"%@\" AND juez=\"%@\"",LaEvParcial.text,nid,[prefs objectForKey:@"Juez"]]];
                    //[BDParticipantes updateinfo:[NSString stringWithFormat:@"UPDATE evaluacion SET calificacion=\"%@\" WHERE participante=\"%@\" AND juez=\"%@\"",LaEvParcial.text,nid,[prefs objectForKey:@"Juez"]]];
                }
                [self sendCalificacion:[prefs objectForKey:@"Juez"] Participante:[valoresphp objectForKey:@"Participante"] Rubro:[prefs objectForKey:@"Rubro"] Calificacion:[LaEvParcial.text floatValue]];
                }
                }
            }}}
    LaEvParcial.text=@"";
    [self cargasiguientes];
}

//Envia Calificacion Jueces
- (void) sendCalificacion:(NSString*)Juez Participante:(NSString*)Participante Rubro:(NSString*)Rubro Calificacion:(float)Calificacion{
    
    NSMutableArray *informacion=[[NSMutableArray alloc]init];
    [informacion addObject:Juez];
    //NSLog(@"Participante%@",Participante);
    [informacion addObject:Participante];
    [informacion addObject:Rubro];
    [informacion addObject:[NSString stringWithFormat:@"%.2f",Calificacion]];

    NSArray *info=[NSArray arrayWithArray:informacion];
    NSMutableDictionary *diccionario=[[NSMutableDictionary alloc]init];
    [diccionario setObject:info forKey:@"Informacion"];
    [diccionario setObject:@"Dato" forKey:@"Acceso"];
    NSDictionary *dfinal=[NSDictionary dictionaryWithDictionary:diccionario];
    //NSLog(@"Envio de Info%@",informacion);
    NSError *error;
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:dfinal];
    [self.mySession sendData:myData toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataReliable error:&error];
}
//Envia Calificacion Modificada
- (void) sendCalificacion2:(NSString*)Juez Participante:(NSString*)Participante Rubro:(NSString*)Rubro Calificacion:(float)Calificacion{
    
    NSMutableArray *informacion=[[NSMutableArray alloc]init];
    [informacion addObject:Juez];
    [informacion addObject:Participante];
    [informacion addObject:Rubro];
    [informacion addObject:[NSString stringWithFormat:@"%.2f",Calificacion]];
    
    NSArray *info=[NSArray arrayWithArray:informacion];
    NSMutableDictionary *diccionario=[[NSMutableDictionary alloc]init];
    [diccionario setObject:info forKey:@"Informacion"];
    [diccionario setObject:@"UpdateLocal" forKey:@"Acceso"];
    NSDictionary *dfinal=[NSDictionary dictionaryWithDictionary:diccionario];
    //NSLog(@"Envio de Info%@",informacion);
    NSError *error;
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:dfinal];
    [self.mySession sendData:myData toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataReliable error:&error];
}
-(IBAction)Syncronize:(id)sender{
    //Change Buffers Aprobal
    //NSLog(@"El Numero %@",[prefs objectForKey:@"Participante"]);
    NSArray *arregloaprobados=[NSArray arrayWithObjects:@"Id",@"Juez",@"Participante",@"Rubro",@"Calificacion",@"Aprobado",nil];
    NSDictionary *aprobados=[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT id,juez,participante,rubro,calificacion,aprobado FROM buffer WHERE participante=\"%@\"",[prefs objectForKey:@"Participante"]] val:arregloaprobados];
    //NSLog(@"El Numero %@,%@",[prefs objectForKey:@"Participante"],aprobados);
    
    NSArray *Id1=[aprobados objectForKey:@"Id"];
    
    NSArray *Juez=[aprobados objectForKey:@"Juez"];
    NSArray *Participante=[aprobados objectForKey:@"Participante"];
    NSArray *Rubro=[aprobados objectForKey:@"Rubro"];
    NSArray *Calificacion=[aprobados objectForKey:@"Calificacion"];
    if ([Id1 count]>0 ) {
        for (int a=0; a<=[Id1 count]-1; a++) {
            [BDParticipantes updateinfo:[NSString stringWithFormat:@"UPDATE buffer SET aprobado=1 WHERE id=\"%@\"",[Id1 objectAtIndex:a]]];
            NSArray *valoressalvar=[NSArray arrayWithObjects:[Juez objectAtIndex:a],[Participante objectAtIndex:a],[Rubro objectAtIndex:a],[Calificacion objectAtIndex:a], nil];
            [BDParticipantes saveinfo2update:valoressalvar val:@"BDEVS" testigo:@"participante" tabla:@"evaluacion" campo:@"juez" nombre:[Juez objectAtIndex:a] campo2:@"participante" nombre2:[Participante objectAtIndex:a] cupdate:@"calificacion" vupdate:[Calificacion objectAtIndex:a]];
        }
    }
    [self buferinfo];
    [self cargarresultadosm];
    [self SincronizarJZ:nil dic:aprobados];
    [self SincronizarPA:nil dic:aprobados];
    //Send evaluacion to Judges and Screen
}


-(IBAction)Syncronizeall:(id)sender{
    //Change Buffers Aprobal
    NSArray *arregloaprobados=[NSArray arrayWithObjects:@"Id",@"Juez",@"Participante",@"Rubro",@"Calificacion",nil];
    NSDictionary *aprobados=[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT id,juez,participante,rubro,calificacion FROM evaluacion"] val:arregloaprobados];
    //NSLog(@"%@,%@",[prefs objectForKey:@"Participante"],aprobados);
    NSArray *Id1=[aprobados objectForKey:@"Id"];

    NSArray *Juez=[aprobados objectForKey:@"Juez"];
    NSArray *Participante=[aprobados objectForKey:@"Participante"];
    NSArray *Rubro=[aprobados objectForKey:@"Rubro"];
    NSArray *Calificacion=[aprobados objectForKey:@"Calificacion"];
    if ([Id1 count]>0 ) {
    for (int a=0; a<=[Id1 count]-1; a++) {
        //[BDParticipantes updateinfo:[NSString stringWithFormat:@"UPDATE buffer SET aprobado=1 WHERE id=\"%@\"",[Id1 objectAtIndex:a]]];
        NSArray *valoressalvar=[NSArray arrayWithObjects:[Juez objectAtIndex:a],[Participante objectAtIndex:a],[Rubro objectAtIndex:a],[Calificacion objectAtIndex:a], nil];
        [BDParticipantes saveinfo2update:valoressalvar val:@"BDEVS" testigo:@"participante" tabla:@"evaluacion" campo:@"juez" nombre:[Juez objectAtIndex:a] campo2:@"participante" nombre2:[Participante objectAtIndex:a] cupdate:@"calificacion" vupdate:[Calificacion objectAtIndex:a]];
    }
    }
    [self cargarresultadosm];
    [self buferinfo];
    [self SincronizarJZ:nil dic:aprobados];
    [self SincronizarPA:nil dic:aprobados];
    //Send evaluacion to Judges and Screen
}

//Envia y Extrae Calificaciones
-(IBAction)SincronizarJZ:(id)sender dic:(NSDictionary*)dic{
    //NSLog(@"Envio de Juez a Revision");
    NSDictionary *evaluacion=dic;
    NSMutableDictionary *informacion=[[NSMutableDictionary alloc]init];
    [informacion setObject:evaluacion forKey:@"Evaluacion"];
    [informacion setObject:@"JuezRev" forKey:@"Acceso"];
    
    NSDictionary *informacion2=[NSDictionary dictionaryWithDictionary:informacion];
    //NSLog(@"Informacion a Enviar Sincronizar %@",informacion2);
    NSError *error;
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:informacion2];

    [self.mySession sendData:myData toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataReliable error:&error];
}

//Envia Informacion a Pantalla
-(IBAction)SincronizarPA:(id)sender dic:(NSDictionary*)dic{
    NSDictionary *evaluacion=dic;
    NSMutableDictionary *informacion=[[NSMutableDictionary alloc]init];
    [informacion setObject:evaluacion forKey:@"Evaluacion"];
    [informacion setObject:@"Pantalla" forKey:@"Acceso"];
    NSDictionary *informacion2=[NSDictionary dictionaryWithDictionary:informacion];
    //NSLog(@"Informacion a Enviar Sincronizar %@",informacion2);
    NSError *error;
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:informacion2];
    [self.mySession sendData:myData toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataReliable error:&error];
    
}
//Transforma en Finales
-(IBAction)ProximaEliminatoria:(id)sender{
    
    NSArray *camposar=[NSArray arrayWithObjects:@"Participante",@"Calificacion",nil];
    NSDictionary *mejores=[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT participantes.nombre,AVG(evaluacion.calificacion) FROM evaluacion INNER JOIN participantes ON participantes.id=evaluacion.participante GROUP BY participantes.nombre ORDER BY AVG(evaluacion.calificacion) DESC LIMIT 12"] val:camposar];
    NSMutableDictionary *participantesfinales=[[NSMutableDictionary alloc]init];
    NSMutableArray *maIdd=[[NSMutableArray alloc]init];
    NSMutableArray *maNombre=[[NSMutableArray alloc]init];
    NSMutableArray *maBandera=[[NSMutableArray alloc]init];
    NSArray *masmejores=[mejores objectForKey:@"Participante"];
    if ([masmejores count]>0) {
        for (int a=0; a<=[masmejores count]-1; a++) {
            NSString *Sidd=[NSString stringWithFormat:@"%i",a+1];
            NSString *SNombre=[masmejores objectAtIndex:[masmejores count]-1-a];
            NSString *SBandera=[BDParticipantes getsingle:[NSString stringWithFormat:@"SELECT pais FROM participantes WHERE nombre=\"%@\"",SNombre]];
            [maIdd addObject:Sidd];
            [maNombre addObject:SNombre];
            [maBandera addObject:SBandera];
        }
    }
    [participantesfinales setObject:maIdd forKey:@"Idd"];
    [participantesfinales setObject:maNombre forKey:@"Nombre"];
    [participantesfinales setObject:maBandera forKey:@"Bandera"];
    NSDictionary *participantes=[NSDictionary dictionaryWithDictionary:participantesfinales];
    NSDictionary *rubros=[BDParticipantes getalltb:@"rubros" val:@"BDN1"];
    NSDictionary *jueces=[BDParticipantes getalltb:@"jueces" val:@"BDN1"];
    NSMutableDictionary *informacion=[[NSMutableDictionary alloc]init];
    NSArray *archivos=[NSArray arrayWithObjects:@"DirtConquersFinals1.db",@"DirtConquersFinals",@"",@"",nil];
    [informacion setObject:archivos forKey:@"Archivos"];
    [informacion setObject:participantes forKey:@"Participantes"];
    [informacion setObject:rubros forKey:@"Rubros"];
    [informacion setObject:jueces forKey:@"Jueces"];
    [informacion setObject:@"Eliminatorias" forKey:@"Acceso"];
    NSDictionary *informacion2=[NSDictionary dictionaryWithDictionary:informacion];
    NSError *error;
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:informacion2];
    //NSLog(@"Eliminatorias Diseñadas %@",informacion2);
    [self actualizarbaseeliminOR:informacion2];
    [self.mySession sendData:myData toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataReliable error:&error];

}

//Cambia el Orden de los Participantes
-(IBAction)UpdateOrder:(id)sender{
    NSDictionary *participantes=[BDParticipantes getalltb:@"participantes" val:@"BDN1"];
    NSDictionary *rubros=[BDParticipantes getalltb:@"rubros" val:@"BDN1"];
    NSDictionary *jueces=[BDParticipantes getalltb:@"jueces" val:@"BDN1"];
    NSMutableDictionary *informacion=[[NSMutableDictionary alloc]init];
    [informacion setObject:participantes forKey:@"Participantes"];
    [informacion setObject:rubros forKey:@"Rubros"];
    [informacion setObject:jueces forKey:@"Jueces"];
    [informacion setObject:@"UpdateOrder" forKey:@"Acceso"];
    NSDictionary *informacion2=[NSDictionary dictionaryWithDictionary:informacion];
    NSError *error;
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:informacion2];
    //NSLog(@"Escritura Inicial%@",informacion2);
    [self.mySession sendData:myData toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataReliable error:&error];
}

//CARGA INICIAL
-(IBAction)DescargaInicial:(id)sender{
    [self sendInicial];
}
- (void) sendInicial{
    NSDictionary *participantes=[BDParticipantes getalltb:@"participantes" val:@"BDN1"];
    NSDictionary *rubros=[BDParticipantes getalltb:@"rubros" val:@"BDN1"];
    NSDictionary *jueces=[BDParticipantes getalltb:@"jueces" val:@"BDN1"];
   
    NSMutableArray *fonlog=[[NSMutableArray alloc]init];
    
    NSArray *afonlog=[NSArray arrayWithArray:fonlog];
    NSArray *configuracion=[NSArray arrayWithObjects:[prefs objectForKey:@"Divisiones"],[prefs objectForKey:@"Cabecera"], nil];
    
    NSMutableDictionary *informacion=[[NSMutableDictionary alloc]init];
    NSArray *archivos=[NSArray arrayWithObjects:[prefs objectForKey:@"Archivo"],[prefs objectForKey:@"NArchivo"],[prefs objectForKey:@"Logo"],[prefs objectForKey:@"Fondo"],nil];
    [informacion setObject:archivos forKey:@"Archivos"];
    [informacion setObject:participantes forKey:@"Participantes"];
    [informacion setObject:rubros forKey:@"Rubros"];
    [informacion setObject:jueces forKey:@"Jueces"];
    [informacion setObject:@"Inicial" forKey:@"Acceso"];
    [informacion setObject:afonlog forKey:@"FonLog"];
    [informacion setObject:configuracion forKey:@"Configuracion"];
    NSDictionary *informacion2=[NSDictionary dictionaryWithDictionary:informacion];
    NSError *error;
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:informacion2];
    [self.mySession sendData:myData toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataReliable error:&error];
}

//MULTIPEER
- (void) setUpMultipeer{
    //NSLog(@"Acceso Multipeer %@",myPeerID.accessibilityLabel);
    //  Setup peer ID
       //  Setup session
    self.mySession = [[MCSession alloc] initWithPeer:self.myPeerID];
    self.mySession.delegate = self;
    
    //  Setup BrowserViewController
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"Xvaluapp1" session:self.mySession];
    self.browserVC.delegate = self;
    
    //  Setup Advertiser
    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"Xvaluapp1" discoveryInfo:nil session:self.mySession];
    [self.advertiser start];
}


-(IBAction)ConectarEvaluadores:(id)sender{
    [self presentViewController:self.browserVC animated:YES completion:nil];
}
- (void) dismissBrowserVC{
    [self.browserVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma marks MCBrowserViewControllerDelegate

// Notifies the delegate, when the user taps the done button
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [self dismissBrowserVC];
}

// Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [self dismissBrowserVC];
}

#pragma marks MCSessionDelegate
-(NSString*)conectedstates:(int)state{
    switch (state) {
        case 0:
            return @"Desconectado";
            break;
        case 1:
            return @"Conectando";
            break;
        case 2:
            return @"Conectado";
            break;
            
        default:
            return @"Nil";
            break;
    }
}


// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    
    NSDictionary *myDictionary = (NSDictionary *) [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //NSLog(@"Informacion Recibida%@",myDictionary);
    //Inicial
    if ([[myDictionary objectForKey:@"Acceso"] isEqualToString:@"Inicial"]) {

        [self actualizarbase:myDictionary];
    }
    //Juez a Maestra
    if ([[myDictionary objectForKey:@"Acceso"] isEqualToString:@"Dato"]) {
        if ([myPeerID.accessibilityLabel isEqualToString:@"Maestra"]) {
            NSLog(@"Peerid%@",peerID.accessibilityLabel);
        
            [self actualizarcalifa:myDictionary];
        }
        
    }
    //Aprobar Calificaciones
    if ([[myDictionary objectForKey:@"Acceso"] isEqualToString:@"Aprobar"]) {
        if ([myPeerID.accessibilityLabel isEqualToString:@"Maestra"]) {
            //NSLog(@"Informacion Recibida %@",myDictionary);
            [self actualizarcalifa:myDictionary];
        }
        
    }
    //Maestra a Pantalla
    if ([[myDictionary objectForKey:@"Acceso"] isEqualToString:@"Pantalla"]) {
        if ([myPeerID.accessibilityLabel isEqualToString:@"Pantalla"]) {
            [self actualizarpantalla:myDictionary];
        }
        
    }
    //Maestra Jueces
    if ([[myDictionary objectForKey:@"Acceso"] isEqualToString:@"JuezRev"]) {
        if ([myPeerID.accessibilityLabel isEqualToString:@"Juez"]) {
            //NSLog(@"Recibo JuezRevision");
            [self actualizarevalo:myDictionary];
        }
    }
    if ([[myDictionary objectForKey:@"Acceso"] isEqualToString:@"JuezRev2"]) {
        if ([myPeerID.accessibilityLabel isEqualToString:@"Juez"]) {
            //NSLog(@"Recibo JuezRevision");
            [self actualizarevalo2];
        }
    }
    //Jueces Maestra
    if ([[myDictionary objectForKey:@"Acceso"] isEqualToString:@"Sincronia"]) {
        if ([myPeerID.accessibilityLabel isEqualToString:@"Maestra"]) {
            //NSLog(@"Recibo Sincronia");
            [self actualizasincronia:myDictionary];
        }
    }
    //Maestra a Jueces
    if ([[myDictionary objectForKey:@"Acceso"] isEqualToString:@"UpdateLocal"]) {
        if ([myPeerID.accessibilityLabel isEqualToString:@"Juez"]) {
            [self actualizarcalifa2:myDictionary];
        }
        
    }
    //Maestra a Jueces
    if ([[myDictionary objectForKey:@"Acceso"] isEqualToString:@"UpdateOrder"]) {
        if (![myPeerID.accessibilityLabel isEqualToString:@"Maestra"]) {
            [self actualizarbase2:myDictionary];
        }
        
    }
    //Maestra a Todas
    if ([[myDictionary objectForKey:@"Acceso"] isEqualToString:@"CleanThemAll"]) {

            [self clean];
            [self purge];
        BDParticipantes=[[GestorBD alloc]initwithdatabases:@"DirtConquers1.db"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self cargaanteriores];
            [self cargasiguientes];
            [self cargarresultadosm];
            [self buferinfo];
            [self visibilidad];
            [self loadlastheatavailablerounds];
        });
        
    }
    //Maestra a Todas
    if ([[myDictionary objectForKey:@"Acceso"] isEqualToString:@"Eliminatorias"]) {
         //NSLog(@"Ejecutando eliminacion%@",myDictionary);
        [self actualizarbaseelimin:myDictionary];
    }

}

// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    
}


// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
}

-(void)actualizarbase:(NSDictionary*)dic{
    //NSLog(@"Info Recibida%@",dic);
    NSArray *archivos=[dic objectForKey:@"Archivos"];
    NSDictionary *participantes=[dic objectForKey:@"Participantes"];
    NSDictionary *rubros=[dic objectForKey:@"Rubros"];
    NSDictionary *jueces=[dic objectForKey:@"Jueces"];
        //NSLog(@"BLABLABLA%@",archivos);
    
    [self.delegadojuez addDatabasewithname:[archivos objectAtIndex:0] archivo:[archivos objectAtIndex:1] fondo:[archivos objectAtIndex:2] logo:[archivos objectAtIndex:3] ];
    
    [prefs setObject:[archivos objectAtIndex:2] forKey:@"fondo"];
    [prefs setObject:[archivos objectAtIndex:3] forKey:@"logo"];
    [prefs setObject:[archivos objectAtIndex:2] forKey:@"Archivo"];
    [prefs synchronize];
    dispatch_async(dispatch_get_main_queue(), ^{
    BDParticipantes=[[GestorBD alloc]initwithdatabases:[prefs objectForKey:@"Archivo"]];
    
    NSArray *PID=[participantes objectForKey:@"Idd"];
    NSArray *PNombre=[participantes objectForKey:@"Nombre"];
    
    NSArray *RID=[rubros objectForKey:@"Idd"];
    NSArray *RNombre=[rubros objectForKey:@"Nombre"];
    
    NSArray *JID=[jueces objectForKey:@"Idd"];
    NSArray *JNombre=[jueces objectForKey:@"Nombre"];
        
    NSArray *configur=[dic objectForKey:@"Configuracion"];
        [prefs setObject:[configur objectAtIndex:0] forKey:@"Divisiones"];
        [prefs setObject:[configur objectAtIndex:1] forKey:@"Cabecera"];
        [prefs synchronize];

    if ([PID count]>0) {
        for (int a=0; a<=[PID count]-1; a++) {
            NSArray *aPID=[NSArray arrayWithObjects:[PID objectAtIndex:a],[PNombre objectAtIndex:a], nil];
            [BDParticipantes saveinfo2:aPID val:@"BDN1S" testigo:@"nombre" tabla:@"participantes" campo:@"nombre" nombre:[PNombre objectAtIndex:a] campo2:@"idd" nombre2:[PID objectAtIndex:a]];
        }
    }
    if ([RID count]>0) {
        for (int a=0; a<=[RID count]-1; a++) {
            NSArray *aRID=[NSArray arrayWithObjects:[RID objectAtIndex:a],[RNombre objectAtIndex:a], nil];
            [BDParticipantes saveinfo2:aRID val:@"BDN1S" testigo:@"nombre" tabla:@"rubros" campo:@"nombre" nombre:[RNombre objectAtIndex:a] campo2:@"idd" nombre2:[RID objectAtIndex:a]];
        }
        
    }
    if ([JID count]>0) {
        for (int a=0; a<=[JID count]-1; a++) {
            NSArray *aJID=[NSArray arrayWithObjects:[JID objectAtIndex:a],[JNombre objectAtIndex:a], nil];
            [BDParticipantes saveinfo2:aJID val:@"BDN1S" testigo:@"nombre" tabla:@"jueces" campo:@"nombre" nombre:[JNombre objectAtIndex:a] campo2:@"idd" nombre2:[JID objectAtIndex:a]];
        }
        
    }

    NSArray *BDN1=[NSArray arrayWithObjects:@"Id",@"Idd",@"Nombre", nil];
        
    Configuracion.divisiones=[[prefs objectForKey:@"Divisiones"] intValue];
    Configuracion.cabecera=[prefs objectForKey:@"Cabecera"];
    Siguientes.divisiones=[[prefs objectForKey:@"Divisiones"] intValue];
    Siguientes.cabecera=[prefs objectForKey:@"Cabecera"];
    dispatch_async(dispatch_get_main_queue(), ^{
    [Configuracion cargartablas:[sub titc1c2:[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY idd",[valoresphp objectForKey:@"Lista"]] val:BDN1] c1:@"Idd" c2:@"Nombre"]];
        [self cargaanteriores];
        [self cargasiguientes];
    [CBJueces setComboData:[sub titcbc1c2:[BDParticipantes getalltb:@"jueces" val:@"BDN1"] c1:@"Idd" c2:@"Nombre"]];
    [CBRubros setComboData:[sub titcbc1c2:[BDParticipantes getalltb:@"rubros" val:@"BDN1"] c1:@"Idd" c2:@"Nombre"]];
        
    });
    });
    
}
-(void)actualizarbase2:(NSDictionary*)dic{
    //NSLog(@"Info Recibida%@",dic);
    NSDictionary *participantes=[dic objectForKey:@"Participantes"];
    NSDictionary *rubros=[dic objectForKey:@"Rubros"];
    NSDictionary *jueces=[dic objectForKey:@"Jueces"];
    
    NSArray *PID=[participantes objectForKey:@"Id"];
     NSArray *PIDd=[participantes objectForKey:@"Idd"];
    NSArray *PNombre=[participantes objectForKey:@"Nombre"];
    
    NSArray *RID=[rubros objectForKey:@"Id"];
    NSArray *RIDd=[rubros objectForKey:@"Idd"];
    NSArray *RNombre=[rubros objectForKey:@"Nombre"];
    
    NSArray *JID=[jueces objectForKey:@"Id"];
    NSArray *JIDd=[jueces objectForKey:@"Idd"];
    NSArray *JNombre=[jueces objectForKey:@"Nombre"];
     dispatch_async(dispatch_get_main_queue(), ^{
    if ([PID count]>0) {
        for (int a=0; a<=[PID count]-1; a++) {
            [BDParticipantes updateinfo:[NSString stringWithFormat:@"UPDATE participantes SET nombre=\"%@\" idd=\"%@\" WHERE id=\"%@\"",[PNombre objectAtIndex:a],[PIDd objectAtIndex:a],[PID objectAtIndex:a]]];
            
        }
    }
    if ([RID count]>0) {
        for (int a=0; a<=[RID count]-1; a++) {
            [BDParticipantes updateinfo:[NSString stringWithFormat:@"UPDATE rubros SET nombre=\"%@\" idd=\"%@\" WHERE id=\"%@\"",[RNombre objectAtIndex:a],[RIDd objectAtIndex:a],[RID objectAtIndex:a]]];
        }
        
    }
    if ([JID count]>0) {
        for (int a=0; a<=[JID count]-1; a++) {
            [BDParticipantes updateinfo:[NSString stringWithFormat:@"UPDATE jueces SET nombre=\"%@\" idd=\"%@\" WHERE id=\"%@\"",[JNombre objectAtIndex:a],[JIDd objectAtIndex:a],[JID objectAtIndex:a]]];
        }
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self cargaanteriores];
        [self cargasiguientes];
        [CBJueces setComboData:[sub titcbc1c2:[BDParticipantes getalltb:@"jueces" val:@"BDN1"] c1:@"Idd" c2:@"Nombre"]];
        [CBRubros setComboData:[sub titcbc1c2:[BDParticipantes getalltb:@"rubros" val:@"BDN1"] c1:@"Idd" c2:@"Nombre"]];
        
    });
    });
    
}
-(void)actualizarbaseeliminOR:(NSDictionary*)dic{
    NSArray *archivos=[dic objectForKey:@"Archivos"];
    NSDictionary *participantes=[dic objectForKey:@"Participantes"];
    NSDictionary *rubros=[dic objectForKey:@"Rubros"];
    NSDictionary *jueces=[dic objectForKey:@"Jueces"];
    
    [prefs setObject:[archivos objectAtIndex:0] forKey:@"Archivo"];
    [prefs setObject:[archivos objectAtIndex:1] forKey:@"NArchivo"];
    [prefs synchronize];
    dispatch_async(dispatch_get_main_queue(), ^{
        //BDParticipantes=nil;
    BDParticipantes=[[GestorBD alloc]initwithdatabases:@"DirtConquersFinals1.db"];

    NSArray *PID=[participantes objectForKey:@"Idd"];
    NSArray *PNombre=[participantes objectForKey:@"Nombre"];
    NSArray *PBandera=[participantes objectForKey:@"Bandera"];
    
    NSArray *RID=[rubros objectForKey:@"Idd"];
    NSArray *RNombre=[rubros objectForKey:@"Nombre"];
    
    NSArray *JID=[jueces objectForKey:@"Idd"];
    NSArray *JNombre=[jueces objectForKey:@"Nombre"];
    dispatch_async(dispatch_get_main_queue(), ^{
    if ([PID count]>0) {
        for (int a=0; a<=[PID count]-1; a++) {
            NSArray *aPID=[NSArray arrayWithObjects:[PID objectAtIndex:a],[PNombre objectAtIndex:a],[PBandera objectAtIndex:a],nil];
            [BDParticipantes saveinfo2:aPID val:@"BDN1AS" testigo:@"nombre" tabla:@"participantes" campo:@"nombre" nombre:[PNombre objectAtIndex:a] campo2:@"idd" nombre2:[PID objectAtIndex:a]];
            
        }
    }
    if ([RID count]>0) {
        for (int a=0; a<=[RID count]-1; a++) {
            NSArray *aRID=[NSArray arrayWithObjects:[RID objectAtIndex:a],[RNombre objectAtIndex:a], nil];
            [BDParticipantes saveinfo2:aRID val:@"BDN1S" testigo:@"nombre" tabla:@"rubros" campo:@"nombre" nombre:[RNombre objectAtIndex:a] campo2:@"idd" nombre2:[PID objectAtIndex:a]];
        }
        
    }
    if ([JID count]>0) {
        for (int a=0; a<=[JID count]-1; a++) {
            NSArray *aJID=[NSArray arrayWithObjects:[JID objectAtIndex:a],[JNombre objectAtIndex:a], nil];
            [BDParticipantes saveinfo2:aJID val:@"BDN1S" testigo:@"nombre" tabla:@"jueces" campo:@"nombre" nombre:[JNombre objectAtIndex:a] campo2:@"idd" nombre2:[PID objectAtIndex:a]];
        }
        
    }
    
    NSArray *BDN1=[NSArray arrayWithObjects:@"Id",@"Idd",@"Nombre", nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [Configuracion cargartablas:[sub titc1c2:[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY idd",[valoresphp objectForKey:@"Lista"]] val:BDN1] c1:@"Idd" c2:@"Nombre"]];
        [self Monitoreo:nil];
        [self buferinfo];
        
    });
        });
        });
    
}
-(void)actualizarbaseelimin:(NSDictionary*)dic{
    //NSLog(@"Info Recibida%@",dic);
    NSArray *archivos=[dic objectForKey:@"Archivos"];
    NSDictionary *participantes=[dic objectForKey:@"Participantes"];
    NSDictionary *rubros=[dic objectForKey:@"Rubros"];
    NSDictionary *jueces=[dic objectForKey:@"Jueces"];
    
    [prefs setObject:[archivos objectAtIndex:0] forKey:@"Archivo"];
    [prefs setObject:[archivos objectAtIndex:1] forKey:@"NArchivo"];
    [prefs synchronize];
    dispatch_async(dispatch_get_main_queue(), ^{
    //BDParticipantes=nil;
    BDParticipantes=[[GestorBD alloc]initwithdatabases:@"DirtConquersFinals1.db"];
    
    NSArray *PID=[participantes objectForKey:@"Idd"];
    NSArray *PNombre=[participantes objectForKey:@"Nombre"];
    NSArray *PBandera=[participantes objectForKey:@"Bandera"];
    
    NSArray *RID=[rubros objectForKey:@"Idd"];
    NSArray *RNombre=[rubros objectForKey:@"Nombre"];
    
    NSArray *JID=[jueces objectForKey:@"Idd"];
    NSArray *JNombre=[jueces objectForKey:@"Nombre"];
    dispatch_async(dispatch_get_main_queue(), ^{
    if ([PID count]>0) {
        for (int a=0; a<=[PID count]-1; a++) {
            NSArray *aPID=[NSArray arrayWithObjects:[PID objectAtIndex:a],[PNombre objectAtIndex:a],[PBandera objectAtIndex:a],nil];
            [BDParticipantes saveinfo2:aPID val:@"BDN1AS" testigo:@"nombre" tabla:@"participantes" campo:@"nombre" nombre:[PNombre objectAtIndex:a] campo2:@"idd" nombre2:[PID objectAtIndex:a]];
            
        }
    }
    if ([RID count]>0) {
        for (int a=0; a<=[RID count]-1; a++) {
            NSArray *aRID=[NSArray arrayWithObjects:[RID objectAtIndex:a],[RNombre objectAtIndex:a], nil];
            [BDParticipantes saveinfo2:aRID val:@"BDN1S" testigo:@"nombre" tabla:@"rubros" campo:@"nombre" nombre:[RNombre objectAtIndex:a] campo2:@"idd" nombre2:[PID objectAtIndex:a]];
        }
        
    }
    if ([JID count]>0) {
        for (int a=0; a<=[JID count]-1; a++) {
            NSArray *aJID=[NSArray arrayWithObjects:[JID objectAtIndex:a],[JNombre objectAtIndex:a], nil];
            [BDParticipantes saveinfo2:aJID val:@"BDN1S" testigo:@"nombre" tabla:@"jueces" campo:@"nombre" nombre:[JNombre objectAtIndex:a] campo2:@"idd" nombre2:[PID objectAtIndex:a]];
        }
        
    }
    
    NSArray *BDN1=[NSArray arrayWithObjects:@"Id",@"Idd",@"Nombre", nil];
    
    Configuracion.divisiones=[[prefs objectForKey:@"Divisiones"] intValue];
    Configuracion.cabecera=[prefs objectForKey:@"Cabecera"];
    Siguientes.divisiones=[[prefs objectForKey:@"Divisiones"] intValue];
    Siguientes.cabecera=[prefs objectForKey:@"Cabecera"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [Configuracion cargartablas:[sub titc1c2:[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY idd",[valoresphp objectForKey:@"Lista"]] val:BDN1] c1:@"Idd" c2:@"Nombre"]];
        [self cargaanteriores];
        [self cargasiguientes];
        [self cargarresultadosglobales:1 cantidad:1];
        [self loadlastheatavailablerounds];
        [CBJueces setComboData:[sub titcbc1c2:[BDParticipantes getalltb:@"jueces" val:@"BDN1"] c1:@"Idd" c2:@"Nombre"]];
    });
        });
        });
    
}


-(void)actualizarcalifa:(NSDictionary*)califa{

    //NSLog(@"INFORMACION RECIBIDA%@",califa);
    NSArray *info=[califa objectForKey:@"Informacion"];
    NSArray *aJID=[NSArray arrayWithObjects:[info objectAtIndex:0],[info objectAtIndex:1],[info objectAtIndex:2],[info objectAtIndex:3],@"0", nil];
    dispatch_async(dispatch_get_main_queue(), ^{
    [BDParticipantes saveinfo2update:aJID val:@"BDBUFS" testigo:@"participante" tabla:@"buffer" campo:@"juez" nombre:[info objectAtIndex:0] campo2:@"participante" nombre2:[info objectAtIndex:1] cupdate:@"calificacion" vupdate:[info objectAtIndex:3]];
    //NSArray *aJID2=[NSArray arrayWithObjects:[info objectAtIndex:0],[info objectAtIndex:1],[info objectAtIndex:2],[info objectAtIndex:3], nil];
    //[BDParticipantes saveinfo2update:aJID2 val:@"BDEVS" testigo:@"participante" tabla:@"evaluacion" campo:@"juez" nombre:[info objectAtIndex:0] campo2:@"participante" nombre2:[info objectAtIndex:1] cupdate:@"calificacion" vupdate:[info objectAtIndex:3]];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[info objectAtIndex:1] isEqualToString:[valoresphp objectForKey:@"Party"]]) {
            [self buferinfo];
        }
        //[self cargarresultadosm];
    });
    });
}

-(void)actualizarcalifa2:(NSDictionary*)califa{
    NSArray *info=[califa objectForKey:@"Informacion"];
    NSArray *aJID=[NSArray arrayWithObjects:[info objectAtIndex:0],[info objectAtIndex:1],[info objectAtIndex:2],[info objectAtIndex:3], nil];
    dispatch_async(dispatch_get_main_queue(), ^{
    [BDParticipantes saveinfo2update:aJID val:@"BDEVS" testigo:@"participante" tabla:@"evaluacionlo" campo:@"juez" nombre:[info objectAtIndex:0] campo2:@"participante" nombre2:[info objectAtIndex:1] cupdate:@"calificacion" vupdate:[info objectAtIndex:3]];
    [BDParticipantes saveinfo2update:aJID val:@"BDEVS" testigo:@"participante" tabla:@"evaluacion" campo:@"juez" nombre:[info objectAtIndex:0] campo2:@"participante" nombre2:[info objectAtIndex:1] cupdate:@"calificacion" vupdate:[info objectAtIndex:3]];

    dispatch_async(dispatch_get_main_queue(), ^{
        //[self cargaanteriores];
        [self cargasiguientes];
    });
        });
    
    
}

-(void)actualizarpantalla:(NSDictionary*)dic{
    //NSLog(@"INFORMACION Pantalla%@",dic);
    NSDictionary *evaluacion=[dic objectForKey:@"Evaluacion"];
    NSArray *PID=[evaluacion objectForKey:@"Id"];
    NSArray *PJuez=[evaluacion objectForKey:@"Juez"];
    NSArray *PParticipante=[evaluacion objectForKey:@"Participante"];
    NSArray *PRubro=[evaluacion objectForKey:@"Rubro"];
    NSArray *PCalificacion=[evaluacion objectForKey:@"Calificacion"];
    dispatch_async(dispatch_get_main_queue(), ^{
    if ([PID count]>0) {
        for (int a=0; a<=[PID count]-1; a++) {
            NSArray *aJID=[NSArray arrayWithObjects:[PJuez objectAtIndex:a],[PParticipante objectAtIndex:a],[PRubro objectAtIndex:a],[PCalificacion objectAtIndex:a], nil];
            [BDParticipantes saveinfo2update:aJID val:@"BDEVS" testigo:@"participante" tabla:@"evaluacion" campo:@"juez" nombre:[PJuez objectAtIndex:a] campo2:@"participante" nombre2:[PParticipante objectAtIndex:a] cupdate:@"calificacion" vupdate:[PCalificacion objectAtIndex:a]];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self cargarresultadosglobales];
        [self loadlastheatavailablerounds];
    });
        });
}

-(void)actualizarevalo2{
    NSArray *arreglo1=[NSArray arrayWithObjects:@"Id",@"Juez",@"Participante",@"Rubro",@"Calificacion",nil];
    NSDictionary *dic1=[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT evaluacionlo.id,evaluacionlo.juez,evaluacionlo.participante,evaluacionlo.rubro,evaluacionlo.calificacion FROM evaluacionlo WHERE NOT EXISTS (SELECT * FROM evaluacion WHERE evaluacion.participante = evaluacionlo.participante AND evaluacion.juez =evaluacionlo.juez) ORDER BY id"] val:arreglo1];
    
    
    NSLog(@"faltantes%@",dic1);
    /*NSDictionary *dic2=[BDParticipantes getselecteddatast:[NSString stringWithFormat:@"SELECT id,juez,participante,rubro,calificacion FROM evaluacionlo ORDER BY id"] val:arreglo1];

    NSLog(@"faltantes%@",dic2);*/
    NSMutableDictionary *informacion=[[NSMutableDictionary alloc]init];
    [informacion setObject:dic1 forKey:@"Sincronia"];
    [informacion setObject:@"Sincronia" forKey:@"Acceso"];
    NSDictionary *informacion2=[NSDictionary dictionaryWithDictionary:informacion];
    NSError *error;
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:informacion2];
    [self.mySession sendData:myData toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataReliable error:&error];
    



}

-(void)actualizarevalo:(NSDictionary*)dic{
    //NSLog(@"Actualizo JuezRevision");
    NSDictionary *evaluacion=[dic objectForKey:@"Evaluacion"];
    
    NSArray *PID=[evaluacion objectForKey:@"Id"];
    NSArray *PJuez=[evaluacion objectForKey:@"Juez"];
    NSArray *PParticipante=[evaluacion objectForKey:@"Participante"];
    NSArray *PRubro=[evaluacion objectForKey:@"Rubro"];
    NSArray *PCalificacion=[evaluacion objectForKey:@"Calificacion"];
    dispatch_async(dispatch_get_main_queue(), ^{
    if ([PID count]>0) {
        for (int a=0; a<=[PID count]-1; a++) {
            NSArray *aJID=[NSArray arrayWithObjects:[PJuez objectAtIndex:a],[PParticipante objectAtIndex:a],[PRubro objectAtIndex:a],[PCalificacion objectAtIndex:a], nil];
            [BDParticipantes saveinfo2update:aJID val:@"BDEVS" testigo:@"participante" tabla:@"evaluacion" campo:@"juez" nombre:[PJuez objectAtIndex:a] campo2:@"participante" nombre2:[PParticipante objectAtIndex:a] cupdate:@"calificacion" vupdate:[PCalificacion objectAtIndex:a]];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self cargaanteriores];
    });
        });
    
    
}
-(void)actualizasincronia:(NSDictionary*)dic{
    //NSLog(@"Actualizo Sincronia");
    //NSLog(@"INFORMACION Sincronia%@",dic);
    NSDictionary *evaluacion=[dic objectForKey:@"Sincronia"];
    
    NSArray *PID=[evaluacion objectForKey:@"Id"];
    NSArray *PJuez=[evaluacion objectForKey:@"Juez"];
    NSArray *PParticipante=[evaluacion objectForKey:@"Participante"];
    NSArray *PRubro=[evaluacion objectForKey:@"Rubro"];
    NSArray *PCalificacion=[evaluacion objectForKey:@"Calificacion"];
    dispatch_async(dispatch_get_main_queue(), ^{
    if ([PID count]>0) {
        for (int a=0; a<=[PID count]-1; a++) {
            NSArray *aJID=[NSArray arrayWithObjects:[PJuez objectAtIndex:a],[PParticipante objectAtIndex:a],[PRubro objectAtIndex:a],[PCalificacion objectAtIndex:a],@"0", nil];
            [BDParticipantes saveinfo2update:aJID val:@"BDBUFS" testigo:@"participante" tabla:@"buffer" campo:@"juez" nombre:[PJuez objectAtIndex:a] campo2:@"participante" nombre2:[PParticipante objectAtIndex:a] cupdate:@"calificacion" vupdate:[PCalificacion objectAtIndex:a]];
        }
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self buferinfo];
        [self cargarresultadosm];
        [self loadlastheatavailablerounds];
        [self cargarDetalle:[valoresphp objectForKey:@"LocalPar"]];
    });
        });
}

//FUNCIONES ADICIONALES
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    //[self sendText];
    return YES;
}
- (UIImage*)loadImage:(NSString*)nombre1
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithFormat: @"%@.png",nombre1] ];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}
-(int)getmaxid:(NSDictionary*)dic valor:(NSString*)valor{
    //NSLog(@"valores %@",dic);
    NSArray *valores=[dic objectForKey:valor];
    //NSLog(@"array %@",valores);
    int b=0;
    if ([valores count]>0) {
        for (int a=0; a<=[valores count]-1; a++) {
            if ([[valores objectAtIndex:a]intValue]>b) {
                b=[[valores objectAtIndex:a] intValue];
            }
        }
    }
    b++;
    return b;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)saveImage: (UIImage*)image nombre:(NSString*)nombre1
{
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@.png",nombre1]];
        //NSLog(@"En Grabacion a %@",path);
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
}



@end

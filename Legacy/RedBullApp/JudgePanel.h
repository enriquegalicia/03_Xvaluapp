//
//  ConnectDevices.h
//  RedBullApp
//
//  Created by Enrique Galicia on 30/01/14.
//  Copyright (c) 2014 Enrique Galicia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GestorBD.h"
#import "BasicTable.h"
#import "TablaSeccionada.h"
#import "ComboBox.h"
#import "Subtitulados.h"
#import "Resultados.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "Detalle.h"
#import "Resultados1.h"
#import "Funciones.h"

@protocol JudgeDelegate;

@interface JudgePanel : UIViewController<MCBrowserViewControllerDelegate, MCSessionDelegate,basictable,ComboDelegate,secctable,restable,DetalleDelegado>{
    
    NSMutableDictionary *valoresphp;
    NSUserDefaults *prefs;
    
    //CONFIGURACION
    GestorBD *BDParticipantes;
    Subtitulados *sub;
    
    BasicTable *Conexiones;
    TablaSeccionada *Configuracion;
    Resultados *ResultadosM;
    
    //JUECES
    BasicTable *Anteriores;
    TablaSeccionada *Siguientes;
    
    //PANTALLA
    Resultados1 *ResultadosGlobales;
    Resultados1 *ResultadosRondas;
    
    ComboBox *CBJueces;
    ComboBox *CBRubros;
    
    Funciones *funa;
    IBOutlet UITextField *TfPassword;
    IBOutlet UIButton *BtDesactivado;
    IBOutlet UIImageView *IvFondo;
    IBOutlet UIImageView *IvLogo;
    
    id<JudgeDelegate>delegadojuez;
    //Primer Screen
    IBOutlet UIButton *BtConectarEv;
    IBOutlet UIImageView *IvConectados;
    IBOutlet UIButton *BtParticipantes;
    IBOutlet UIButton *BtJueces;
    IBOutlet UIButton *BtRubros;
    IBOutlet UITextField *TfCampo;
    IBOutlet UILabel *LaSeleccion;
    IBOutlet UIButton *BtNuevo;
    IBOutlet UIButton *BtModificar;
    IBOutlet UIButton *BtBorrar;
    IBOutlet UIButton *BtAuto;
    IBOutlet UIImageView *IvLista;
    IBOutlet UIButton *BtSubir;
    IBOutlet UIButton *BtBajar;

    IBOutlet UIButton *BtCargaInicial;
    IBOutlet UIButton *BtPurgar;
    IBOutlet UIButton *BtProximaEliminatoria;
    IBOutlet UIButton *BtSincronizarGlobal;
    
    NSMutableArray *peercon;
    NSMutableDictionary *peerstate;
    NSDictionary *conectados;
    NSString *accesado;
    
    IBOutlet UITextField *TfUpdateLocalGrade;
    IBOutlet UIButton *BtSendUpdate;
    
    //Segundo Screen
    IBOutlet UILabel *LaAnteriores;
    IBOutlet UILabel *LaSiguientes;
    IBOutlet UIImageView *IvTbAnteriores;
    IBOutlet UIImageView *IvTbSiguientes;
    IBOutlet UILabel *LaJuez;
    IBOutlet UILabel *LaRubro;
    IBOutlet UILabel *LaEvParcial;
    IBOutlet UIButton *BtEnviarP;
    IBOutlet UIButton *BtBorrarP;
    IBOutlet UIButton *n1;
    IBOutlet UIButton *n2;
    IBOutlet UIButton *n3;
    IBOutlet UIButton *n4;
    IBOutlet UIButton *n5;
    IBOutlet UIButton *n6;
    IBOutlet UIButton *n7;
    IBOutlet UIButton *n8;
    IBOutlet UIButton *n9;
    IBOutlet UIButton *n00;
    IBOutlet UIButton *guardar;
    IBOutlet UIImageView *IvCbJueces;
    IBOutlet UIImageView *IvCbRubros;
    IBOutlet UIButton *BtGuardar;
    
    
    IBOutlet UITextField *TfCabecera;
    IBOutlet UITextField *TfDivisiones;
    IBOutlet UIButton *BtDividir;
    

    //Tercer Screen

    IBOutlet UILabel *LaResultados;
    IBOutlet UIImageView *IvTbResultados;
    IBOutlet UILabel *LaHeat;
    IBOutlet UIImageView *IvTbHeat;
    
    NSString *perfil;
    
    //Edicion Resultados
    IBOutlet UIButton *BtEdicion;
    IBOutlet UIButton *BtMonitoreo;
    IBOutlet UIButton *UpdateOrder;
    IBOutlet UIImageView *IvRonda;
    IBOutlet UIImageView *IvSeleccion;
    IBOutlet Detalle *IvDetalle;
    MCPeerID *myPeerID;
    IBOutlet UITextField *tfFinals;
    IBOutlet UIButton *BtSyncronizeAll;
    
    IBOutlet UIButton *Extract;
    IBOutlet UIButton *Syncronize;
    IBOutlet UIButton *BacktoList;
    IBOutlet UIButton *Play;
    IBOutlet UIButton *FRank;
    int primero;
    NSTimer * timer1;
    NSTimer * timer3;
    NSTimer * timer4;
    NSMutableArray *arreglotimers;
    BOOL totales;

    
}

@property (nonatomic, retain)id<JudgeDelegate>delegadojuez;
@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;
@property (nonatomic, strong)NSString *perfil;


//Globales
-(IBAction)Desactivado:(id)sender;


//Primer Screen
-(IBAction)ConectarEvaluadores:(id)sender;
-(IBAction)updatelocalgrade:(id)sender;

-(IBAction)Participante:(id)sender;
-(IBAction)Juez:(id)sender;
-(IBAction)Rubros:(id)sender;
-(IBAction)Nuevo:(id)sender;
-(IBAction)Modificar:(id)sender;
-(IBAction)Borrar:(id)sender;

-(IBAction)Subir:(id)sender;
-(IBAction)Bajar:(id)sender;
-(IBAction)DescargaInicial:(id)sender;
-(IBAction)Purgar:(id)sender;

-(IBAction)Dividir:(id)sender;

-(IBAction)Edicion:(id)sender;
-(IBAction)Monitoreo:(id)sender;
-(IBAction)Syncronizeall:(id)sender;
-(IBAction)Play:(id)sender;
-(IBAction)FRank:(id)sender;

//Segundo Screen
-(IBAction)Guardar:(id)sender;
-(IBAction)BorrarP:(id)sender;
-(IBAction)EnviarP:(id)sender;
-(IBAction)calificacion:(id)sender;

//-(IBAction)SincronizarJZ:(id)sender;
//-(IBAction)SincronizarPA:(id)sender;
-(IBAction)ProximaEliminatoria:(id)sender;
-(IBAction)UpdateOrder:(id)sender;
-(IBAction)BackList:(id)sender;
-(IBAction)Syncronize:(id)sender;
-(IBAction)Extract:(id)sender;

//-(IBAction)ClearThemAllFunction:(id)sender;

@end
@protocol JudgeDelegate
-(void)JudgeDidFinish:(JudgePanel*)controller;
-(void)addDatabasewithname:(NSString*)database archivo:(NSString*)archivo fondo:(NSString*)fondo logo:(NSString*)logo;

@end

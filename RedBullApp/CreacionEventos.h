//
//  CreacionEventos.h
//  RedBullApp
//
//  Created by Enrique Galicia on 21/03/14.
//  Copyright (c) 2014 Enrique Galicia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataBase.h"
#import "ComboBox.h"
#import "Subtitulados.h"
#import "JudgePanel.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>




@interface CreacionEventos : UIViewController<ComboDelegate,JudgeDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    IBOutlet UIButton *bNueva;
    IBOutlet UIButton *bRenombrar;
    IBOutlet UIButton *bLogo;
    IBOutlet UIButton *bFondo;
    IBOutlet UIButton *bAccesar;
    IBOutlet UITextField *NuevoEvento;
    IBOutlet UIButton *eliminar;

    DataBase *BasedeBases;
    ComboBox *BasesDatos;
    Subtitulados *sub;
    
    NSUserDefaults *prefs;
    NSMutableDictionary *valores;
    
    IBOutlet UIImageView* IvLogo;
    IBOutlet UIImageView* IvFondo;
    IBOutlet UIImageView* IvBase;
    
    BOOL newMedia;
    NSString* numeroImagen;
    
}
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;


-(IBAction)Accesar:(id)sender;
-(IBAction)NuevoEvento:(id)sender;
-(IBAction)Logo:(id)sender;
-(IBAction)Fondo:(id)sender;
-(IBAction)Renombrar:(id)sender;
-(IBAction)Eliminar:(id)sender;
-(IBAction)Auxiliar:(id)sender;
-(void)JudgeDidFinish:(JudgePanel*)controller;
-(void)addDatabasewithname:(NSString*)database archivo:(NSString*)archivo fondo:(NSString*)fondo logo:(NSString*)logo;

@end

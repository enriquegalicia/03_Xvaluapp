//
//  CreacionEventos.m
//  RedBullApp
//
//  Created by Enrique Galicia on 21/03/14.
//  Copyright (c) 2014 Enrique Galicia. All rights reserved.
//

#import "CreacionEventos.h"

@interface CreacionEventos ()

@end

@implementation CreacionEventos

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//CONFIGURACION INICIAL
- (void)viewDidLoad
{
    [super viewDidLoad];
    //Inicializacion
    //Clases
    sub=[[Subtitulados alloc]init];
    valores=[[NSMutableDictionary alloc]init];
    
    //Arreglos
    NSArray *tablaarchivos=[NSArray arrayWithObjects:@"ARCHIVOS",@"NOMBRE TEXT",@"ARCHITEXT TEXT",@"LOGO TEXT",@"FONDO TEXT", nil];
    NSArray *concentrado=[NSArray arrayWithObjects:tablaarchivos, nil];
    
    //Inicio Base de Datos
    BasedeBases=[[DataBase alloc]initDB:@"Main.db" Tablas:concentrado];
    NSArray *BDP=[NSArray arrayWithObjects:@"Id",@"Nombre",@"Architext",@"Logo",@"Fondo", nil];
    NSArray *BDPS=[NSArray arrayWithObjects:@"Nombre",@"Architext",@"Logo",@"Fondo", nil];
    [valores setObject:BDP forKey:@"BDP"];
    [valores setObject:BDPS forKey:@"BDPS"];
    
    NSArray *Valores=[NSArray arrayWithObjects:@"DirtConquers",@"DirtConquers1.db",@"",@"", nil];
    NSArray *Valores2=[NSArray arrayWithObjects:@"DirtConquersFinals",@"DirtConquersFinals1.db",@"",@"", nil];
    
    if ([[[BasedeBases getalltablesfromDB:@"archivos" campos:BDP] objectForKey:@"Id"] count]==0) {
        [BasedeBases revisarBD:BDPS Valores:Valores Testigo:@"Nombre" Tabla:@"archivos" Campo:@"Nombre" Nombre:@"Default"];
        [BasedeBases revisarBD:BDPS Valores:Valores2 Testigo:@"Nombre" Tabla:@"archivos" Campo:@"Nombre" Nombre:@"Default"];
    }
    //Defaults Nombre Archivo
    prefs = [NSUserDefaults standardUserDefaults];
    if (![prefs objectForKey:@"Archivo"]) {
        [prefs setObject:@"DirtConquers1.db" forKey:@"Archivo"];
        [prefs synchronize];
    }
    /*if (![prefs objectForKey:@"Fondo"]) {
        [prefs setObject:@"Fond" forKey:@"Fondo"];
        [prefs synchronize];
    }
    if (![prefs objectForKey:@"Logo"]) {
        [prefs setObject:@"Log" forKey:@"Logo"];
        [prefs synchronize];
    }*/
    NSString *strCat= [prefs objectForKey:@"Archivo"];
    NSString *narchivo=[BasedeBases getselecteddatafromstatement:[NSString stringWithFormat:@"SELECT nombre FROM archivos WHERE architext=\"%@\"",strCat]];
    [prefs setObject:narchivo forKey:@"NArchivo"];
    [prefs synchronize];
    
    BasesDatos=[[ComboBox alloc]init];
    BasesDatos.delegadocombo=self;
    [BasesDatos setActivo:1];
    BasesDatos.titulo=@"Archivo";
    BasesDatos.view.frame= IvBase.frame;
    [self.view addSubview:BasesDatos.view];
    [BasesDatos text:narchivo];
    [BasesDatos setComboData:[sub MAtitc1:[BasedeBases getalltablesfromDB:@"archivos" campos:BDP] c1:@"Nombre" ]];
    [BasesDatos text:[sub titc1:[BasedeBases getalldatafromstatement:[NSString stringWithFormat:@"SELECT * FROM archivos WHERE architext=\"%@\"",strCat] campos:BDP] c1:@"Nombre"]];

    if (![prefs objectForKey:@"Accesado"]) {
        [prefs setObject:@"0" forKey:@"Accesado"];
        [prefs synchronize];
    }
    NSString* accesado=[prefs objectForKey:@"Accesado"];
    if ([accesado isEqualToString:@"1"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self Accesar:nil];
        });
        //[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(Accesar:) userInfo:nil repeats:NO];
    }
    if ([accesado isEqualToString:@"2"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self Auxiliar:nil];
        });
        //[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(Auxiliar:) userInfo:nil repeats:NO];
    }
    if ([accesado isEqualToString:@"3"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self Pantalla:nil];
        });
        //[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(Pantalla:) userInfo:nil repeats:NO];
    }
    

}


-(IBAction)NuevoEvento:(id)sender{
    /*if (![NuevoEvento.text isEqualToString:@""]) {
        NSArray *informacion=[NSArray arrayWithObjects:NuevoEvento.text,[NSString stringWithFormat:@"%@.db",NuevoEvento.text],@"Log",@"Fond",nil];
        [BasedeBases revisarBD:[valores objectForKey:@"BDPS"] Valores:informacion Testigo:@"nombre" Tabla:@"archivos" Campo:@"nombre" Nombre:NuevoEvento.text];
        [prefs setObject:[NSString stringWithFormat:@"%@.db",NuevoEvento.text] forKey:@"Archivo"];
        [prefs setObject:NuevoEvento.text forKey:@"NArchivo"];
        [prefs setObject:@"Fond" forKey:@"Fondo"];
        [prefs setObject:@"Log" forKey:@"Logo"];
        [prefs synchronize];
        //IvFondo.image=[self loadImage:[prefs objectForKey:@"Fondo"]];
        //IvLogo.image=[self loadImage:[prefs objectForKey:@"Logo"]];
        [BasesDatos setComboData:[sub MAtitc1:[BasedeBases getalltablesfromDB:@"archivos" campos:[valores objectForKey:@"BDP"]] c1:@"Nombre" ]];
        [BasesDatos text:NuevoEvento.text];
    }*/
}
-(IBAction)Renombrar:(id)sender{
    /*if (![NuevoEvento.text isEqualToString:@""]) {
        NSString *idd=[BasedeBases getselecteddatafromstatement:[NSString stringWithFormat:@"SELECT id FROM archivos WHERE nombre=\"%@\"",BasesDatos.selectedText]];
        [BasedeBases update:[NSString stringWithFormat:@"UPDATE archivos SET nombre =\"%@\" WHERE id =\"%@\"",NuevoEvento.text,idd]];
        [BasesDatos setComboData:[sub MAtitc1:[BasedeBases getalltablesfromDB:@"archivos" campos:[valores objectForKey:@"BDP"]] c1:@"Nombre" ]];
        [prefs setObject:NuevoEvento.text forKey:@"NArchivo"];
        NSString *archivo=[BasedeBases getselecteddatafromstatement:[NSString stringWithFormat:@"SELECT architext FROM archivos WHERE nombre=\"%@\"",[prefs objectForKey:@"NArchivo"]]];
        [prefs setObject:archivo forKey:@"Archivo"];
        [prefs synchronize];
        [BasesDatos text:NuevoEvento.text];
    }*/
}
-(IBAction)Eliminar:(id)sender{
    /*if (![[BasedeBases getalltablesfromDB:@"archivos" campos:[valores objectForKey:@"BDP"]] count]>1) {
        [BasedeBases update:[NSString stringWithFormat:@"DELETE FROM archivos WHERE nombre=\"%@\"",[prefs objectForKey:@"NArchivo"]]];
        [BasesDatos setComboData:[sub MAtitc1:[BasedeBases getalltablesfromDB:@"archivos" campos:[valores objectForKey:@"BDP"]] c1:@"Nombre" ]];
        NSString *archivo=BasesDatos.selectedText;
        [prefs setObject:[BasedeBases getselecteddatafromstatement:[NSString stringWithFormat:@"SELECT architext FROM archivos WHERE nombre=\"%@\"",archivo]] forKey:@"Archivo"];
        [prefs setObject:archivo forKey:@"NArchivo"];
        [prefs setObject:[BasedeBases getselecteddatafromstatement:[NSString stringWithFormat:@"SELECT fondo FROM archivos WHERE nombre=\"%@\"",archivo]] forKey:@"Fondo"];
        [prefs setObject:[BasedeBases getselecteddatafromstatement:[NSString stringWithFormat:@"SELECT logo FROM archivos WHERE nombre=\"%@\"",archivo]] forKey:@"Logo"];
        [prefs synchronize];
        //IvFondo.image=[self loadImage:[prefs objectForKey:@"Fondo"]];
        //IvLogo.image=[self loadImage:[prefs objectForKey:@"Logo"]];
        NuevoEvento.text=[prefs objectForKey:@"Archivo"];
        [BasesDatos text:[prefs objectForKey:@"Archivo"]];
    }*/
}

-(IBAction)Logo:(id)sender{
    [self useCameraRoll:2];
}
-(IBAction)Fondo:(id)sender{
    [self useCameraRoll:1];
}
//Informacion del Seleccionado ComboBox
-(void)sendselection:(int)sendselection titulo:(NSString *)titulo{
    
}
-(void)sendselection1:(NSString*)sendselection titulo:(NSString*)titulo{
    //NSLog(@"seleccion %@_%@",sendselection,titulo);
    
if ([titulo isEqualToString:@"Archivo"]) {
        [prefs setObject:sendselection forKey:@"NArchivo"];
        [prefs synchronize];
        NSString *archivo=[BasedeBases getselecteddatafromstatement:[NSString stringWithFormat:@"SELECT architext FROM archivos WHERE nombre=\"%@\"",[prefs objectForKey:@"NArchivo"]]];
        [prefs setObject:archivo forKey:@"Archivo"];
        [prefs setObject:[BasedeBases getselecteddatafromstatement:[NSString stringWithFormat:@"SELECT fondo FROM archivos WHERE nombre=\"%@\"",[prefs objectForKey:@"NArchivo"]]] forKey:@"Fondo"];
        [prefs setObject:[BasedeBases getselecteddatafromstatement:[NSString stringWithFormat:@"SELECT logo FROM archivos WHERE nombre=\"%@\"",[prefs objectForKey:@"NArchivo"]]] forKey:@"Logo"];
        [prefs synchronize];
        //IvFondo.image=[self loadImage:[prefs objectForKey:@"Fondo"]];
        //IvLogo.image=[self loadImage:[prefs objectForKey:@"Logo"]];
        NuevoEvento.text=[prefs objectForKey:@"NArchivo"];
    }
}
-(void)addDatabasewithname:(NSString*)database archivo:(NSString*)archivo fondo:(NSString*)fondo logo:(NSString*)logo{
    /* NSArray *informacion=[NSArray arrayWithObjects:database,archivo,fondo,logo,nil];
    [BasedeBases revisarBD:[valores objectForKey:@"BDPS"] Valores:informacion Testigo:@"nombre" Tabla:@"archivos" Campo:@"nombre" Nombre:database];
    [BasesDatos setComboData:[sub MAtitc1:[BasedeBases getalltablesfromDB:@"archivos" campos:[valores objectForKey:@"BDP"]] c1:@"Nombre" ]];
    [BasesDatos text:database];
    [prefs setObject:database forKey:@"NArchivo"];
    [prefs synchronize];
    NSString *archivo1=[BasedeBases getselecteddatafromstatement:[NSString stringWithFormat:@"SELECT architext FROM archivos WHERE nombre=\"%@\"",[prefs objectForKey:@"NArchivo"]]];
    [prefs setObject:archivo1 forKey:@"Archivo"];
    [prefs setObject:[BasedeBases getselecteddatafromstatement:[NSString stringWithFormat:@"SELECT fondo FROM archivos WHERE nombre=\"%@\"",[prefs objectForKey:@"NArchivo"]]] forKey:@"Fondo"];
    [prefs setObject:[BasedeBases getselecteddatafromstatement:[NSString stringWithFormat:@"SELECT logo FROM archivos WHERE nombre=\"%@\"",[prefs objectForKey:@"NArchivo"]]] forKey:@"Logo"];
    [prefs synchronize];
    //IvFondo.image=[self loadImage:[prefs objectForKey:@"Fondo"]];
    //IvLogo.image=[self loadImage:[prefs objectForKey:@"Logo"]];
    NuevoEvento.text=[prefs objectForKey:@"NArchivo"];*/
}

-(IBAction)Accesar:(id)sender;{
    JudgePanel *clase=[[JudgePanel alloc] initWithNibName:@"Main" bundle:nil];
    clase.delegadojuez=self;
    [prefs setObject:@"1" forKey:@"Accesado"];
    [prefs synchronize];
    [self presentViewController:clase animated:YES completion:nil];
    
}

-(IBAction)Auxiliar:(id)sender{
    JudgePanel *clase=[[JudgePanel alloc] initWithNibName:@"JudgePanel" bundle:nil];
    clase.delegadojuez=self;
    [prefs setObject:@"2" forKey:@"Accesado"];
    [prefs synchronize];
    [self presentViewController:clase animated:YES completion:nil];

    
}
-(IBAction)Pantalla:(id)sender{
    JudgePanel *clase=[[JudgePanel alloc] initWithNibName:@"Screen" bundle:nil];
    clase.delegadojuez=self;
    [prefs setObject:@"3" forKey:@"Accesado"];
    [prefs synchronize];
    [self presentViewController:clase animated:YES completion:nil];
    
    
}
-(void)JudgeDidFinish:(JudgePanel*)controller{
        [self dismissViewControllerAnimated:YES completion:nil];

}

//FUNCIONES DE SOPORTE
//Extraccion de Imagenes
- (void) useCameraRoll:(int)imagen
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:
                                  
                                  UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        newMedia = YES;
        numeroImagen=[NSString stringWithFormat:@"%i",imagen];
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        if ([numeroImagen isEqualToString:@"1"]) {
            //IvFondo.image = image;
            NSString* Nombre=[NSString stringWithFormat:@"Fondo%@",[BasedeBases getselecteddatafromstatement:[NSString stringWithFormat:@"SELECT id FROM archivos WHERE nombre=\"%@\"",[prefs objectForKey:@"NArchivo"]]]];
            [prefs setObject:Nombre forKey:@"Fondo"];
            [self saveImage:image nombre:Nombre];
            [BasedeBases update:[NSString stringWithFormat:@"UPDATE archivos SET fondo=\"%@\" WHERE nombre=\"%@\"",Nombre,[prefs objectForKey:@"NArchivo"]]];
        }
        else if ([numeroImagen isEqualToString:@"2"]){
            //IvLogo.image=image;
            NSString* Nombre=[NSString stringWithFormat:@"Logo%@",[BasedeBases getselecteddatafromstatement:[NSString stringWithFormat:@"SELECT id FROM archivos WHERE nombre=\"%@\"",[prefs objectForKey:@"NArchivo"]]]];
            [prefs setObject:Nombre forKey:@"Logo"];
            [self saveImage:image nombre:Nombre];
            [BasedeBases update:[NSString stringWithFormat:@"UPDATE archivos SET logo=\"%@\" WHERE nombre=\"%@\"",Nombre,[prefs objectForKey:@"NArchivo"]]];
        }
        [prefs synchronize];
        
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
		// Code here to support video if enabled
	}
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

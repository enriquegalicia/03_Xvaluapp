 //
//  BasicTable.m
//  Magma
//
//  Created by Enrique Galicia on 19/08/13.
//  Copyright (c) 2013 Enrique Galicia. All rights reserved.
//

#import "Resultados1.h"

@interface Resultados1 ()

@end

@implementation Resultados1
@synthesize delegadores1=_delegadores1,tamsubtit,tamtit,funcion;
@synthesize celda;
@synthesize resul=_resul;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    cantidaddeelementos=0;
    valoresphp=[[NSMutableDictionary alloc]init];
    [self.tableView registerNib:[UINib nibWithNibName:@"Resultados_Finales"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"cell"];

}
-(void)cargartablas:(NSDictionary*)informacion{

    
    idd=[informacion objectForKey:@"Id"];
    idd2=[idd copy];
    nombre=[informacion objectForKey:@"Nombre"];
    nombre2=[nombre copy];
    calificacion=[informacion objectForKey:@"Calificacion"];
    calificacion2=[calificacion copy];
    rubros=[informacion objectForKey:@"Rubros"];
    rubros2=[rubros copy];
    colores=[informacion objectForKey:@"Colores"];
    colores2=[colores copy];
    banderas=[informacion objectForKey:@"Bandera"];
    banderas2=[banderas copy];
    cantidaddeelementos=[idd count];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (cantidaddeelementos>0) {
        return cantidaddeelementos;
    }
    else{
    return 1;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Resultado1 *resulta = (Resultado1 *)[tableView dequeueReusableCellWithIdentifier:[Resultado1 reuseIdentifier]];
    if (resulta == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"Resultado1" owner:self options:nil];
        resulta = _resul;
        _resul = nil;
    }
    resulta.backgroundColor=[UIColor clearColor];
    NSString *idd1 = [idd2 objectAtIndex:indexPath.row];
    NSString *nombre1 = [nombre2 objectAtIndex:indexPath.row];
    NSString *calificacion1 = [calificacion2 objectAtIndex:indexPath.row];
    NSString *bandera = [banderas2 objectAtIndex:indexPath.row];
    UIImage *ibandera = [UIImage imageNamed:bandera];
    
    resulta.idd.text =idd1;
    resulta.nombre.text =nombre1;
    resulta.calificacion.text =calificacion1;
    resulta.SBandera=bandera;
    resulta.Bandera.image=ibandera;
    resulta.selectionStyle = UITableViewCellSelectionStyleNone;
    
    resulta.idd.textColor=[UIColor blackColor];
    resulta.nombre.textColor=[UIColor blackColor];
    resulta.calificacion.textColor=[UIColor blackColor];


    
    return resulta;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 75;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self.delegadores1 setselected:[nombre2 objectAtIndex:indexPath.row] fun:funcion];
}


@end

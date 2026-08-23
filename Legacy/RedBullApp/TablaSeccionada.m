//
//  TablaSeccionada.m
//  Xvaluapp
//
//  Created by Enrique Galicia on 02/04/14.
//  Copyright (c) 2014 Enrique Galicia. All rights reserved.
//
#import "TablaSeccionada.h"

@interface TablaSeccionada ()

@end

@implementation TablaSeccionada
@synthesize delegadotase=_delegadotase,tamsubtit,tamtit,funcion;
@synthesize divisiones,cabecera;



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
    
}
-(void)cargartablas:(NSDictionary*)informacion{
    
    titulo=[informacion objectForKey:@"Titulo"];
    titulo2=[titulo copy];
    subtitulo=[informacion objectForKey:@"Subtitulo"];
    subtitulo2=[subtitulo copy];
    firsttitle=[[titulo objectAtIndex:0] intValue];
    cantidaddeelementos=[titulo2 count];
    //NSLog(@"FirstTitle%i",firsttitle-1);
    if (!divisiones==0) {
        if ((firsttitle-1)==0) {
            //NSLog(@"AA");
            //NSLog(@"Caso1");
            total=cantidaddeelementos;
            if (total % divisiones == 0) {
                secciones=total/divisiones;
            }
            else{
                secciones=(total/divisiones)+1;
            }
            fsecciones=secciones;
            divisionesafectadas=0;
            ftotal=total;
            fdivision=ftotal/fsecciones;
            remanda=0;
            cierre=total-(secciones*divisiones);
            }
        else{
            //NSLog(@"BB");
            total=cantidaddeelementos+(firsttitle-1);
            ftotal=total;
            
            if (total % divisiones == 0) {
                secciones=total/divisiones;
            }
            else{
                secciones=(total/divisiones)+1;
            }
            fsecciones=secciones;
            fdivision=ftotal/fsecciones;
            divisionesafectadas=(firsttitle-1)/fdivision;
            if ((firsttitle-1) % divisiones == 0) {
                remanda=(divisionesafectadas*divisiones)-(firsttitle-1);
            }
            else
            {
                remanda=((divisionesafectadas*divisiones)+divisiones)-(firsttitle-1);
            }
            cierre=((cantidaddeelementos+(firsttitle-1))-((secciones*divisiones)));
        }
    }
    else{
        //NSLog(@"CC");
        total=cantidaddeelementos+(firsttitle-1);
        if ((firsttitle-1)==0) {
             //NSLog(@"Caso3");
            total=cantidaddeelementos;
            secciones=1;
            divisionesafectadas=0;
            remanda=0;
            cierre=0;
        }
        else{
            //NSLog(@"DD");
             //NSLog(@"Caso4");
            total=cantidaddeelementos+(firsttitle-1);
            secciones=1;
            divisionesafectadas=1;
            remanda=(total)-(firsttitle-1);
            cierre=0;
        }
    }
    //NSLog(@"division%i,fdivisiones%f",divisiones,fdivision);
    float remantente=fdivision-divisiones;
    if (remantente<.6) {
        //NSLog(@"EE");
        if ((firsttitle)>=(total-2)) {
            divisionesafectadas=((firsttitle-1)/fdivision);
        }
        else{
        divisionesafectadas=((firsttitle-1)/divisiones);
        }
        
       // NSLog(@" First%i,divisionesafectadas%i fdivision %f",firsttitle,divisionesafectadas,fdivision);
        remanda=((divisionesafectadas+1)*divisiones)-(firsttitle-1);
        //NSLog(@"Remanda%i",remanda);
        cierre=0;
    }
    else{
        
    }
    [self.tableView reloadData];
    //NSLog(@" Secciones%i,First%i,divisionesafectadas%i fdivision %f",secciones,firsttitle,divisionesafectadas,fdivision);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (total>0) {
        if (divisiones==0) {
            return 1;
        }
        else{
            return secciones;
        }
    }
    else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (total>0) {
        if (fdivision==0) {
            return total;
        }
        else{
            if (total % divisiones == 0) {
                if (section<divisionesafectadas) {
                    return 0;
                }
                else if (section==divisionesafectadas) {
                    if (remanda==0) {
                    return divisiones;
                    }
                    else{
                    return remanda;
                    }
                }
                else{
                    return divisiones;
                }
            }
            else
            {
                if (section<divisionesafectadas) {
                    //NSLog(@"SeccionA%i Cantidad%i",section,0);
                    return 0;
                    
                }
                else if (section==divisionesafectadas) {
                    if (remanda==0) {
                        if (cantidaddeelementos<fdivision) {
                            //NSLog(@"SeccionB%i Cantidad%i",section,cantidaddeelementos);
                            return cantidaddeelementos;
                            
                        }
                        else{
                            //NSLog(@"SeccionC%i Cantidad%i",section,divisiones);
                            return divisiones;
                            
                        }

                    }
                    else{
                        if (cantidaddeelementos<fdivision) {
                            //NSLog(@"SeccionD%i Cantidad%i",section,cantidaddeelementos);
                            return cantidaddeelementos;
                            
                        }
                        else{
                            // NSLog(@"SeccionE%i Cantidad%i",section,remanda);
                            return remanda;
                           
                        }
                    }
                }
                
                else if (section<=(secciones-2)) {
                    //NSLog(@"SeccionF%i Cantidad%i",section,(divisiones*section)-(divisiones*(section-1)));
                    return (divisiones*section)-(divisiones*(section-1));
                    
                }
                else{
                    //NSLog(@"Total%i",total);
                    int a=(divisiones*(section));
                    //NSLog(@"InfoA %i",a);
                    //NSLog(@"SeccionG%i Cantidad%i",section,total-a);
                return total-a;
                    
                }
            }
            
        }
    }
    else{
        return 1;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (divisiones==0) {
        return @"";
    }
    else{
    return [NSString stringWithFormat:@"%@ %i",cabecera,section+1];
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CountryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor=[UIColor clearColor];
    NSString *tituloss=@"";

    if (divisiones==0) {
        tituloss = [titulo2 objectAtIndex:indexPath.row];
        //NSLog(@"CasoA=%@",[titulo2 objectAtIndex:indexPath.row]);
    }
    else{
        if (indexPath.section<divisionesafectadas) {
            tituloss=@"";
            //NSLog(@"CasoB=%@",[titulo2 objectAtIndex:indexPath.row]);
        }
        else if (indexPath.section==divisionesafectadas) {
            tituloss = [titulo2 objectAtIndex:(indexPath.row)];
            //NSLog(@"CasoC=%@",[titulo2 objectAtIndex:indexPath.row]);
        }
        else if (indexPath.section<(secciones)-2) {
            if (remanda==0) {
                tituloss = [titulo2 objectAtIndex:(indexPath.row)+divisiones+((indexPath.section-1-divisionesafectadas)*divisiones)];
                //NSLog(@"CasoD=%@",[titulo2 objectAtIndex:(indexPath.row)+divisiones+((indexPath.section-1-divisionesafectadas)*divisiones)]);
            }
            else{
            tituloss = [titulo2 objectAtIndex:(indexPath.row)+remanda+((indexPath.section-1-divisionesafectadas)*divisiones)];
                  //NSLog(@"CasoE=%@",[titulo2 objectAtIndex:(indexPath.row)+remanda+((indexPath.section-1-divisionesafectadas)*divisiones)]);
            }
        }
        else{
            if (firsttitle>=0) {
                if (remanda==0) {
                    //tituloss=@"Finished Evaluation";
                    tituloss = [titulo2 objectAtIndex:(indexPath.row)+divisiones+((indexPath.section-1-divisionesafectadas)*divisiones)];
                    //NSLog(@"CasoF=%@", [titulo2 objectAtIndex:(indexPath.row)+divisiones+((indexPath.section-1-divisionesafectadas)*divisiones)]);
                   
                    
                }
                else if(remanda<0){
                    //NSLog(@"Log2");
                    tituloss=@"Finished Evaluation";
                    //NSLog(@"CasoG=%@", @"Finished Evaluation");
                }
                else {
                    if (divisionesafectadas!=-2147483648) {
                    tituloss = [titulo2 objectAtIndex:(indexPath.row)+remanda+((indexPath.section-1-divisionesafectadas)*divisiones)];
                    //NSLog(@"CasoH=%@", [titulo2 objectAtIndex:(indexPath.row)+remanda+((indexPath.section-1-divisionesafectadas)*divisiones)]);
                    }
                    else{
                    //NSLog(@"Log3");
                    tituloss=@"Finished Evaluation";
                    }
                    
                }
            }
            else{
                //NSLog(@"Log4");
                tituloss=@"Finished Evaluation";
            }


        }
        
        
	
    }
	cell.textLabel.text = tituloss;
    cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.textLabel.numberOfLines = 1;
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.textLabel.font = [UIFont  fontWithName:@"Futura-CondensedMedium" size:tamtit];
   
    NSString *subtitulos=@"";
    if (divisiones==0) {
        subtitulos = [subtitulo objectAtIndex:indexPath.row];
        
    }
    else{
        //subtitulos = [subtitulo objectAtIndex:(indexPath.section*divisiones)+(indexPath.row)];
    }
    cell.detailTextLabel.text=subtitulos;
    cell.detailTextLabel.numberOfLines=2;
    cell.detailTextLabel.font = [UIFont fontWithName:@"Futura-CondensedMedium" size:tamsubtit];
    cell.detailTextLabel.textColor=[UIColor whiteColor];
    cell.detailTextLabel.backgroundColor=[UIColor clearColor];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSRange Alto = [cell.textLabel.text rangeOfString:@"_"];
    if (Alto.location!=2147483647) {
        NSString *ID=[cell.textLabel.text substringWithRange:NSMakeRange(0, Alto.location)];
        NSString *TareaAsignar=ID;
        [self.delegadotase setselected:TareaAsignar fun:funcion];
    }
    


    
    
    
    
}





@end

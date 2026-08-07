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
    if (!divisiones==0) {
        if ((firsttitle-1)==0) {
            total=cantidaddeelementos;
            secciones=total/divisiones;
            divisionesafectadas=0;
            remanda=0;
            cierre=total-(secciones*divisiones);
            }
        else{
            total=cantidaddeelementos+(firsttitle-1);
            secciones=total/divisiones;
            divisionesafectadas=(firsttitle-1)/divisiones;
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
        if ((firsttitle-1)==0) {
            total=cantidaddeelementos;
            secciones=1;
            divisionesafectadas=0;
            remanda=0;
            cierre=0;
        }
        else{
            total=cantidaddeelementos+(firsttitle-1);
            secciones=1;
            divisionesafectadas=1;
            remanda=(total)-(firsttitle-1);
            cierre=0;
        }
    }
    [self.tableView reloadData];
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
            if (total % divisiones == 0) {
                return secciones;
            } else
            {
                return (secciones+1);
            }
            
            }
    }
    else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (total>0) {
        if (divisiones==0) {
            return total;
        }
        else{
            if (total % divisiones == 0) {
                if (section<divisionesafectadas) {
                    return 0;
                }
                if (section==divisionesafectadas) {
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
                    return 0;
                }
                if (section==divisionesafectadas) {
                    if (remanda==0) {
                        if (cantidaddeelementos<divisiones) {
                            return cantidaddeelementos;
                        }
                        else{
                            return divisiones;
                        }

                    }
                    else{
                        if (cantidaddeelementos<divisiones) {
                            return cantidaddeelementos;
                        }
                        else{
                            return remanda;
                        }
                    }
                }
                if (section<=(secciones)-1) {
                    return divisiones;
                }
                else{
                return (total-(divisiones*secciones));
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
    //NSLog(@"SeccionSSS %i",(indexPath.section));
    //NSLog(@"FilaSSS %i",(indexPath.row));
    if (divisiones==0) {
        tituloss = [titulo2 objectAtIndex:indexPath.row];
    }
    else{
        if (indexPath.section<divisionesafectadas) {
            tituloss=@"";
        }
        else if (indexPath.section==divisionesafectadas) {
            tituloss = [titulo2 objectAtIndex:(indexPath.row)];
        }
        else if (indexPath.section<(secciones)) {
            if (remanda==0) {
                tituloss = [titulo2 objectAtIndex:(indexPath.row)+divisiones+((indexPath.section-1-divisionesafectadas)*divisiones)];
            }
            else{
            tituloss = [titulo2 objectAtIndex:(indexPath.row)+remanda+((indexPath.section-1-divisionesafectadas)*divisiones)];
            }
        }
        else{
            //NSLog(@"Seccion %i",(indexPath.section));
            if (remanda==0) {
                tituloss = [titulo2 objectAtIndex:(indexPath.row)+divisiones+((indexPath.section-1-divisionesafectadas)*divisiones)];
            }
            else{
                 tituloss = [titulo2 objectAtIndex:(indexPath.row)+remanda+((indexPath.section-1-divisionesafectadas)*divisiones)];
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

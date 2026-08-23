//
//  Resultados Finales.h
//  Xvaluapp
//
//  Created by Enrique Galicia on 02/04/14.
//  Copyright (c) 2014 Enrique Galicia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Resultado1 : UITableViewCell{
    IBOutlet UIView *contentview;
    
}
+ (NSString *)reuseIdentifier;

@property(nonatomic,retain)IBOutlet UILabel *idd;
@property(nonatomic,retain)IBOutlet UILabel *nombre;
@property(nonatomic,retain)IBOutlet UILabel *calificacion;
@property(nonatomic,retain)NSString *SBandera;
@property(nonatomic,retain)IBOutlet UIImageView *Bandera;
@property(nonatomic,retain)UIColor *Letra;

@end

//
//  CalifIndividual.h
//  Xvaluapp
//
//  Created by Enrique Galicia on 02/04/14.
//  Copyright (c) 2014 Enrique Galicia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalifIndividual : UITableViewCell{

}
@property(weak,nonatomic)IBOutlet UILabel *idd;
@property(weak,nonatomic)IBOutlet UILabel *nombre;
@property(weak,nonatomic)IBOutlet UILabel *califica;
@property(nonatomic,retain)UIColor *Letra;
@end

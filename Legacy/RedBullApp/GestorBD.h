//
//  GestorBD.h
//  GestorBIM
//
//  Created by Enrique Galicia on 20/03/14.
//
//

#import <Foundation/Foundation.h>
#import "DataBase.h"


@interface GestorBD : NSObject{
    DataBase *Basedatos;
    NSMutableDictionary *valores;
}
-(id)initwithdatabases:(NSString*)base;
-(void)saveinfo:(NSArray*)info val:(NSString*)val testigo:(NSString*)testigo tabla:(NSString*)tabla campo:(NSString*)campo nombre:(NSString*)nombre;
-(void)updateinfo:(NSString*)info;
-(NSDictionary*)getalltb:(NSString*)tabla val:(NSString*)val;
-(NSDictionary*)getselecteddatast:(NSString*)st val:(NSArray*)val;
-(NSDictionary*)getselecteddatatb:(NSString*)tabla val:(NSArray*)val;
-(NSString*)getsingle:(NSString*)statement;
-(void)renewal:(NSString*)tabla tablas:(NSString*)tablas;
-(void)saveinfo2:(NSArray*)info val:(NSString*)val testigo:(NSString*)testigo tabla:(NSString*)tabla campo:(NSString*)campo nombre:(NSString*)nombre campo2:(NSString*)campo2 nombre2:(NSString*)nombre2;
-(void)saveinfo2update:(NSArray*)info val:(NSString*)val testigo:(NSString*)testigo tabla:(NSString*)tabla campo:(NSString*)campo nombre:(NSString*)nombre campo2:(NSString*)campo2 nombre2:(NSString*)nombre2 cupdate:(NSString*)cupdate vupdate:(NSString*)vupdate;

@end

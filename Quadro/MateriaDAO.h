//
//  MateriaDAO.h
//  Quadro
//
//  Created by LUIZ ILHA M MACIEL on 3/17/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Materia.h"

@interface MateriaDAO : NSObject

+ (void) salva:(Materia *)materia;
+ (void) deleta:(Materia *)materia;
+ (void) altera:(Materia *)materia;
+ (NSMutableArray *) lista;

@end

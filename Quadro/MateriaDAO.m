//
//  MateriaDAO.m
//  Quadro
//
//  Created by LUIZ ILHA M MACIEL on 3/17/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

#import "MateriaDAO.h"
#import "Managerdb.h"

@implementation MateriaDAO

+ (void) salva:(Materia *)materia {
    if ([[Managerdb sharedManager] opendb]) {
        [[[Managerdb sharedManager] database] executeUpdate:@"insert into materia(nome) values(?)",materia.nome];
        [[Managerdb sharedManager] closedb];
    }
}

+ (void) deleta:(Materia *)materia {
    if ([[Managerdb sharedManager] opendb]) {
        [[[Managerdb sharedManager] database] executeUpdate:@"delete from materia where idMateria = ?", materia.idMateria];
        [[Managerdb sharedManager] closedb];
    }
}

+ (void) altera:(Materia *)materia {
    if ([[Managerdb sharedManager] opendb]) {
        [[[Managerdb sharedManager] database] executeUpdate:@"update materia set nome=? where idMateria=?",materia.nome, materia.idMateria];
        [[Managerdb sharedManager] closedb];
    }
}

+ (NSMutableArray *) lista {
    NSMutableArray *nova = [[NSMutableArray alloc] init];
    if ([[Managerdb sharedManager] opendb]) {
        FMResultSet *rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from materia"];
        while ([rs next]) {
            Materia *materia = [[Materia alloc] initMateria:[rs stringForColumn:@"nome"]];
            materia.idMateria = [rs intForColumn:@"idMateria"];
            [nova addObject:materia];
        }
        [rs close];
        [[Managerdb sharedManager] closedb];
    }
    return nova;
}

@end

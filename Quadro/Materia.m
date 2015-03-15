//
//  Materia.m
//  Quadro
//
//  Created by Luiz Ilha on 2/12/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

#import "Materia.h"
#import "Managerdb.h"


@implementation Materia


-(instancetype)initMateria:(NSString *)nome {
    self = [super init];
    if (self) {
        self.nome = nome;
        if (self.assuntos == nil) {
            self.assuntos = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)saveMateria {
    if ([[Managerdb sharedManager] opendb]) {
        [[[Managerdb sharedManager] database] executeUpdate:@"insert into materia(nome) values(?)",self.nome];
        [[Managerdb sharedManager] closedb];
    }
}

- (void)deleteMateria {
    if ([[Managerdb sharedManager] opendb]) {
        FMResultSet *rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from materia where nome=?",self.nome];
        NSString *idMateria = @"0";
        if ([rs next]) {
            idMateria =  [NSString stringWithFormat:@"%d", [rs intForColumn:@"idMateria"]];
            bool deu = [[[Managerdb sharedManager] database] executeUpdate:@"delete from assunto where idMateria=?",idMateria];
            NSLog(@"%d", deu);
            deu = [[[Managerdb sharedManager] database] executeUpdate:@"delete from materia where nome=?",self.nome];
            NSLog(@"%d", deu);
        }
        [rs close];
        [[Managerdb sharedManager] closedb];
    }
}

- (void)alteraMateria:(NSString *)novo {
    if ([[Managerdb sharedManager] opendb]) {
        [[[Managerdb sharedManager] database] executeUpdate:@"update materia set nome=? where nome=?",novo,self.nome];
        [[Managerdb sharedManager] closedb];
    }
}
@end

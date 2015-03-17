//
//  Materia.m
//  Quadro
//
//  Created by Luiz Ilha on 2/12/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

#import "Materia.h"
#import "Managerdb.h"
#import "FotoComAnotacao.h"

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

- (void)savedb {
    if ([[Managerdb sharedManager] opendb]) {
        [[[Managerdb sharedManager] database] beginTransaction];
        [[[Managerdb sharedManager] database] executeUpdate:@"insert into materia(nome) values(?)",self.nome];
        [[[Managerdb sharedManager] database] commit];
        [[Managerdb sharedManager] closedb];
    }
}

- (void)deletedb {
    if ([[Managerdb sharedManager] opendb]) {
        [[[Managerdb sharedManager] database] beginTransaction];
            FMResultSet *rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from materia where nome = ?", self.nome];
        if ([rs next]) {
            int idMateria = [rs intForColumn:@"idMateria"];
            [rs close];
            rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from assunto where idMateria = ?",[NSString stringWithFormat:@"%d",idMateria]];
            while ([rs next]) {
                int idAssunto = [rs intForColumn:@"idAssunto"];
                FMResultSet *rs2 = [[[Managerdb sharedManager] database] executeQuery:@"select * from fotoComAnotacao where idAssunto = ?",[NSString stringWithFormat:@"%d",idAssunto]];
                while ([rs2 next]) {
                    [FotoComAnotacao removeImagemDisco:[rs2 stringForColumn:@"caminhoDaFoto"]];
                }
                [[[Managerdb sharedManager] database] executeUpdate:@"delete from fotoComAnotacao where idAssunto=?",[NSString stringWithFormat:@"%d",idAssunto]];
                [[[Managerdb sharedManager] database] executeUpdate:@"delete from assunto where idMateria=?",[NSString stringWithFormat:@"%d",idMateria]];
            }
            [[[Managerdb sharedManager] database] executeUpdate:@"delete from materia where idMateria=?",[NSString stringWithFormat:@"%d",idMateria] ];
        }
        [[[Managerdb sharedManager] database] commit];
        [[Managerdb sharedManager] closedb];
    }
}

- (void)alteradb:(NSString *)novo {
    if ([[Managerdb sharedManager] opendb]) {
        [[[Managerdb sharedManager] database] executeUpdate:@"update materia set nome=? where nome=?",novo,self.nome];
        [[Managerdb sharedManager] closedb];
    }
}

+ (NSMutableArray *) listadb {
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

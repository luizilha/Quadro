//
//  Materia.m
//  Quadro
//
//  Created by Luiz Ilha on 2/9/15.
//  Copyright (c) 2015 Ilha. All rights reserved.
//

#import "Assunto.h"
#import "Managerdb.h"

@implementation Assunto

-(instancetype)initAssuntoPorData:(NSDate *)dataPublicacao comNomeAssunto:(NSString *)nomeAssunto {
    self = [super init];
    if (self) {
        self.dataPublicacao = dataPublicacao;
        self.nome = nomeAssunto;
        if (self.listaFotosComAnotacao == nil) {
            self.listaFotosComAnotacao = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)saveAssunto:(Materia *)materia {
    if ([[Managerdb sharedManager] opendb]) {
        FMResultSet *rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from materia where nome=?",materia.nome];
        if ([rs next]) {
            NSLog(@"NOME: %@",self.nome);
            BOOL salvo = [[[Managerdb sharedManager] database] executeUpdate:@"insert into assunto(nome, dataPublicacao, idMateria) values(?,?,?)",self.nome, self.dataPublicacao,[NSString stringWithFormat:@"%d",[rs intForColumn:@"idMateria"]]];
            NSLog(@"%d", salvo);
        }
        [rs close];
        [[Managerdb sharedManager] closedb];
    }
}

+ (void)todosAssuntosDaMateria:(Materia *)materia {
    if ([[Managerdb sharedManager] opendb]) {
        FMResultSet *rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from materia where nome=?",materia.nome];
        int idMateria = 0;
        if ([rs next]) idMateria = [rs intForColumn:@"idMateria"];
        [rs close];
        [[Managerdb sharedManager] closedb];
        [[Managerdb sharedManager] opendb];
        FMResultSet *rs2 = [[[Managerdb sharedManager] database] executeQuery:@"select * from assunto where idMateria=?",[NSString stringWithFormat:@"%d", idMateria]];
        while ([rs2 next]) {
            Assunto *assunto = [[Assunto alloc] initAssuntoPorData:[rs2 dateForColumn:@"dataPublicacao"] comNomeAssunto:[rs2 stringForColumn:@"nome"]];
            [materia.assuntos addObject:assunto];
        }
        [rs close];

    }
}


@end

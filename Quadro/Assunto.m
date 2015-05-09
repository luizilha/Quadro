//
//  Materia.m
//  Quadro
//
//  Created by Luiz Ilha on 2/9/15.
//  Copyright (c) 2015 Ilha. All rights reserved.
//

#import "Assunto.h"
#import "Managerdb.h"
#import "FotoComAnotacao.h"

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

- (void)savedb:(Materia *)materia {
    if ([[Managerdb sharedManager] opendb]) {
        FMResultSet *rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from materia where nome=?",materia.nome];
        if ([rs next]) {
            [[[Managerdb sharedManager] database] executeUpdate:@"insert into assunto(nome, dataPublicacao, idMateria) values(?,?,?)",self.nome, self.dataPublicacao,[NSString stringWithFormat:@"%d",[rs intForColumn:@"idMateria"]]];
        }
        [rs close];
        [[Managerdb sharedManager] closedb];
    }
}

- (void)deletedb:(int) posicaoMateria {
    if ([[Managerdb sharedManager] opendb]) {
        [[[Managerdb sharedManager] database] beginTransaction];
        FMResultSet *rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from assunto where nome = ? and idMateria = ?", self.nome,
                           [NSString stringWithFormat:@"%d",posicaoMateria+1]];
        if ([rs next]) {
            int idAssunto = [rs intForColumn:@"idAssunto"];
            [rs close];
            rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from fotoComAnotacao where idAssunto = ?",[NSString stringWithFormat:@"%d", idAssunto]];
            while ([rs next]) {
                [FotoComAnotacao removeImagemDisco:[rs stringForColumn:@"caminhoDaFoto"]];
            }
            [[[Managerdb sharedManager] database] executeUpdate:@"delete from fotoComAnotacao where idAssunto = ?",[NSString stringWithFormat:@"%d", idAssunto]];
            [[[Managerdb sharedManager] database] executeUpdate:@"delete from assunto where idAssunto = ?",[NSString stringWithFormat:@"%d", idAssunto]];
        }
        [[[Managerdb sharedManager] database] commit];
        [[Managerdb sharedManager] closedb];
    }
    
    
    if ([[Managerdb sharedManager] opendb]) {
        [[[Managerdb sharedManager] database] executeUpdate:@"delete from assunto where nome = ? and idMateria = ?", self.nome, [NSString stringWithFormat:@"%d",posicaoMateria+1]];
        [[Managerdb sharedManager] closedb];
    }
}

- (void)alteradb:(NSString *)novo eIdMateria:(int)idMateria {
    if ([[Managerdb sharedManager] opendb]) {
        [[[Managerdb sharedManager] database] executeUpdate:@"update assunto set nome=? where nome=? and idMateria=?", novo, self.nome, [NSString stringWithFormat:@"%d",idMateria+1]];
        [[Managerdb sharedManager] closedb];
    }
}

+ (void)listadb:(Materia *)materia {
    if ([[Managerdb sharedManager] opendb]) {
        FMResultSet *rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from materia where nome=?",materia.nome];
        int idMateria = 0;
        if ([rs next]) idMateria = [rs intForColumn:@"idMateria"];
        [rs close];
        rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from assunto where idMateria=?",[NSString stringWithFormat:@"%d", idMateria]];
        materia.assuntos = [[NSMutableArray alloc] init];
        while ([rs next]) {
            Assunto *assunto = [[Assunto alloc] initAssuntoPorData:[rs dateForColumn:@"dataPublicacao"] comNomeAssunto:[rs stringForColumn:@"nome"]];
            [materia.assuntos addObject:assunto];
        }
        [rs close];
        [[Managerdb sharedManager] closedb];
    }
}





@end

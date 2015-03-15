//
//  FotoComentada.m
//  Quadro
//
//  Created by Luiz Ilha on 2/10/15.
//  Copyright (c) 2015 Ilha. All rights reserved.
//

#import "FotoComAnotacao.h"
#import "Managerdb.h"

@implementation FotoComAnotacao

-(instancetype)initFotoComentada:(UIImage *)foto comComentario:(NSString *) comentario {
    self = [super init];
    if (self) {
        self.foto = foto;
        self.anotacao = comentario;
    }
    return self;
}

- (void)saveFoto:(Assunto *)assunto {
    if ([[Managerdb sharedManager] opendb]) {
        FMResultSet *rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from assunto where nome=?",assunto.nome];
        if ([rs next]) {
            BOOL salvo = [[[Managerdb sharedManager] database] executeUpdate:@"insert into fotoComAnotacao(caminhoDaFoto, anotacao, idAssunto) values(?,?,?)",self.caminhoDaFoto, self.anotacao,[NSString stringWithFormat:@"%d",[rs intForColumn:@"idAssunto"]]];
            NSLog(@"%d", salvo);
        }
        [rs close];
        [[Managerdb sharedManager] closedb];
    }
}

+ (void)todasFotos:(Assunto *)assunto {
    if (assunto.listaFotosComAnotacao.count == 0) {
        


    if ([[Managerdb sharedManager] opendb]) {
        FMResultSet *rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from assunto where nome=?",assunto.nome];
        int idAssunto = 0;
        if ([rs next]) idAssunto = [rs intForColumn:@"idAssunto"];
        [rs close];
        rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from fotoComAnotacao where idAssunto=?",[NSString stringWithFormat:@"%d", idAssunto]];
        assunto.listaFotosComAnotacao = [[NSMutableArray alloc] init];
        while ([rs next]) {
            NSLog(@"%@",[rs stringForColumn:@"caminhoDaFoto"]);
            
            UIImage* image = [UIImage imageWithContentsOfFile:[rs stringForColumn:@"caminhoDaFoto"]];
            FotoComAnotacao *foto = [[FotoComAnotacao alloc] initFotoComentada:image comComentario:[rs stringForColumn:@"anotacao"]];
            [assunto.listaFotosComAnotacao addObject:foto];
        }
        [rs close];
        [[Managerdb sharedManager] closedb];
    }
    }
}

@end

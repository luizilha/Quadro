//
//  Materia.m
//  Quadro
//
//  Created by Luiz Ilha on 2/9/15.
//  Copyright (c) 2015 Ilha. All rights reserved.
//

#import "Assunto.h"

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

@end

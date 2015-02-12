//
//  Materia.m
//  Quadro
//
//  Created by Luiz Ilha on 2/9/15.
//  Copyright (c) 2015 Ilha. All rights reserved.
//

#import "Materia.h"

@implementation Materia

-(instancetype)initMateriaPorData:(NSDate *)dataPublicacao comNomeMateria:(NSString *)nomeMateria {
    self = [super init];
    if (self) {
        self.dataPublicacao = dataPublicacao;
        self.nomeMateria = nomeMateria;
        if (self.listaFotos == nil) {
            self.listaFotos = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

@end

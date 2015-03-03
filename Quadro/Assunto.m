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
        self.nomeAssunto = nomeAssunto;
        if (self.listaFotosComAnotacao == nil) {
            self.listaFotosComAnotacao = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.dataPublicacao forKey:@"dataPublicacao"];
    [aCoder encodeObject:self.nomeAssunto forKey:@"nomeAssunto"];
    [aCoder encodeObject:self.listaFotosComAnotacao forKey:@"listaFotosComAnotacao"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        self.dataPublicacao = [aDecoder decodeObjectForKey:@"dataPublicacao"];
        self.nomeAssunto = [aDecoder decodeObjectForKey:@"nomeAssunto"];
        self.listaFotosComAnotacao = [aDecoder decodeObjectForKey:@"listaFotosComAnotacao"];
    }
    return self;
}

@end

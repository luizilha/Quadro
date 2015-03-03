//
//  FotoComentada.m
//  Quadro
//
//  Created by Luiz Ilha on 2/10/15.
//  Copyright (c) 2015 Ilha. All rights reserved.
//

#import "FotoComAnotacao.h"

@implementation FotoComAnotacao

-(instancetype)initFotoComentada:(UIImage *)foto comComentario:(NSString *) comentario {
    self = [super init];
    if (self) {
        self.foto = foto;
        self.anotacao = comentario;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if (self) {
        self.foto = [coder decodeObjectForKey:@"foto"];
        self.anotacao = [coder decodeObjectForKey:@"anotacao"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.foto forKey:@"foto"];
    [coder encodeObject:self.anotacao forKey:@"anotacao"];
}

@end

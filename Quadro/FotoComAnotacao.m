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
        self.comentario = comentario;
    }
    return self;
}

@end

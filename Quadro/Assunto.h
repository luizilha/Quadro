//
//  Materia.h
//  Quadro
//
//  Created by Luiz Ilha on 2/9/15.
//  Copyright (c) 2015 Ilha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Assunto : NSObject

@property (nonatomic) NSMutableArray *listaFotosComAnotacao;
@property (nonatomic) NSDate *dataPublicacao;
@property (nonatomic) NSString *nomeAssunto;

-(instancetype)initAssuntoPorData:(NSDate *)dataPublicacao comNomeAssunto:(NSString *)nomeAssunto;

@end

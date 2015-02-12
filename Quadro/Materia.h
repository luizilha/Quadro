//
//  Materia.h
//  Quadro
//
//  Created by Luiz Ilha on 2/9/15.
//  Copyright (c) 2015 Ilha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Materia : NSObject

@property (nonatomic) NSMutableArray *listaFotos;
@property (nonatomic) NSDate *dataPublicacao;
@property (nonatomic) NSString *nomeMateria;

-(instancetype)initMateriaPorData:(NSDate *)dataPublicacao comNomeMateria:(NSString *)nomeMateria;

@end

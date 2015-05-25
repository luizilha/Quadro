//
//  Materia.h
//  Quadro
//
//  Created by Luiz Ilha on 2/9/15.
//  Copyright (c) 2015 Ilha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Materia.h"

@interface Assunto : NSObject

@property (nonatomic) NSMutableArray *listaFotosComAnotacao;
@property (nonatomic) NSDate *dataPublicacao;
@property (nonatomic) NSString *nome;

-(instancetype)initAssuntoPorData:(NSDate *)dataPublicacao comNomeAssunto:(NSString *)nomeAssunto;

- (void)savedb:(int)idMateria;
- (void)deletedb:(int) posicaoMateria;
- (void)alteradb:(NSString *)novo eIdMateria:(int)idMateria;
+ (NSMutableArray *)listadb:(int)idMateria;
+ (int) posicaodb:(Assunto *) assunto;
@end

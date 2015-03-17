//
//  Materia.h
//  Quadro
//
//  Created by Luiz Ilha on 2/12/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Materia : NSObject

@property (nonatomic) int idMateria;
@property (nonatomic) NSString *nome;
@property (nonatomic) NSMutableArray *assuntos;

-(instancetype)initMateria:(NSString *)nome;

- (void)saveMateriadb;
- (void)deleteMateriadb;
- (void)alteraMateriadb:(NSString *)novo;
+ (NSMutableArray *) listadb;

@end

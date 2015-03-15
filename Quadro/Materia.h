//
//  Materia.h
//  Quadro
//
//  Created by Luiz Ilha on 2/12/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Materia : NSObject

@property (nonatomic) NSString *nome;
@property (nonatomic) NSMutableArray *assuntos;

-(instancetype)initMateria:(NSString *)nome;
- (void)saveMateria;
- (void)deleteMateria;
- (void)alteraMateria:(NSString *)novo;
@end

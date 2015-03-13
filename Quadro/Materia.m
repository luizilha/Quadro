//
//  Materia.m
//  Quadro
//
//  Created by Luiz Ilha on 2/12/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

#import "Materia.h"
#import "FMDBManager.h"

@implementation Materia

-(instancetype)initMateria:(NSString *)nome {
    self = [super init];
    if (self) {
        self.nome = nome;
        if (self.assuntos == nil) {
            self.assuntos = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)saveMateria:(NSString *)nome {
    FMDBManager *manager = [[FMDBManager alloc] init];
    [manager.database executeUpdate:@"insert into materia(nome) values(?)",self.nome];
}

- (void)deleteMateria:(int)posicao {
    FMDBManager *manager = [[FMDBManager alloc] init];
    [manager.database executeUpdate:@"delete from materia where idMateria=?",posicao];
}

@end

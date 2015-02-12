//
//  Materia.m
//  Quadro
//
//  Created by Luiz Ilha on 2/12/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

#import "Materia.h"

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


@end

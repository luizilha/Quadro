//
//  MateriaPorDataSingleton.m
//  Quadro
//
//  Created by Luiz Ilha on 2/3/15.
//  Copyright (c) 2015 Ilha. All rights reserved.
//

#import "TodasMateriasSingleton.h"

@implementation TodasMateriasSingleton

+(instancetype) init {
    @throw [NSException exceptionWithName:@"metodo nao permitido" reason:@"utiize [MateriaPorDataSingleton sharedInstance]" userInfo:nil];
    return nil;
}

+(id)sharedInstance {
    static TodasMateriasSingleton *sharedMateria = nil;
    if (sharedMateria == nil) {
        sharedMateria = [[self alloc] initPrivate];
    }
    return sharedMateria;
}

- (id)initPrivate {
    self = [super init];
    if (self) {
        self.listaDeMaterias = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)loadData
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"materias"];
    if (data) {
        self.listaDeMaterias = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

-(void)saveData
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.listaDeMaterias];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"materias"];
}


@end

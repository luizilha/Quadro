//
//  MateriaPorDataSingleton.m
//  Quadro
//
//  Created by Luiz Ilha on 2/3/15.
//  Copyright (c) 2015 Ilha. All rights reserved.
//

#import "TodasMateriasSingleton.h"
#import "FMDBManager.h"
#import "Materia.h"
#import "Assunto.h"
#import "FotoComAnotacao.h"
#import "Materia.h"


#import <sqlite3.h>

@implementation TodasMateriasSingleton
{
    NSString *_databasePath;
    sqlite3 *_db;
}

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
    FMDBManager *manager = [[FMDBManager alloc] init];
    [manager.database executeUpdate:@"CREATE TABLE IF NOT EXISTS materia(idMateria integer primary key, nome text not null);"];
    
    
    FMResultSet *rs = [manager.database executeQuery:@"select * from materia"];
    while ([rs next]) {
        [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] addObject:[[Materia alloc] initMateria:[rs stringForColumn:@"nome"]]];
    }
    [rs close];
    [manager.database beginTransaction];
}

-(void)saveData
{
    int cont = 1;
    for (Materia *materia in self.listaDeMaterias) {
        for (Assunto *assunto in materia.assuntos) {
            for (FotoComAnotacao *foto in assunto.listaFotosComAnotacao) {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
                NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@_%d",materia.nome,assunto.nome,cont++]];
                foto.caminhoDaFoto = filePath;
                [UIImagePNGRepresentation(foto.foto) writeToFile:filePath atomically:YES];
            }
        }
    }
}


@end

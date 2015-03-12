//
//  MateriaPorDataSingleton.m
//  Quadro
//
//  Created by Luiz Ilha on 2/3/15.
//  Copyright (c) 2015 Ilha. All rights reserved.
//

#import "TodasMateriasSingleton.h"
#import "FMDBManager.h"
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
    [manager.database beginTransaction];
//    NSString *docDir;
//    NSArray *dirPaths;
//    
//    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
//    docDir = dirPaths[0];
//    
//    _databasePath = [[NSString alloc] initWithString:[docDir stringByAppendingPathComponent:@"myUser.db"]];
//    NSFileManager *fileMgr = [NSFileManager defaultManager];
//    if ([fileMgr fileExistsAtPath:_databasePath] == NO) {
//        const char *dbPath = [_databasePath UTF8String];
//        if (sqlite3_open(dbPath, &_db) == SQLITE_OK) {
//            char *errorMessage;
//            const char *sqlStm = "CREATE TABLE IF NOT EXISTS fotoComAnotacao (idFotoComAnotacao INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT)";
//            
//            if (sqlite3_exec(_db, sqlStm, NULL, NULL, &errorMessage) != SQLITE_OK) {
//                
//            }
//            sqlite3_close(_db);
//        }
//    }
//    
//    
// NSCODING REMOVER SE CONSEGUIR IMPLEMENTAR SQLITE3
    
}

-(void)saveData
{
   
}


@end

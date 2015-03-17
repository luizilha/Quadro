//
//  FotoComentada.m
//  Quadro
//
//  Created by Luiz Ilha on 2/10/15.
//  Copyright (c) 2015 Ilha. All rights reserved.
//

#import "FotoComAnotacao.h"
#import "Managerdb.h"

@implementation FotoComAnotacao

-(instancetype)initFotoComentada:(UIImage *)foto comComentario:(NSString *) comentario {
    self = [super init];
    if (self) {
        self.foto = foto;
        self.anotacao = comentario;
    }
    return self;
}

- (void)saveFotodb:(Assunto *)assunto {
    if ([[Managerdb sharedManager] opendb]) {
        FMResultSet *rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from assunto where nome=?",assunto.nome];
        if ([rs next]) {
            NSLog(@"%d",[rs intForColumn:@"idAssunto"]);
            BOOL salvo = [[[Managerdb sharedManager] database] executeUpdate:@"insert into fotoComAnotacao(caminhoDaFoto, anotacao, idAssunto) values(?,?,?)",self.caminhoDaFoto, self.anotacao,[NSString stringWithFormat:@"%d",[rs intForColumn:@"idAssunto"]]];
            NSLog(@"%d", salvo);
        }
        [rs close];
        [[Managerdb sharedManager] closedb];
    }
}

- (void) mudaAnotacaodb {
    if ([[Managerdb sharedManager] opendb]) {
        [[[Managerdb sharedManager] database] executeUpdate:@"update fotoComAnotacao set anotacao = ? where caminhoDaFoto = ?",self.anotacao,self.caminhoDaFoto];
    }
    [[Managerdb sharedManager] closedb];
}


+ (void)todasFotosdb:(Assunto *)assunto {
    if (assunto.listaFotosComAnotacao.count == 0) {

    if ([[Managerdb sharedManager] opendb]) {
        FMResultSet *rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from assunto where nome=?",assunto.nome];
        int idAssunto = 0;
        if ([rs next]) idAssunto = [rs intForColumn:@"idAssunto"];
        [rs close];
        rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from fotoComAnotacao where idAssunto=?",[NSString stringWithFormat:@"%d", idAssunto]];
        assunto.listaFotosComAnotacao = [[NSMutableArray alloc] init];
        while ([rs next]) {
            FotoComAnotacao *foto = [[FotoComAnotacao alloc] initFotoComentada:nil comComentario:[rs stringForColumn:@"anotacao"]];
            foto.caminhoDaFoto = [rs stringForColumn:@"caminhoDaFoto"];
            foto.foto = [foto loadImage];
            [assunto.listaFotosComAnotacao addObject:foto];
        }
        [rs close];
        [[Managerdb sharedManager] closedb];
    }
    }
}

- (BOOL)saveImage: (UIImage*)image
{
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@", self.caminhoDaFoto]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]) {
            return false;
        }
        NSData* data =  UIImageJPEGRepresentation(image, 1);
        [data writeToFile:path atomically:YES];
        return true;
    }
    return false;
}

- (UIImage*)loadImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"%@", self.caminhoDaFoto]];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}

+ (void)removeImagePorMateria:(Materia *) materia {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    int idMateria = 0;
    int idAssunto = 0;
    if (materia != nil) {
        if ([[Managerdb sharedManager] opendb]) {
            FMResultSet *rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from materia where nome=?",materia.nome];
            if ([rs next]) {
                idMateria = [rs intForColumn:@"idMateria"];
            }
            [rs close];
            rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from assunto where idMateria=?",[NSString stringWithFormat:@"%d",idMateria]];
            if ([rs next]) {
                idAssunto = [rs intForColumn:@"idAssunto"];
            }
            [rs close];
            rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from fotoComAnotacao where idAssunto=?",[NSString stringWithFormat:@"%d",idAssunto]];
            while ([rs next]) {
                NSError *error;
                NSString* path = [documentsDirectory stringByAppendingPathComponent:
                                  [NSString stringWithFormat:@"%@", [rs stringForColumn:@"caminhoDaFoto"]]];
                BOOL success = [fileManager removeItemAtPath:path error:&error];
                if (success) {
                    NSLog(@"REMOVEU FOTO");
                }
            }
            [[Managerdb sharedManager] closedb];
        }
    }
}

+ (void)removeImagePorAssunto:(Assunto *)assunto
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    int idAssunto = 0;
    if (assunto != nil) {
        FMResultSet *rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from assunto where nome=?",assunto.nome];
        if ([rs next]) {
            idAssunto = [rs intForColumn:@"idAssunto"];
        }
        rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from fotoComAnotacao where idAssunto=?",[NSString stringWithFormat:@"%d",idAssunto]];
        while ([rs next]) {
            NSError *error;
            NSString* path = [documentsDirectory stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"%@", [rs stringForColumn:@"caminhoDaFoto"]]];
            BOOL success = [fileManager removeItemAtPath:path error:&error];
            if (success) {
                NSLog(@"REMOVEU FOTO");
            }
        }
    }
}



- (void)nomeDaFotoAssunto:(Assunto *)assunto posicao:(int) posicao
{
    if ([[Managerdb sharedManager] opendb]) {
        FMResultSet *rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from assunto where nome=?",assunto.nome];
        if ([rs next]) {
            self.caminhoDaFoto = [NSString stringWithFormat:@"%d%d%d", [rs intForColumn:@"idMateria"], [rs intForColumn:@"idAssunto"],posicao];
        }
        [rs close];
        [[Managerdb sharedManager] closedb];
    }
}


@end

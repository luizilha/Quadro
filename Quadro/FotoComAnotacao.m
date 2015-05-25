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

- (void)saveFotodb:(Assunto *)assunto comIdMateria: (int) idMateria {
    if ([[Managerdb sharedManager] opendb]) {
        FMResultSet *rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from assunto where idMateria = ? and nome = ?", [NSString stringWithFormat:@"%d",idMateria+1 ], assunto.nome]; // ERRO TA AQUI
        if ([rs next]) {
            int idAssunto = [rs intForColumn:@"idAssunto"];
            [[[Managerdb sharedManager] database] executeUpdate:@"insert into fotoComAnotacao(caminhoDaFoto, anotacao, idAssunto) values(?,?,?)",self.caminhoDaFoto, self.anotacao,[NSString stringWithFormat:@"%d",idAssunto]];
        }
        [rs close];
        [[Managerdb sharedManager] closedb];
    }
}

- (void) mudaAnotacaodb {
    if ([[Managerdb sharedManager] opendb]) {
        if ([[[Managerdb sharedManager] database] executeUpdate:@"update fotoComAnotacao set anotacao = ? where caminhoDaFoto = ?",self.anotacao,self.caminhoDaFoto]) {
            NSLog(@"SALVO!");
        }
    }
    [[Managerdb sharedManager] closedb];
}

- (void) deletedb {
    if ([[Managerdb sharedManager] opendb]) {
           FMResultSet *rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from fotoComAnotacao where caminhoDaFoto = ?", self.caminhoDaFoto];
        if ([rs next]) {
            [FotoComAnotacao removeImagemDisco:self.caminhoDaFoto];
        }
        [rs close];
        [[[Managerdb sharedManager] database] executeUpdate:@"delete from fotoComAnotacao where caminhoDaFoto = ?", self.caminhoDaFoto];
    }
    [[Managerdb sharedManager] closedb];
}

+ (void)todasFotosdb:(Assunto *)assunto comIdMateria: (int) idMateria { // VAI DAR ERRO
    if (assunto.listaFotosComAnotacao.count == 0) {

        if ([[Managerdb sharedManager] opendb]) {
            FMResultSet *rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from assunto where nome=? and idMateria=?",assunto.nome, [NSString stringWithFormat:@"%d", idMateria+1]];
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

+ (NSMutableArray *)todasFotosdb:(int)idAssunto {
    NSMutableArray *listafotos = [[NSMutableArray alloc] init];
    if ([[Managerdb sharedManager] opendb]) {
        FMResultSet *rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from fotoComAnotacao where idAssunto=?",[NSString stringWithFormat:@"%d", idAssunto]];
        while ([rs next]) {
            FotoComAnotacao *foto = [[FotoComAnotacao alloc] initFotoComentada:nil comComentario:[rs stringForColumn:@"anotacao"]];
            foto.caminhoDaFoto = [rs stringForColumn:@"caminhoDaFoto"];
            foto.foto = [foto loadImage];
            [listafotos addObject:foto];
        }
        [rs close];
        [[Managerdb sharedManager] closedb];
    }
    return listafotos;
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

+ (void)removeImagemDisco:(NSString *) caminhoDaFoto {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"%@", caminhoDaFoto]];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:path error:&error];
    if (success) {
        NSLog(@"REMOVEU FOTO");
    }
}

// TEM QUE COLOCAR POSICAO DA MATERIA PRA PEGAR O ID
- (void)nomeDaFotoAssunto:(Assunto *)assunto posicaoFoto:(int) posicao idMateria:(int) idMateria
{
    if ([[Managerdb sharedManager] opendb]) {
        FMResultSet *rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from assunto where nome=? and idMateria=? ",assunto.nome, [NSString stringWithFormat:@"%d",idMateria+1]];
        if ([rs next]) {
            self.caminhoDaFoto = [NSString stringWithFormat:@"%d%d%d", [rs intForColumn:@"idMateria"], [rs intForColumn:@"idAssunto"],posicao];
        }
        [rs close];
        [[Managerdb sharedManager] closedb];
    }
}


@end

//
//  FotoComentada.h
//  Quadro
//
//  Created by Luiz Ilha on 2/10/15.
//  Copyright (c) 2015 Ilha. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
#import "Assunto.h"
#import "Materia.h"

@interface FotoComAnotacao : NSObject

@property (nonatomic) UIImage *foto;
@property (nonatomic) NSString *caminhoDaFoto;
@property (nonatomic) NSString *anotacao;

-(instancetype)initFotoComentada:(UIImage *)foto comComentario:(NSString *) comentario;
- (void)saveFotodb:(Assunto *)assunto;
- (void) mudaAnotacaodb;
+ (void)todasFotosdb:(Assunto *)assunto;
- (BOOL)saveImage: (UIImage*)image;
- (UIImage*)loadImage;
- (void)nomeDaFotoAssunto:(Assunto *)assunto posicao:(int) posicao;

@end

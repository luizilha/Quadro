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

@interface FotoComAnotacao : NSObject

@property (nonatomic) UIImage *foto;
@property (nonatomic) NSString *caminhoDaFoto;
@property (nonatomic) NSString *anotacao;

-(instancetype)initFotoComentada:(UIImage *)foto comComentario:(NSString *) comentario;
- (void)saveFoto:(Assunto *)assunto;
+ (void)todasFotos:(Assunto *)assunto;
- (void)saveImage: (UIImage*)image;
- (UIImage*)loadImage;

@end

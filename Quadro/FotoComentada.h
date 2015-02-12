//
//  FotoComentada.h
//  Quadro
//
//  Created by Luiz Ilha on 2/10/15.
//  Copyright (c) 2015 Ilha. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface FotoComentada : NSObject

@property (nonatomic) UIImage *foto;
@property (nonatomic) NSString *comentario;

-(instancetype)initFotoComentada:(UIImage *)foto comComentario:(NSString *) comentario;

@end

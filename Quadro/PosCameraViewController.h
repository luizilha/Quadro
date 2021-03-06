//
//  PosCameraViewController.h
//  Quadro
//
//  Created by Luiz Ilha on 2/3/15.
//  Copyright (c) 2015 Ilha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PosCameraViewController : UIViewController <UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) UIImage *foto;
@property (nonatomic) NSInteger posicaoMateria, posicaoAssunto;
@property (nonatomic) NSMutableArray *listaDeFotosComAnotacao;

@end

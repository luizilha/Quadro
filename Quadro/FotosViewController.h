//
//  FotosViewController.h
//  Quadro
//
//  Created by Luiz Ilha on 2/19/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FotosViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate, UITextViewDelegate>

@property (nonatomic) int posicaoMateria, posicaoAssunto;

@end

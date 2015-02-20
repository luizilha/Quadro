//
//  FotosCollectionViewCell.h
//  Quadro
//
//  Created by Luiz Ilha on 2/20/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FotosCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *foto;
@property (weak, nonatomic) IBOutlet UITextView *anotacao;

@end

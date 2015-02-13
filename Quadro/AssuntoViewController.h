//
//  AssuntoViewController.h
//  Quadro
//
//  Created by Luiz Ilha on 2/12/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssuntoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) NSMutableArray *assuntos;
@property (nonatomic) NSInteger posicaoMateria;

@end

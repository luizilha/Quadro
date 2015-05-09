//
//  AssuntoViewController.h
//  Quadro
//
//  Created by Luiz Ilha on 2/12/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface AssuntoViewController : GAITrackedViewController
<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) NSInteger posicaoMateria;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barBtn;

@end

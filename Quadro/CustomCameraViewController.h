//
//  CustomCameraViewController.h
//  Quadro
//
//  Created by Luiz Ilha on 2/24/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CustomCameraViewController : UIViewController
@property (nonatomic) NSInteger posicaoMateria, posicaoAssunto;
@property (weak, nonatomic) IBOutlet UIView *cameraFrame;
- (IBAction)takePhoto:(id)sender;

@end

//
//  ZoomImageViewController.m
//  Quadro
//
//  Created by Luiz Ilha on 3/19/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

#import "ZoomImageViewController.h"

@interface ZoomImageViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollImagem;
@property (weak, nonatomic) IBOutlet UIImageView *imagem;

@end

@implementation ZoomImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imagem setImage:self.imagemAux];
    
    [self.scrollImagem setMaximumZoomScale:5.0f];
    [self.scrollImagem setClipsToBounds:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imagem;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  PosCameraViewController.m
//  Quadro
//
//  Created by Luiz Ilha on 2/3/15.
//  Copyright (c) 2015 Ilha. All rights reserved.
//

#import "PosCameraViewController.h"
#import "TodasMateriasSingleton.h"
#import "Materia.h"
#import "FotoComAnotacao.h"
#import "Assunto.h"

@interface PosCameraViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imagem;
@property (weak, nonatomic) IBOutlet UITextField *txtMateria;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alturaFoto;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *larguraFoto;

@end

@implementation PosCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FotoComAnotacao *fotoComAnotacao = [self.listaDeFotosComAnotacao objectAtIndex:self.listaDeFotosComAnotacao.count -1];
    self.imagem.image = fotoComAnotacao.foto;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)terminaEdicao:(id)sender {
    
    
    //FotoComAnotacao *fotoComentada = [[FotoComAnotacao alloc] initFotoComentada:self.foto comComentario:nil];
    Assunto *assunto = [[Assunto alloc] initAssuntoPorData:[NSDate date] comNomeAssunto:self.txtMateria.text];
//    [assunto.listaFotosComAnotacao addObject:fotoComentada];
    assunto.listaFotosComAnotacao = self.listaDeFotosComAnotacao;
    Materia *materia = [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] objectAtIndex:self.posicaoMateria];
    [materia.assuntos addObject:assunto];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.5 animations:^{
        self.alturaFoto.constant -= 150;
        [self.view layoutIfNeeded];
    }];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.txtMateria.isEditing) {
        [UIView animateWithDuration:0.5 animations:^{
            self.alturaFoto.constant += 150;
            [self.view layoutIfNeeded];
        }];
        [self.txtMateria endEditing:YES];
    }
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

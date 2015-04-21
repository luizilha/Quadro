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
#import "PosCollectionViewCell.h"

@interface PosCameraViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imagem;
@property (weak, nonatomic) IBOutlet UITextField *txtMateria;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alturaFoto;
@property (weak, nonatomic) IBOutlet UIButton *btnDeConfirma;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *barraDeLoad;

@end

@implementation PosCameraViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.barraDeLoad.hidden = YES;
    Materia *materia = [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] objectAtIndex:self.posicaoMateria];
    if (materia.assuntos.count != 0) {
        Assunto *assunto = [materia.assuntos objectAtIndex:materia.assuntos.count-1];
        self.txtMateria.text = assunto.nome;
        if (self.txtMateria.text.length < 2) {
            self.btnDeConfirma.enabled = NO;
        }
    } else {
        self.btnDeConfirma.enabled = NO;
    }
    FotoComAnotacao *fotoComAnotacao = [self.listaDeFotosComAnotacao objectAtIndex:self.listaDeFotosComAnotacao.count -1];
    self.imagem.image = fotoComAnotacao.foto;
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listaDeFotosComAnotacao.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"posCell" forIndexPath:indexPath];
    FotoComAnotacao *foto = [self.listaDeFotosComAnotacao objectAtIndex:indexPath.row];
    cell.imagem.image = foto.foto;
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (IBAction)terminaEdicao:(id)sender {
    Materia *materia = [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] objectAtIndex:self.posicaoMateria];
    
    BOOL existe = NO;
    Assunto *assuntoE;
    for (Assunto *a in materia.assuntos) {
        if ([a.nome isEqualToString:self.txtMateria.text]) {
            assuntoE = a;
            existe = YES;
        }
    }
//    self.barraDeLoad.hidden = NO;
    [self.barraDeLoad startAnimating];
    if (existe) {
        int cont = (int) assuntoE.listaFotosComAnotacao.count+1;
        [assuntoE.listaFotosComAnotacao addObjectsFromArray:self.listaDeFotosComAnotacao];
        for (FotoComAnotacao *foto in self.listaDeFotosComAnotacao) {
            [foto nomeDaFotoAssunto:assuntoE posicaoFoto:cont++ idMateria:(int)self.posicaoMateria];
            [self gravaFoto:foto doAssunto:assuntoE comIdMateria:(int)self.posicaoMateria];
        }
    } else {
        Assunto *assunto = [[Assunto alloc] initAssuntoPorData:[NSDate date] comNomeAssunto:self.txtMateria.text];
        assunto.listaFotosComAnotacao = self.listaDeFotosComAnotacao;
        [materia.assuntos addObject:assunto];
        [assunto savedb:materia];
        // VAI TER QUE SALVAR AQUI
        int cont = 1;
        for (FotoComAnotacao *foto in self.listaDeFotosComAnotacao) {
            [foto nomeDaFotoAssunto:assunto posicaoFoto:cont++ idMateria:(int)self.posicaoMateria];
            [self gravaFoto:foto doAssunto:assunto comIdMateria:(int)self.posicaoMateria];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) gravaFoto: (FotoComAnotacao *) foto doAssunto: (Assunto *) assunto comIdMateria: (int) idMateria {
    if ([foto saveImage:foto.foto]) {
        [foto saveFotodb:assunto comIdMateria:idMateria];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.5 animations:^{
        self.alturaFoto.constant += 245;
        [self.view layoutIfNeeded];
    }];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.txtMateria.isEditing) {
        [UIView animateWithDuration:0.5 animations:^{
            self.alturaFoto.constant -= 245;
            [self.view layoutIfNeeded];
        }];
        [self.txtMateria endEditing:YES];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%@",textField.text);
    if (textField.text.length < 4) {
        self.btnDeConfirma.enabled = NO;
    } else {
        self.btnDeConfirma.enabled = YES;
    }
    return YES;
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

//
//  FotosViewController.m
//  Quadro
//
//  Created by Luiz Ilha on 2/19/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

#import "FotosViewController.h"
#import "TodasMateriasSingleton.h"
#import "Materia.h"
#import "Assunto.h"
#import "FotosCollectionViewCell.h"
#import "FotoComAnotacao.h"
@interface FotosViewController ()
@property UIPageViewController *pageViewController;
@property NSUInteger pageIndex;
@property NSMutableArray *fotosComAnotacao;

@end

@implementation FotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Materia *materia = [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] objectAtIndex:self.posicaoMateria];
    Assunto *assunto = [materia.assuntos objectAtIndex:self.posicaoAssunto];
    self.fotosComAnotacao = assunto.listaFotosComAnotacao;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FotosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"fotoAnotacao" forIndexPath:indexPath];
    FotoComAnotacao *fotoComAnotacao = self.fotosComAnotacao[indexPath.row];
    cell.foto.image = fotoComAnotacao.foto;
    cell.anotacao.text = fotoComAnotacao.anotacao !=nil ? fotoComAnotacao.anotacao : @"Nao tem anotacao";
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.fotosComAnotacao.count;
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

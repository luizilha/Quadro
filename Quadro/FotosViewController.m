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
@property NSMutableArray *fotosComAnotacao;
@property int posicao;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property Assunto *assunto;

@end

@implementation FotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    Materia *materia = [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] objectAtIndex:self.posicaoMateria];
//    Assunto *assunto = [materia.assuntos objectAtIndex:self.posicaoAssunto];
//    self.fotosComAnotacao = assunto.listaFotosComAnotacao;
//    NSString *titulo = [NSString stringWithFormat:@"%@ %d/%d",self.navigationItem.title, self.posicao+1,self.fotosComAnotacao.count];
//    self.title = titulo;
    
    self.fotosComAnotacao = [[NSMutableArray alloc]init];
     [self.fotosComAnotacao addObject:@"oioi"];
     [self.fotosComAnotacao addObject:@"oioi"];
     [self.fotosComAnotacao addObject:@"oioi"];
     [self.fotosComAnotacao addObject:@"oioi"];
     [self.fotosComAnotacao addObject:@"oioi"];
     [self.fotosComAnotacao addObject:@"oioi"];
     [self.fotosComAnotacao addObject:@"oioi"];
     [self.fotosComAnotacao addObject:@"oioi"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)deletaFoto:(id)sender {
    [self.fotosComAnotacao removeObjectAtIndex:_posicao];
    if (self.fotosComAnotacao.count == 0) {
        Materia *materia = [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] objectAtIndex:self.posicaoMateria];
        [materia.assuntos removeObjectAtIndex:self.posicaoAssunto];
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self.collectionView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.posicao = indexPath.row;
    FotosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"fotoAnotacao" forIndexPath:indexPath];
    FotoComAnotacao *fotoComAnotacao = self.fotosComAnotacao[indexPath.row];
//    cell.foto.image = fotoComAnotacao.foto;
//    cell.anotacao.text = fotoComAnotacao.anotacao !=nil ? fotoComAnotacao.anotacao : @"Nao tem anotacao";
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.fotosComAnotacao.count;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize  sizeCell = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    return sizeCell;
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

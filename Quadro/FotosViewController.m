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
@property FotosCollectionViewCell *cell;

@property UIPageViewController *pageViewController;
@property NSMutableArray *fotosComAnotacao;
@property NSInteger posicao;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alturaCollection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *posicaoCollection;


@end

@implementation FotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cell.anotacao.delegate = self;
    Materia *materia = [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] objectAtIndex:self.posicaoMateria];
    Assunto *assunto = [materia.assuntos objectAtIndex:self.posicaoAssunto];
    self.fotosComAnotacao = assunto.listaFotosComAnotacao;
    NSString *titulo = [NSString stringWithFormat:@"%@ %d %d",self.navigationItem.title, (int)self.posicao+1, (int)self.fotosComAnotacao.count];
    self.title = titulo;
    
    [self.collectionView reloadData];
    
    //self.collectionView.contentSize = CGSizeMake((self.view.frame.size.width * self.fotosComAnotacao.count), self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)deletaFoto:(id)sender {
    UIActionSheet *alerta = [[UIActionSheet alloc] initWithTitle:@"Foto sera deletada" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:@"Deletar Foto" otherButtonTitles:nil]; //initWithTitle:@"Foto sera deletada" message:@"foto sera deletado permanentemente" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Salvar", nil];
    [alerta showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Deletar Foto"]) {
        [self.fotosComAnotacao removeObjectAtIndex:_posicao];
        if (self.fotosComAnotacao.count == 0) {
            Materia *materia = [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] objectAtIndex:self.posicaoMateria];
            [materia.assuntos removeObjectAtIndex:self.posicaoAssunto];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [self.collectionView reloadData];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.posicao = (long) indexPath.row;
    FotosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"fotoAnotacao" forIndexPath:indexPath];
    self.cell = cell;
    FotoComAnotacao *fotoComAnotacao = self.fotosComAnotacao[indexPath.row];
//    cell.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    cell.foto.image = fotoComAnotacao.foto;
    cell.anotacao.text = fotoComAnotacao.anotacao !=nil ? fotoComAnotacao.anotacao : @"Nao tem anotacao";
    
    cell.anotacao.delegate = self;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.fotosComAnotacao.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [UIView animateWithDuration:0.5 animations:^{
        self.alturaCollection.constant -= 300;
        self.posicaoCollection.constant -= 300;
        [self.view layoutIfNeeded];
    }];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.cell.anotacao.isEditable) {
        [UIView animateWithDuration:0.5 animations:^{
            self.alturaCollection.constant += 300;
            self.posicaoCollection.constant += 300;
            [self.view layoutIfNeeded];
        }];
        [self.cell.anotacao endEditing:YES];
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

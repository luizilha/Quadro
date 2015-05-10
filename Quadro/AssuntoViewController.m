//
//  AssuntoViewController.m
//  Quadro
//
//  Created by Luiz Ilha on 2/12/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

#import "AssuntoViewController.h"
#import "Assunto.h"
#import "AssuntoTableViewCell.h"
#import "TodasMateriasSingleton.h"
#import "Materia.h"
#import "PosCameraViewController.h"
#import "FotosViewController.h"
#import "CustomCameraViewController.h"
#import "FotoComAnotacao.h"
#import "SWRevealViewController.h"

@interface AssuntoViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;
@property NSInteger posicaoAssunto;
@property NSIndexPath *posicaoAlterar; // posicao para alterar

@end

@implementation AssuntoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _barBtn.target = self.revealViewController;
    _barBtn.action = @selector(revealToggle:);
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    Materia *materia = [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] objectAtIndex:self.posicaoMateria];
    [Assunto listadb:materia];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Assunto";
    [_table reloadData];
}


- (IBAction)camera:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CustomCameraViewController *camera = [sb instantiateViewControllerWithIdentifier:@"Camera"];
    camera.posicaoAssunto = self.posicaoAssunto;
    camera.posicaoMateria = self.posicaoMateria;
    [self presentViewController:camera animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PosCameraViewController *pos = [sb instantiateViewControllerWithIdentifier:@"pos"];
    pos.foto = image;
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    [pos setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:pos animated:NO completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identificador = @"assuntoCell";
    
    AssuntoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identificador forIndexPath:indexPath];

    if (cell == nil) {
        cell = [[AssuntoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identificador];
    }
    Materia *materia = [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] objectAtIndex:self.posicaoMateria];
    Assunto *assunto = [materia.assuntos objectAtIndex:indexPath.row];
    cell.assunto.text = assunto.nome;
    cell.assunto.font = [UIFont fontWithName:@"OpenSans-Semibold" size:17];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = NSLocalizedString(@"DATA", nil);
    cell.data.text =  [df stringFromDate:assunto.dataPublicacao];
    cell.data.font = [UIFont fontWithName:@"OpenSans-Light" size:15];
    cell.materia.font = [UIFont fontWithName:@"OpenSans-Semibold" size:9];
    /// long press
    UILongPressGestureRecognizer *longPressGesture =
    [[UILongPressGestureRecognizer alloc]
     initWithTarget:self action:@selector(longPress:)];
    [cell addGestureRecognizer:longPressGesture];
    longPressGesture.minimumPressDuration = 1.0f;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Materia *materia = [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] objectAtIndex:self.posicaoMateria];
    return materia.assuntos.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.posicaoAssunto = indexPath.row;
    [self performSegueWithIdentifier:@"segueListaFotos" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqual: @"segueListaFotos"]) {
        FotosViewController *view = [segue destinationViewController];
        view.posicaoMateria = self.posicaoMateria;
        view.posicaoAssunto = self.posicaoAssunto;
    }
}
/*Pra apagar uma materia*/

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.table setEditing:editing animated:animated];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Materia *m = [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] objectAtIndex:self.posicaoMateria];
        Assunto *assunto = [m.assuntos objectAtIndex:indexPath.row];
        [assunto deletedb:(int)self.posicaoMateria];
        [m.assuntos removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        UITableViewCell *cell = (UITableViewCell *)[gesture view];
        NSIndexPath *indexPath = [self.table indexPathForCell:cell];
        Materia *m = [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] objectAtIndex:self.posicaoMateria];
        Assunto *a = m.assuntos[indexPath.row];
        
        self.posicaoAlterar = indexPath;
              
        NSString *titulo = [[NSString alloc]initWithFormat:@"Deseja renomear a materia %@?",a.nome];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titulo message:nil delegate:self  cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Alterar", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        [alert show];

    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    NSString *nomeMateria = [alertView textFieldAtIndex:0].text;
    
    if([title isEqualToString:@"Alterar"]){
        Materia *m = [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] objectAtIndex:self.posicaoAlterar.row];
        Assunto *a = m.assuntos[self.posicaoAlterar.row];
        
        BOOL existe = NO;
        for (Assunto *assunto in m.assuntos) {
            if ([assunto.nome isEqualToString:nomeMateria]) {
                existe = YES;
            }
        }
        if (!existe) {
            [a alteradb:nomeMateria eIdMateria:(int)self.posicaoMateria];
            a.nome = nomeMateria;
        }
        [self.table reloadData];
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

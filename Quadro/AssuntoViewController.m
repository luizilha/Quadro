//
//  AssuntoViewController.m
//  Quadro
//
//  Created by Luiz Ilha on 2/12/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

#import "AssuntoViewController.h"
#import "Assunto.h"
#import "PosCameraViewController.h"
#import "FotosViewController.h"
#import "CustomCameraViewController.h"
#import "FotoComAnotacao.h"
#import "SWRevealViewController.h"
#import "Quadro-Swift.h"

@interface AssuntoViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;
@property NSInteger posicaoAssunto;
@property NSIndexPath *posicaoAlterar;
@property NSMutableArray *todosAssuntos;
@end

@implementation AssuntoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.todosAssuntos = [Assunto listadb:_posicaoMateria];
    // termos de uso
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL aceito = [defaults boolForKey:@"aceito"];
    if (!aceito) {
        [self termos];
    }
    // btn do menu gaveta
    _barBtn.target = self.revealViewController;
    _barBtn.action = @selector(revealToggle:);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Assunto";
    self.todosAssuntos = [Assunto listadb:_posicaoMateria];
    [_table reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    NSString *nomeMateria = [alertView textFieldAtIndex:0].text;
    
    if([title isEqualToString:@"Alterar"]){
        Assunto *a = self.todosAssuntos[self.posicaoAlterar.row];
        
        BOOL existe = NO;
        for (Assunto *assunto in self.todosAssuntos) {
            if ([assunto.nome isEqualToString:nomeMateria]) {
                existe = YES;
            }
        }
        if (!existe) {
            [a alteradb:nomeMateria eIdMateria:(int)self.posicaoMateria];
            a.nome = nomeMateria;
        }
        [self.table reloadData];
    } else if ([title isEqualToString:NSLocalizedString(@"ACEITAR", nil)]) {
        BOOL aceito = YES;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:aceito forKey:@"aceito"];
        [defaults synchronize];
    } else if ([title isEqualToString:NSLocalizedString(@"RECUSAR", comment: "")]) {
        exit(0);
    }
}

- (void)termos {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TERMOS_T", nil) message:NSLocalizedString(@"TERMOS", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"RECUSAR", nil) otherButtonTitles:NSLocalizedString(@"ACEITAR", nil), nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)camera:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CustomCameraViewController *camera = [sb instantiateViewControllerWithIdentifier:@"Camera"];
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
    
    AssuntoCell *cell = [tableView dequeueReusableCellWithIdentifier:identificador forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[AssuntoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identificador];
    }
    Assunto *assunto = self.todosAssuntos[indexPath.row];
    cell.assunto.text = assunto.nome;
    cell.assunto.font = [UIFont fontWithName:@"OpenSans-Semibold" size:17];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = NSLocalizedString(@"DATA", nil);
    cell.data.text =  [df stringFromDate:assunto.dataPublicacao];
    cell.data.font = [UIFont fontWithName:@"OpenSans-Light" size:15];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.todosAssuntos.count;
}

/*Pra apagar uma materia*/
- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.table setEditing:editing animated:animated];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Assunto *assunto = [self.todosAssuntos objectAtIndex:indexPath.row];
        [assunto deletedb:(int)self.posicaoMateria];
        [self.todosAssuntos removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Assunto *assunto = [self.todosAssuntos objectAtIndex:indexPath.row];
    self.posicaoAssunto = [Assunto posicaodb:assunto];
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

@end

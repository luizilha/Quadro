//
//  ViewController.m
//  Quadro
//
//  Created by LUIZ ILHA M MACIEL on 2/11/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

#import "MateriaViewController.h"
#import "TodasMateriasSingleton.h"
#import "Materia.h"
#import "AssuntoViewController.h"

@interface MateriaViewController ()

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic) NSMutableArray *assuntos;
@property (nonatomic) NSInteger posicaoMateria;
@property (nonatomic) NSIndexPath *posicaoAlterar; // posicao para alterar
@end
// sar
@implementation MateriaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //BOTAO EDIT
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.editButtonItem.title = @"Editar";
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(adicicionaMateriaRefresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.table addSubview: refreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.table reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    NSString *nomeMateria = [alertView textFieldAtIndex:0].text.capitalizedString;
    
    
    if ([title isEqualToString:@"Salvar"]) {
        Materia *materia = [[Materia alloc] initMateria:nomeMateria];
        [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] insertObject:materia atIndex:0];
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.table insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }else if([title isEqualToString:@"Alterar"]){
        Materia *materia = [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] objectAtIndex:self.posicaoAlterar.row];
        
        materia.nome = [alertView textFieldAtIndex:0].text.capitalizedString;
        
        materia.nome = nomeMateria;
        
        [self.table reloadData];
        
    }
}

-(void) adicicionaMateriaRefresh:(UIRefreshControl *)ref{
    [ref endRefreshing];
    UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Digite nome da materia" message:@"Ex: calculo" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Salvar", nil];
    alerta.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alerta show];
    
    
}
- (IBAction)adicionaMateria:(id)sender {
    UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Digite nome da materia" message:@"Ex: calculo" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Salvar", nil];
    alerta.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alerta show];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identificador = @"materiaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"materiaCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identificador];
    }
    Materia *materia = [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] objectAtIndex:indexPath.row];
    cell.textLabel.text = materia.nome;
    cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:250.0/255 blue:180.0/255  alpha:1.0];
    /// long press
    UILongPressGestureRecognizer *longPressGesture =
    [[UILongPressGestureRecognizer alloc]
     initWithTarget:self action:@selector(longPress:)];
    [cell addGestureRecognizer:longPressGesture];
    longPressGesture.minimumPressDuration = 1.0f;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.posicaoMateria = indexPath.row;
    [self performSegueWithIdentifier:@"segueAssunto" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqual: @"segueAssunto"]) {
        AssuntoViewController *view = [segue destinationViewController];
        view.posicaoMateria = self.posicaoMateria;
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
        //remover do mutable array
        [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] removeObjectAtIndex:indexPath.row];
        
        [tableView reloadData];
    }
}
///
/*Long press*/

- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        UITableViewCell *cell = (UITableViewCell *)[gesture view];
        NSIndexPath *indexPath = [self.table indexPathForCell:cell];
        // NSString *s = [NSString stringWithFormat: @"row=%1d",indexPath.row];
        
        ///
        
        Materia *materia = [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] objectAtIndex:indexPath.row];
        
        NSString *titulo = [[NSString alloc]initWithFormat:@"Deseja renomear a materia %@?",materia.nome.capitalizedString];
        
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titulo message:nil delegate:self  cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Alterar", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        self.posicaoAlterar = indexPath;
        
        
        
        [alert show];
        
        
        //NSString *novo = @"Kleiton";
        //  materia.nome = novo;
        
        //NSLog(@"----> %@ <----- ",materia.nome);
        
        //[self setTitle: s];
    }
}



@end

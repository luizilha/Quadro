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

@interface AssuntoViewController ()

@end

@implementation AssuntoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identiicador = @"assuntoCell";
    AssuntoTableViewCell *cell = [[AssuntoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identiicador];
    Assunto *assunto = [self.assuntos objectAtIndex:indexPath.row];
    cell.assunto.text = assunto.nomeAssunto;
    cell.data = assunto.dataPublicacao;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assuntos.count;
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

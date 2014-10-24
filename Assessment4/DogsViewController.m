//
//  DogsViewController.m
//  Assessment4
//
//  Created by Vik Denic on 8/11/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "DogsViewController.h"
#import "AddDogViewController.h"
#import "Dog.h"
#import "AppDelegate.h"

@interface DogsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UITableView *dogsTableView;
@property NSArray *dogs;

@end

@implementation DogsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Dogs";
    self.dogsTableView.allowsMultipleSelectionDuringEditing = NO;

    [self loadDogs];
//    [self.dogsTableView reloadData];
}

#pragma mark - UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dogs.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"dogCell"];
    Dog *dog = [self.dogs objectAtIndex:indexPath.row];

    cell.textLabel.text = dog.name;
    cell.detailTextLabel.text = [dog.color stringByAppendingString:[NSString stringWithFormat:@" %@", dog.breed]];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"AddDogSegue"])
    {
        AddDogViewController *viewController = [segue destinationViewController];
        viewController.owner = self.owner;
        viewController.dog = [self.dogs objectAtIndex:[self.dogsTableView indexPathForSelectedRow].row];
    }
    else
    {

    }
}

-(void)loadDogs
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Dog"];
    request.predicate = [NSPredicate predicateWithFormat:@"owner = %@", self.owner];


    self.dogs = [appDelegate.managedObjectContext executeFetchRequest:request error:nil];
    [self.dogsTableView reloadData];
}

-(IBAction)unwindAddDogViewController:(UIStoryboardSegue *)sender
{
    [self loadDogs];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Delete Dog";
}

-(IBAction)enterEditMode:(UIBarButtonItem *)sender
{
    if ([self.dogsTableView isEditing])
    {
        [self.editButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"Edit", @"title", nil] forState:UIControlStateSelected];
        [self.dogsTableView setEditing:NO animated:YES];
    }
    else if (!([self.dogsTableView isEditing]))
    {
        [self.editButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"Done", @"title", nil] forState:UIControlStateSelected];
        [self.dogsTableView setEditing:YES animated:YES];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSManagedObject *dog = [self.dogs objectAtIndex:indexPath.row];
        [appDelegate.managedObjectContext deleteObject:dog];
        [appDelegate.managedObjectContext save:nil];
        [self loadDogs];
    }
}


@end

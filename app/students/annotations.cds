using GameService as service from '../../srv/game-service';

annotate service.Student with @(
  UI.HeaderInfo: {
    TypeName       : 'Student',
    TypeNamePlural : 'Students',
    Title          : { Value: First_name },
    Description    : { Value: Last_name }
  },
  UI.SelectionFields: [ First_name, Last_name ],
  UI.LineItem: [
    { Value: First_name, Label: 'First name' },
    { Value: Last_name,  Label: 'Last name'  }
  ],
  UI.FieldGroup #General: {
    Data: [
      { Value: First_name, Label: 'First name' },
      { Value: Last_name,  Label: 'Last name'  }
    ]
  },
  UI.Facets: [
    { $Type: 'UI.ReferenceFacet', ID: 'General', Label: 'General',        Target: '@UI.FieldGroup#General' },
    { $Type: 'UI.ReferenceFacet', ID: 'Favos',   Label: 'Favorite games', Target: 'to_favos/@UI.LineItem' }
  ]
);

annotate service.Student with {
  Student_ID @UI.Hidden;
  First_name @mandatory;
  Last_name  @mandatory;
};

annotate service.Game with {
  Cover_url @UI.IsImageURL;
};

annotate service.FavoriteGame with @(
 UI.LineItem: [
  { Value: to_game.Cover_url, Label: 'Cover'     },
  { Value: Game_ID,           Label: 'Game'      },
  { Value: to_game.Genre,     Label: 'Genre'     },
  { Value: to_game.Publisher, Label: 'Publisher' },
  { Value: to_game.Platform,  Label: 'Platform'  }
]
);

annotate service.FavoriteGame with {
  Student_ID @UI.Hidden;
  Game_ID    @Common.Text            : to_game.Name
             @Common.TextArrangement : #TextOnly
             @Common.ValueList       : {
               CollectionPath : 'Game',
               Parameters     : [
                 { $Type: 'Common.ValueListParameterInOut',       LocalDataProperty: Game_ID, ValueListProperty: 'Game_ID' },
                 { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'Name' },
                 { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'Genre' }
               ]
             };
};
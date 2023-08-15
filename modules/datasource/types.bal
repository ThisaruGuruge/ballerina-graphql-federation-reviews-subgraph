type Review readonly & record {|
    readonly string id;
    string title;
    string comment;
    int rating;
    string authorId;
    string productId;
|};

type ReviewInput record {|
    string title;
    string comment;
    int rating;
    string authorId;
    string productId;
|};

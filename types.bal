import ballerina/constraint;
import ballerina/graphql;

public isolated service class Review {
    private final readonly & ReviewInfo reviewInfo;

    isolated function init(ReviewInfo reviewInformation) {
        self.reviewInfo = reviewInformation.cloneReadOnly();
    }

    # The ID of the review
    # + return - The ID of the review
    isolated resource function get id() returns @graphql:ID string => self.reviewInfo.id;

    # The title of the review
    # + return - The title of the review
    isolated resource function get title() returns string => self.reviewInfo.title;

    # The review comment
    # + return - The comment of the review
    isolated resource function get comment() returns string => self.reviewInfo.comment;

    # The rating of the review (0 to 5)
    # + return - The rating of the review
    isolated resource function get rating() returns int => self.reviewInfo.rating;
}

type ReviewInfo record {|
    string id;
    string title;
    string comment;
    int rating;
    string authorId;
    string productId;
|};

# The input type for the addReview mutation
public type ReviewInput readonly & record {|
    string title;

    # The comment of the review
    string comment;

    # The rating of the review. This must be an integer between 0 and 5 (inclusive), otherwise an error will be thrown.
    @constraint:Int {
        minValue: 0,
        maxValue: 5
    }
    int rating;

    # The ID of the review author
    string authorId;

    # The product ID that the review is for
    string productId;
|};

import review_subgraph.datasource;

import ballerina/constraint;
import ballerina/graphql;
import ballerina/graphql.subgraph;

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

    # The author of the review
    # + return - The author of the review
    isolated resource function get author() returns User => getAuthor(self.reviewInfo.authorId);

    # The product that the review is for
    # + return - The product that the review is for
    isolated resource function get product() returns Product => getProduct(self.reviewInfo.productId);
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

    # The title of the review
    string title;

    # The comment of the review
    string comment;

    # The rating of the review. This is an integer between 0 and 5
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

@subgraph:Entity {
    key: "id",
    resolveReference: resolveProduct
}
public type Product record {|
    @graphql:ID string id;
    Review[] reviews;
|};

public isolated function resolveProduct(subgraph:Representation representation) returns Product|error {
    string id = check representation["id"].ensureType();
    return getProduct(id);
}

@subgraph:Entity {
    key: "id",
    resolveReference: resolveUser
}
public type User record {|
    @graphql:ID string id;
    Review[] reviews;
|};

public isolated function resolveUser(subgraph:Representation representation) returns Product|error {
    string id = check representation["id"].ensureType();
    return getAuthor(id);
}

isolated function getProduct(string id) returns Product {
    ReviewInfo[] reviewList = datasource:getReviewsByProduct(id);
    return {
        id,
        reviews: reviewList.map(reviewInfo => new Review(reviewInfo))
    };
}

isolated function getAuthor(string id) returns User {
    ReviewInfo[] reviewList = datasource:getReviewsByAuthor(id);
    return {
        id,
        reviews: reviewList.map(reviewInfo => new Review(reviewInfo))
    };
}

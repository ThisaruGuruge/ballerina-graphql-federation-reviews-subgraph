import review_subgraph.datasource;

import ballerina/graphql;

service graphql:Service on new graphql:Listener(9093) {

    # Returns a list of reviews
    # + return - List of reviews
    resource function get reviews() returns Review[] {
        return from ReviewInfo reviewInfo in datasource:getReviews()
            select new (reviewInfo);
    }

    # Adds a new review
    # + input - The review to be added.
    # + return - The added review
    remote function addReview(ReviewInput input) returns Review|error {
        ReviewInfo|error result = datasource:addReview(input);
        if result is error {
            return error("Failed to add the review");
        }
        return new (result);
    }
}

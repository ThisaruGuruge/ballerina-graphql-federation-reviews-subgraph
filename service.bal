import review_subgraph.datasource;

import ballerina/graphql;
import ballerina/graphql.subgraph;

@subgraph:Subgraph
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
    remote function addReview(ReviewInput input) returns Review {
        ReviewInfo result = datasource:addReview(input);
        return new (result);
    }
}

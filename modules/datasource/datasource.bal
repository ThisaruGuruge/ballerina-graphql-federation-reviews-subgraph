public isolated function getReviews() returns Review[] {
    lock {
        Review[] result = from Review review in reviews select review;
        return result.cloneReadOnly();
    }
}

public isolated function addReview(readonly & ReviewInput input) returns Review|error {
    lock {
        string nextId = string `review-${reviews.length()}`;
        Review review = {
            id: nextId,
            ...input
        };
        reviews.add(review);
        return review;
    }
}

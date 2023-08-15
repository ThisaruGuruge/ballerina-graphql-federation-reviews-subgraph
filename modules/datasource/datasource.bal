public isolated function getReviews() returns readonly & Review[] {
    lock {
        return from Review review in reviews select review;
    }
}

public isolated function addReview(ReviewInput input) returns Review {
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

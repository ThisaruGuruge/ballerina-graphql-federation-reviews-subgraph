public isolated function getReviews() returns readonly & Review[] {
    lock {
        return from Review review in reviews select review;
    }
}

public isolated function getReviewsByProduct(string productId) returns readonly & Review[] {
    lock {
        return from Review review in reviews where review.productId == productId select review;
    }
}

public isolated function getReviewsByAuthor(string userId) returns readonly & Review[] {
    lock {
        return from Review review in reviews where review.authorId == userId select review;
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

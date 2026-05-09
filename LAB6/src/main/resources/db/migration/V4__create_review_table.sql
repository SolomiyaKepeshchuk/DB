CREATE TABLE review (
    review_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    tour_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date DATE DEFAULT CURRENT_DATE,

    CONSTRAINT fk_review_customer FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id),

    CONSTRAINT fk_review_tour FOREIGN KEY (tour_id)
        REFERENCES tour(tour_id)
);
class Share {
    constructor(sproduct_id, sproduct_name, sproduct_category, sproduct_description, sproduct_start_time, sproduct_end_time, borrower_id, coin_value, active) {
        this.sproduct_id = sproduct_id;
        this.sproduct_name = sproduct_name;
        this.sproduct_category = sproduct_category;
        this.sproduct_description = sproduct_description;
        this.sproduct_start_time = sproduct_start_time;
        this.sproduct_end_time = sproduct_end_time;
        this.borrower_id = borrower_id;  
        this.coin_value = coin_value;
        this.active=active;
    }
}

export default Share;
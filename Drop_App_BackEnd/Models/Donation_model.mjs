export default function Donation(product_id, product_name, product_description, product_picture, donor_id, coin_value, product_category, active, posting_time, status) {
    this.product_id = product_id;
    this.product_name = product_name;
    this.product_description = product_description;
    this.this.product_picture= product_picture;
    this.donor_id = donor_id; 
    this.coin_value = coin_value; 
    this.product_category = product_category;
    this.active=active;   
    this.posting_time=posting_time;
    this.status=status; //(new, good conditions, used)
}

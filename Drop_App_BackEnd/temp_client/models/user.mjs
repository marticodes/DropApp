class User {
    constructor(user_id, user_name, user_surname, user_cardnum, coins_num, user_picture, user_rating, user_location, user_graduated, hash, salt, active) {
        this.user_id = user_id;
        this.user_name = user_name;
        this.user_surname = user_surname;
        this.user_cardnum = user_cardnum;
        this.coins_num = coins_num;
        this.user_picture = user_picture;
        this.user_rating = user_rating;
        this.user_location = user_location;
        this.user_graduated = user_graduated;
        this.hash=hash;
        this.salt=salt;
        this.active=active;
    }
}

export default User;
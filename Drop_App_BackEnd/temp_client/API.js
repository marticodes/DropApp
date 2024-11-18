import Categories from "./models/categories.mjs"
import UserCategories from "./models/userCategories.mjs"
import Chat from "./models/chat.mjs"
import Donation from "./models/donation.mjs"
import Message from "./models/message.mjs"
import Share from "./models/share.mjs"
import User from "./models/user.mjs"

const SERVER_URL = 'http://localhost:3001';

// Error Handling Function
function handleInvalidResponse(response) {
    if (!response.ok) { throw Error(response.statusText) }
    let type = response.headers.get('Content-Type');
    if (type !== null && type.indexOf('application/json') === -1) {
        throw new TypeError(`Expected JSON, got ${type}`)
    }
    return response;
}

class UnauthorizedError extends Error {
    constructor(message) {
        super(message);
        this.name = 'UnauthorizedError';
        this.response = { status: 401 };
    }
}

//USER-----------------------------------------------------------------------
const setUserAsGraduate = async (user_id) => {
    const response = await fetch(SERVER_URL + '/api/user/graduate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({user_id}),
        //credentials: 'include'
    });
    if (response.ok) {
        return await response.json();
    } else if (response.status === 401) {
        throw new UnauthorizedError('Unauthorized access');
    } else {
        const errorText = await response.text();
        console.error(`FE: Error status: ${response.status}, message: ${errorText}`);
    }
};

const getUserProfileInfo = async () => {
    const response = await fetch(SERVER_URL + `/api/info/${user_id}`, {
        method: 'GET',
    });
    if (response.ok) {
        const userJson = await response.json();
        return userJson.map(u => new User(u.user_id, u.user_name, u.user_surname, u.user_cardnum, u.coins_num, u.user_picture, u.user_rating, u.user_location, u.user_graduated, u.hash, u.salt, u.active));
    } else {
        throw new Error('FE: Error getting user profile info');
    }
};

const isUserActive = async () => {
    const response = await fetch(SERVER_URL + `/api/active/${user_id}`, {
        method: 'GET',
    });
    if (response.ok) {
        const userJson = await response.json();
        return userJson.active;
    } else {
        throw new Error('FE: Error getting user info (active)');
    }
};

const setUserAsInactive = async (user_id) => {
    const response = await fetch(SERVER_URL + '/api/user/inactive', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({user_id}),
        //credentials: 'include'
    });
    if (response.ok) {
        return await response.json();
    } else if (response.status === 401) {
        throw new UnauthorizedError('Unauthorized access');
    } else {
        const errorText = await response.text();
        console.error(`FE: Error status: ${response.status}, message: ${errorText}`);
    }
};

const insertUser = async (user_name, user_surname, user_cardnum, user_picture, user_location) => {
    const response = await fetch(SERVER_URL + '/api/user/insert', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({user_name, user_surname, user_cardnum, user_picture, user_location}),
        //credentials: 'include'
    });
    if (response.ok) {
        return await response.json();
    } else if (response.status === 401) {
        throw new UnauthorizedError('Unauthorized access');
    } else {
        const errorText = await response.text();
        console.error(`FE: Error status: ${response.status}, message: ${errorText}`);
    }
};
/* This function wants username and password inside a "credentials" object.
* It executes the log-in.
*/
const logIn = async (credentials) => {
    await fetch(SERVER_URL + '/api/sessions', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        credentials: 'include',  // this parameter specifies that authentication cookie must be forwared. It is included in all the authenticated APIs.
        body: JSON.stringify(credentials),
    }).then(handleInvalidResponse)
        .then(response => response.json());
        
};



/* This function is used to verify if the user is still logged-in.
* It returns a JSON object with the user info.
*/
const getUserInfo = async () => {
    return await fetch(SERVER_URL + '/api/sessions/current', {
        credentials: 'include'
    }).then(handleInvalidResponse)
        .then(response => response.json());
};

/**
* This function destroy the current user's session (executing the log-out).
*/
const logOut = async () => {
    return await fetch(SERVER_URL + '/api/sessions/current', {
        method: 'DELETE',
        credentials: 'include'
    }).then(handleInvalidResponse);
}

//CATEORIES API 
const getCategoriesList = async () => {
    const response = await fetch(SERVER_URL + `/api/categories/list`, {
        method: 'GET',
    });
    if (response.ok) {
        const categJson = await response.json();
        return categJson.map(category => new Categories(category.category_name));
    } else {
        throw new Error('FE: Error getting categories list');
    }
};

//USERCATEGORIES API
const getAllCategoriesByUserId = async (user_id) => {
    const response = await fetch(SERVER_URL + `/api/user_categories/all/${user_id}`, {
        method: 'GET',
    });
    if (response.ok) {
        const userCategJson = await response.json();
        return userCategJson.map(category => new UserCategories(category.user_id, category.category_name));
    } else {
        throw new Error('FE: Error getting user categories (all)');
    }
};

const getSingleCategoryByUserId = async (user_id, category_name) => {   //does this user have this specific category?
    const response = await fetch(SERVER_URL + `/api/user_categories/one/${user_id}/${category_name}`, {
        method: 'GET',
    });
    if (response.ok) {
        return count = await response.json(); //1= there is, 0=there isn't
    } else {
        throw new Error('FE: Error getting user categories (one)');
    }
};

const insertUserCategory = async (user_id, category_name) => {  //true if it went well
    const response = await fetch(SERVER_URL + '/api/user_categories/insert', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ user_id, category_name}),
        //credentials: 'include'
    });

    if (response.ok) {
        return await response.json();
    } else if (response.status === 401) {
        throw new UnauthorizedError('Unauthorized access');
    } else {
        const errorText = await response.text();
        console.error(`FE: Error status: ${response.status}, message: ${errorText}`);
    }
};

const deleteUserCategory = async (user_id, category_name) => {  //true if it went well
    const response = await fetch(SERVER_URL + `/api/user_categories/delete`, {
        method: 'DELETE',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ user_id, category_name }),
        //credentials: 'include'
    });

    if (response.ok) {
        return await response.json();
    } else if (response.status === 401) {
        throw new UnauthorizedError('Unauthorized access');
    } else {
        const errorText = await response.text();
        console.error(`FE: Error status: ${response.status}, message: ${errorText}`);
    }
};

//CHAT API
const getChatUsers = async (chat_id) => {   //list of both Id's
    const response = await fetch(SERVER_URL + `/api/chat/${chat_id}/users`, {
        method: 'GET',
    });
    if (response.ok) {
        const chatJson = await response.json();
        const { user1_id, user2_id } = chatJson;
        return { user1_id, user2_id };
    } else {
        throw new Error('FE: Error getting chat users');
    }
};

/*read DAO in Backend for more info */
const getChatProduct = async (chat_id) => {   //2 values where one is null (one if it's product from donation and one if it's sproduct from sharing)
    const response = await fetch(SERVER_URL + `/api/chat/${chat_id}/product`, {
        method: 'GET',
    });
    if (response.ok) {
        const chatJson = await response.json();
        const { product_id, sproduct_id } = chatJson;
        return { product_id, sproduct_id };
    } else {
        throw new Error('FE: Error getting chat product');
    }
};

const getChatType = async (chat_id) => { //0=donation, 1=sharing
    const response = await fetch(SERVER_URL + `/api/chat/${chat_id}/type`, {
        method: 'GET',
    });
    if (response.ok) {
        const chatJson = await response.json();
        const chatType = chatJson.type;
        return chatType;
    } else {
        throw new Error('FE: Error getting chat type');
    }
};

const getAllChatsForUser = async (user_id_1, user_id_2) => {    //put 0 for the other one
    const response = await fetch(SERVER_URL + `/api/chat/all/${user_id_1}/${user_id_2}`, {
        method: 'GET',
    });
    if (response.ok) {
        const chatJson = await response.json();
        return chatJson;
    } else {
        throw new Error('FE: Error getting all chats for a user');
    }
};

const getChatIdByUserAndProduct = async (user_id_1, user_id_2, product_id, sproduct_id) => {    //put 0 for the other one (product id or sproduct)
    const response = await fetch(SERVER_URL + `/api/chat/all/${user_id_1}/${user_id_2}/${product_id}/${sproduct_id}`, {
        method: 'GET',
    });
    if (response.ok) {
        const chatJson = await response.json();
        return chatJson;
    } else {
        throw new Error('FE: Error getting chat id');
    }
};

const insertChat = async (userID1, userID2, product_id, type, sproduct_id) => {
    const response = await fetch(SERVER_URL + '/api/chats/insert', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ userID1, userID2, product_id, type, sproduct_id}),
        //credentials: 'include'
    });

    if (response.ok) {
        const data = await response.json();
        return data.chat_id;
    } else if (response.status === 401) {
        throw new UnauthorizedError('Unauthorized access');
    } else {
        const errorText = await response.text();
        console.error(`FE: Error status: ${response.status}, message: ${errorText}`);
    }
};

//MESSAGE API
const getMessagesByChatId = async (chat_id) => {
    const response = await fetch(SERVER_URL + `/api/messages/${chat_id}`, {
        method: 'GET',
    });
    if (response.ok) {
        const messages = await response.json();
        return messages.map(mex => new Message(mex.chat_id, mex.message_id, mex.message_time, mex.content, mex.image, mex.sender_id));
    } else {
        throw new Error('FE: Error getting messages of a chat');
    }
};

const insertMessage = async (chat_id, content, image, sender_id) => {
    const response = await fetch(SERVER_URL + `/api/messages/insert`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({chat_id, message_time, content, image, sender_id}),
        //credentials: 'include'
    });

    if (response.ok) {
        const data = await response.json();
        return data.message_id;
    } else if (response.status === 401) {
        throw new UnauthorizedError('Unauthorized access');
    } else {
        const errorText = await response.text();
        console.error(`FE: Error status: ${response.status}, message: ${errorText}`);
    }
};

//DONATION API 
const insertDonation = async (product_name, product_description, product_category, product_picture, donor_id, status) => {
    const response = await fetch(SERVER_URL + '/api/donation/insert', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({product_name, product_description, product_category, product_picture, donor_id, status}),
        //credentials: 'include'
    });

    if (response.ok) {
        const data = await response.json();
        return data.product_id;
    } else if (response.status === 401) {
        throw new UnauthorizedError('Unauthorized access');
    } else {
        const errorText = await response.text();
        console.error(`FE: Error status: ${response.status}, message: ${errorText}`);
    }
};

/*
const deleteDonation = async (product_id) => {
    const response = await fetch(SERVER_URL + `/donation/delete`, {
        method: 'DELETE',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({product_id}),
        //credentials: 'include'
    });

    if (response.ok) {
        return await response.json();
    } else if (response.status === 401) {
        throw new UnauthorizedError('Unauthorized access');
    } else {
        const errorText = await response.text();
        console.error(`Error status: ${response.status}, message: ${errorText}`);
    }
};
*/

const inactiveDonation = async (product_id) => {
    const response = await fetch(SERVER_URL + `/api/donation/inactive`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({product_id}),
        //credentials: 'include'
    });

    if (response.ok) {
        return await response.json(); 
    } else if (response.status === 401) {
        throw new UnauthorizedError('Unauthorized access');
    } else {
        const errorText = await response.text();
        console.error(`FE: Error status: ${response.status}, message: ${errorText}`);
    }
};

const listActiveDonations = async () => {
    const response = await fetch(SERVER_URL + `/api/donations/all/active`, {
        method: 'GET',
    });
    if (response.ok) {
        const donationsJson = await response.json();
        return donationsJson.map(d => new Donation(d.product_id, d.product_name, d.product_description, d.product_picture, d.donor_id, d.coin_value, d.product_category, d.active, d.posting_time, d.status));
    } else {
        throw new Error('FE: Error listing all active donations');
    }
};

const listMyActiveDonations = async (user_id) => {
    const response = await fetch(SERVER_URL + `/api/donations/${user_id}/active`, {
        method: 'GET',
    });
    if (response.ok) {
        const donationsJson = await response.json();
        return donationsJson.map(d => new Donation(
            d.product_id, 
            d.product_name, 
            d.product_description, 
            d.product_picture, 
            d.donor_id, 
            d.coin_value, 
            d.product_category, 
            d.active, 
            d.posting_time, 
            d.status
        ));
    } else {
        throw new Error('FE: Error listing all my active donations');
    }
};


const listAllMyDonations = async (user_id) => {
    const response = await fetch(SERVER_URL + `/api/donations/${user_id}`, {
        method: 'GET',
    });
    if (response.ok) {
        const donationsJson = await response.json();
        return donationsJson.map(d => new Donation(d.product_id, d.product_name, d.product_description, d.product_picture, d.donor_id, d.coin_value, d.product_category, d.active, d.posting_time, d.status));
    } else {
        throw new Error('FE: Error listing all my  donations');
    }
};

const filterDonationsByCoin = async (min, max) => {
    const response = await fetch(SERVER_URL + `/api/donations/${min}/${max}`, {
        method: 'GET',
    });
    if (response.ok) {
        const donationsJson = await response.json();
        return donationsJson.map(d => new Donation(d.product_id, d.product_name, d.product_description, d.product_picture, d.donor_id, d.coin_value, d.product_category, d.active, d.posting_time, d.status));
    } else {
        throw new Error('FE: Error filtering donations by coins');
    }
};

const filterDonationsByCategory = async (categories) => { //TO DO
    const response = await fetch(SERVER_URL + `/api/donations/${categories}`, {
        method: 'GET',
    });
    if (response.ok) {
        const donationsJson = await response.json();
        return donationsJson.map(d => new Donation(d.product_id, d.product_name, d.product_description, d.product_picture, d.donor_id, d.coin_value, d.product_category, d.active, d.posting_time, d.status));
    } else {
        throw new Error('FE: Error filtering donations by categories');
    }
};

//SHARE API
const insertSharing = async (sproduct_name, sproduct_category, sproduct_description, sproduct_start_time, sproduct_end_time, borrower_id, status) => {
    const response = await fetch(SERVER_URL + '/api/sharing/insert', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({sproduct_name, sproduct_category, sproduct_description, sproduct_start_time, sproduct_end_time, borrower_id, status}),
        //credentials: 'include'
    });

    if (response.ok) {
        const data = await response.json();
        return data.product_id;
    } else if (response.status === 401) {
        throw new UnauthorizedError('Unauthorized access');
    } else {
        const errorText = await response.text();
        console.error(`FE: Error status: ${response.status}, message: ${errorText}`);
    }
};
/*
const deleteSharing = async (sproduct_id) => {
    const response = await fetch(SERVER_URL + `/sharing/delete`, {
        method: 'DELETE',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({sproduct_id}),
        //credentials: 'include'
    });

    if (response.ok) {
        return await response.json();
    } else if (response.status === 401) {
        throw new UnauthorizedError('Unauthorized access');
    } else {
        const errorText = await response.text();
        console.error(`Error status: ${response.status}, message: ${errorText}`);
    }
};
*/
const inactiveSharing = async (sproduct_id) => {
    const response = await fetch(SERVER_URL + `/api/sharing/inactive`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({sproduct_id}),
        //credentials: 'include'
    });

    if (response.ok) {
        return await response.json(); 
    } else if (response.status === 401) {
        throw new UnauthorizedError('Unauthorized access');
    } else {
        const errorText = await response.text();
        console.error(`FE: Error status: ${response.status}, message: ${errorText}`);
    }
};

const listActiveSharing = async () => {
    const response = await fetch(SERVER_URL + `/api/sharing/all/active`, { 
        method: 'GET',
    });
    if (response.ok) {
        const donationsJson = await response.json();
        return donationsJson.map(d => new Share(d.sproduct_id, d.sproduct_name, d.sproduct_category, d.sproduct_description, d.sproduct_start_time, d.sproduct_end_time, d.borrower_id, d.coin_value, d.active, d.posting_time, d.status));
    } else {
        throw new Error('FE: Error listing all active sharing');
    }
};

const listMyActiveSharing = async (user_id) => {
    const response = await fetch(SERVER_URL + `/api/sharing/${user_id}/active`, {
        method: 'GET',
    });
    if (response.ok) {
        const donationsJson = await response.json();
        return donationsJson.map(d => new Share(d.sproduct_id, d.sproduct_name, d.sproduct_category, d.sproduct_description, d.sproduct_start_time, d.sproduct_end_time, d.borrower_id, d.coin_value, d.active, d.posting_time, d.status));
    } else {
        throw new Error('FE: Error listing all my active sharing');
    }
};

const listAllMySharing = async (user_id) => {
    const response = await fetch(SERVER_URL + `/api/sharing/${user_id}`, {
        method: 'GET',
    });
    if (response.ok) {
        const donationsJson = await response.json();
        return donationsJson.map(d => new Share(d.sproduct_id, d.sproduct_name, d.sproduct_category, d.sproduct_description, d.sproduct_start_time, d.sproduct_end_time, d.borrower_id, d.coin_value, d.active, d.posting_time, d.status));
    } else {
        throw new Error('FE: Error listing all my  sharing');
    }
};

const filterSharingByCoin = async (min, max) => {
    const response = await fetch(SERVER_URL + `/api/sharing/${min}/${max}`, {
        method: 'GET',
    });
    if (response.ok) {
        const donationsJson = await response.json();
        return donationsJson.map(d => new Share(d.sproduct_id, d.sproduct_name, d.sproduct_category, d.sproduct_description, d.sproduct_start_time, d.sproduct_end_time, d.borrower_id, d.coin_value, d.active, d.posting_time, d.status));
    } else {
        throw new Error('FE: Error filtering sharing by coins');
    }
};

const filterSharingByCategory = async (categories) => {
    const response = await fetch(`${SERVER_URL}/api/sharing?categories=${categories.join('&categories=')}`, {
        method: 'GET',
    });
    if (response.ok) {
        const donationsJson = await response.json();
        return donationsJson.map(d => new Share(d.sproduct_id, d.sproduct_name, d.sproduct_category, d.sproduct_description, d.sproduct_start_time, d.sproduct_end_time, d.borrower_id, d.coin_value, d.active, d.posting_time, d.status));
    } else {
        throw new Error('FE: Error filtering sharing by categories');
    }
};


const API = {logIn, getUserInfo, logOut, handleInvalidResponse, getCategoriesList, getAllCategoriesByUserId, getSingleCategoryByUserId, insertUserCategory, deleteUserCategory,
    getChatUsers, getChatProduct, getChatType, insertChat, getMessagesByChatId, insertMessage, insertDonation, inactiveDonation, listActiveDonations, listMyActiveDonations,
    listAllMyDonations, filterDonationsByCoin, filterDonationsByCategory, insertSharing, inactiveSharing, listActiveSharing, listMyActiveSharing, listAllMySharing,
    filterSharingByCoin, filterSharingByCategory, setUserAsGraduate, getUserProfileInfo, isUserActive, setUserAsInactive, insertUser, getAllChatsForUser, getChatIdByUserAndProduct};

export default API;
export { UnauthorizedError };
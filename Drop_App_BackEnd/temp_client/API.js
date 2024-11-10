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
        return categoryList;
    } else {
        throw new Error('Error getting categories list');
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
        throw new Error('Error getting user categories (all)');
    }
};

const getSingleCategoryByUserId = async (user_id, category_name) => {
    const response = await fetch(SERVER_URL + `/api/user_categories/one/${user_id}/${category_name}`, {
        method: 'GET',
    });
    if (response.ok) {
        const userCategJson = await response.json();
        const userCategoryOne = new UserCategories(userCategJson.user_id, userCategJson.category_name);
        return userCategoryOne;
    } else {
        throw new Error('Error getting user categories (one)');
    }
};

const insertUserCategory = async (user_id, category_name) => {
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
        console.error(`Error status: ${response.status}, message: ${errorText}`);
    }
};

const deleteUserCategory = async (user_id, category_name) => {
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
        console.error(`Error status: ${response.status}, message: ${errorText}`);
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
        throw new Error('Error getting chat users');
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
        throw new Error('Error getting chat product');
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
        throw new Error('Error getting chat type');
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
        const userCategJson = await response.json();
        return userCategJson.map(mex => new Message(mex.chatId, mex.message_time, mex.content, mex.image, mex.sender_id));
    } else {
        throw new Error('FE: Error getting messages of a chat');
    }
};

const insertMessage = async (chatId, message_time, content, image, sender_id) => {
    const response = await fetch(SERVER_URL + '/api/messages/insert', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({chatId, message_time, content, image, sender_id}),
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
//SHARE API

const API = { logIn, getUserInfo, logOut, handleInvalidResponse, getCategoriesList, getAllCategoriesByUserId, getSingleCategoryByUserId, insertUserCategory, deleteUserCategory,
    getChatUsers, getChatProduct, getChatType, insertChat, getMessagesByChatId, insertMessage};
export default API;
export { UnauthorizedError };
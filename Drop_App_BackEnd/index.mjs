
import express from 'express';
import morgan from 'morgan';
import cors from 'cors';
import { check, validationResult } from 'express-validator';

/** Authentication-related imports **/
import passport from 'passport';
import LocalStrategy from 'passport-local';

/** Creating the session */
import session from 'express-session';

import CategoriesDAO from "./Dao/CategoriesDao.mjs"
import ChatDAO from "./Dao/ChatDao.mjs"
import DonationDAO from "./Dao/DonationDao.mjs"
import ShareDAO from "./Dao/ShareDao.mjs"
import UserCategoriesDAO from "./Dao/UserCategoriesDao.mjs"
import UserDAO from "./Dao/UserDao.mjs"
import MessageDAO from "./Dao/MessageDao.mjs"

const categoriesDao = CategoriesDAO;
const chatDao = ChatDAO;
const donationDao = DonationDAO;
const messageDao = MessageDAO;
const shareDao = ShareDAO;
const userCategoriesDao = UserCategoriesDAO;
const userDao = new UserDAO();

const SERVER_URL = 'http://143.248.77.98:3001/api';

/*
const notificationsRouter = require('./notifications'); // import notification router
app.use('./notifications', notificationsRouter); 
*/

//init express and set up the middlewares
const app = express();
const port = 3001;
app.use(morgan('dev'));
app.use(express.json());
app.use(express.static('Img')); //path for image folder

//cors
const corsOptions = {
  origin: ['http://localhost:5173', 'http://143.248.77.98:3001', 'http://143.248.77.98:5173'],
  optionsSuccessStatus: 200,
  credentials: true  //for exchanging cookies with other origins
};
app.use(cors(corsOptions)); //called with the server

//passport
passport.use(new LocalStrategy(async function verify(username, password, callback) {
  const user = await userDao.getUser(username, password)
  if (!user)
    return callback(null, false, 'Incorrect username or password');

  return callback(null, user); //user info in the session
}));

passport.serializeUser(function (user, cb) {
  cb(null, user);
});

passport.deserializeUser(function (user, cb) {
  return userDao.getUserById(user.id).then(user => cb(null, user)).catch(err => cb(err, null));
});

//Utility Functions
const isLoggedIn = (req, res, next) => {
  if (req.isAuthenticated()) {
    return next();
  }
  return res.status(401).json({ error: 'Not authorized' });
}

app.use(session({
  secret: "shhhhh... it's a secret!",
  resave: false,
  saveUninitialized: false,
}));
app.use(passport.authenticate('session'));


// logging Middleware
app.use((req, res, next) => {
  next();
});

//USER API
app.post('/api/user/graduate', /* [], */
  async (req, res) => {
    try {
      const {user_id} = req.body;
      const set = await userDao.setUserAsGraduate(req.body.user_id);
      res.status(201).json({set});
    } catch (err) {
      res.status(503).json({ error: `BE: Error setting user as graduate${err}` });
    }
});

app.get('/api/info/:user_id',
  async (req, res) => {
    try {
      const user = await userDao.getUserInfo(req.params.user_id);
      res.status(200).json(user);
    } catch (err) {
      res.status(500).json({ error: `BE: Error getting user info ${err}` });
    }
});

app.get('/api/active/:user_id',
  async (req, res) => {
    try {
      const user = await userDao.isUserActive(req.params.user_id);
      res.status(200).json(user);
    } catch (err) {
      res.status(500).json({ error: `BE: Error getting user info ${err}` });
    }
});

app.get('/api/:user_id/get_score',
  async (req, res) => {
    try {
      const rating = await userDao.getRating(req.params.user_id);
      res.status(200).json(rating);
    } catch (err) {
      res.status(500).json({ error: `BE: Error getting user rating ${err}` });
    }
});

app.post('/api/user/add_score', /* [], */
  async (req, res) => {
    try {
      const {score, user_id} = req.body;
      const ins = await userDao.addReview(req.body.score, req.body.user_id);
      res.status(201).json({ins});
    } catch (err) {
      res.status(503).json({ error: `BE: Error inserting a review for an user${err}` });
    }
});

app.post('/api/user/inactive', /* [], */
  async (req, res) => {
    try {
      const {user_id} = req.body;
      const set = await userDao.inactiveUser(req.body.user_id);
      res.status(201).json({set});
    } catch (err) {
      res.status(503).json({ error: `BE: Error setting user as inactive${err}` });
    }
});

app.get('/api/:user_cardnum/:hash',
  async (req, res) => {
    try {
      //const user_cardnum = req.query.user_cardnum;
      //const hash = req.query.hash;
      const logged = await userDao.checkCredentials(req.params.user_cardnum, req.params.hash);
      res.status(200).json(logged);
    } catch (err) {
      res.status(500).json({ error: `BE: Error logging in ${err}` });
    }
});

app.post('/api/user/picture', /* [], */
  async (req, res) => {
    try {
      const {user_picture, user_id} = req.body;
      const set = await userDao.addUserPicture(req.body.user_picture, req.body.user_id);
      res.status(201).json({set});
    } catch (err) {
      res.status(503).json({ error: `BE: Error inserting user picture${err}` });
    }
});

app.post('/api/user/picture/remove', /* [], */
  async (req, res) => {
    try {
      const {user_id} = req.body;
      const set = await userDao.removeUserPicture(req.body.user_id);
      res.status(201).json({set});
    } catch (err) {
      res.status(503).json({ error: `BE: Error removing user picture${err}` });
    }
});

app.post('/api/user/insert', /* [], */
  async (req, res) => {
    try {
      const {user_name, user_surname, user_cardnum, user_location, hash} = req.body;
      const user_id = await userDao.insertUser(req.body.user_name, req.body.user_surname, req.body.user_cardnum, req.body.user_location, req.body.hash);
      res.status(201).json({user_id});
    } catch (err) {
      res.status(503).json({ error: `BE: Error inserting user${err}` });
    }
});

/*
app.post('/api/sessions', function (req, res, next) {
  passport.authenticate('local', (err, user, info) => {
    if (err) {
      console.error('Error during authentication:', err);
      return next(err);
    }
    if (!user) {
      console.log('Authentication failed:', info);
      return res.status(401).json({ error: info });
    }
    req.login(user, (err) => {
      if (err) {
        console.error('Error during login:', err);
        return next(err);
      }
      return res.json(req.user);
    });
  })(req, res, next);
});

app.get('/api/sessions/current', (req, res) => {

  if (req.isAuthenticated()) {
    res.status(200).json(req.user);
  } else {
    res.status(401).json({ error: 'Not authenticated' });
  }
});

app.delete('/api/sessions/current', (req, res) => {
  req.logout(() => {
    res.end();
  });
});
*/


//CATEORIES API 
app.get('/api/categories/list',
  async (req, res) => {
    try {
      const categoriesList = await categoriesDao.listCategories();
      res.status(200).json(categoriesList);
    } catch (err) {
      res.status(500).json({ error: `BE: Error retrieving categories list ${err}` });
    }
  });


//USERCATEGORIES API
app.get('/api/user_categories/all/:user_id',
  async (req, res) => {
    try {
      const allUserCategories = await userCategoriesDao.getAllCategoriesByUserId(req.params.user_id);
      res.status(200).json(allUserCategories);
    } catch (err) {
      res.status(500).json({ error: `BE: Error retrieving all the categories of a user ${err}` });
    }
  });

app.get('/api/user_categories/one/:user_id/:category_name',
  async (req, res) => {
    try {
      const count = await userCategoriesDao.getSingleCategoryByUserId(req.params.user_id, req.params.category_name); 
      res.status(200).json(count);
    } catch (err) {
      res.status(500).json({ error: `BE: Error retrieving one category of a user ${err}` });
    }
  });

app.post('/api/user_categories/insert', /* [], */
  async (req, res) => {
    try {
      const {user_id, category_name} = req.body;
      const ins = await userCategoriesDao.insertCategory(req.body.user_id, req.body.category_name);
      res.status(201).json({ins});
    } catch (err) {
      res.status(503).json({ error: `BE: Error inserting user category ${err}` });
    }
 });

app.delete('/api/user_categories/delete', 
  async (req, res) => {
    try {
      const { user_id, category_name } = req.body;
      const del = await userCategoriesDao.deleteCategory(user_id, category_name);
      res.status(200).json({ del });
    } catch (err) {
      res.status(503).json({ error: `BE: Error deleting user category: ${err}` });
    }
  });

//CHAT API 
app.get('/api/chat/:chat_id/users',
  async (req, res) => {
    try {
      const chatUsers = await chatDao.getUsersIdByChatId(req.params.chat_id);
      res.status(200).json(chatUsers);
    } catch (err) {
      res.status(500).json({ error: `BE: Error retrieving user ids of the chat ${err}` });
    }
  });

app.get('/api/chat/:chat_id/product',
  async (req, res) => {
    try {
      const chatProduct = await chatDao.getProductIdByChatId(req.params.chat_id);
      res.status(200).json(chatProduct);
    } catch (err) {
      res.status(500).json({ error: `BE: Error retrieving product of the chat ${err}` });
    }
  });

app.get('/api/chat/:chat_id/type',
  async (req, res) => {
    try {
      const chatType = await chatDao.getChatTypeByChatId(req.params.chat_id);
      res.status(200).json(chatType);
    } catch (err) {
      res.status(500).json({ error: `BE: Error retrieving type of the chat ${err}` });
    }
  });

app.get('/api/chat/all/:user_id_1/:user_id_2',
  async (req, res) => {
    try {
      const chats = await chatDao.getAllChatsByUser(req.params.user_id_1, req.params.user_id_2);
      res.status(200).json(chats);
    } catch (err) {
      res.status(500).json({ error: `BE: Error retrieving list of chats for a user ${err}` });
    }
  });

app.get('/api/chat/:user_id_1/:user_id_2/:product_id/:sproduct_id',
  async (req, res) => {
    try {
      const chatID = await chatDao.getChatIdByUserAndProduct(req.params.user_id_1, req.params.user_id_2, req.params.product_id, req.params.sproduct_id);
      res.status(200).json(chatID);
    } catch (err) {
      res.status(500).json({ error: `BE: Error retrieving chat id from users and product ${err}` });
    }
  });

app.post('/api/chats/insert', /* [], */
  async (req, res) => {
    try {
      const {user_id_1, user_id_2, product_id, type, sproduct_id} = req.body;
      const chat_id = await chatDao.insertChat(req.body.user_id_1, req.body.user_id_2, req.body.product_id, req.body.type,req.body.sproduct_id); 
      res.status(201).json({chat_id});
    } catch (err) {
      res.status(503).json({ error: `BE: Error inserting new chat ${err}` });
    }
  });

//MESSAGE API

app.get('/api/messages/:chat_id',
  async (req, res) => {
    try {
      const messagesList = await messageDao.getMessagesByChatId(req.params.chat_id);
      res.status(200).json(messagesList);
    } catch (err) {
      res.status(500).json({ error: `BE: Error getting messages of a chat ${err}` });
    }
  });

app.post('/api/messages/insert', /* [], */
  async (req, res) => {
    try {
      const {chat_id, content, image, sender_id} = req.body;
      const message_id = await messageDao.insertNewMessage(req.body.chat_id, req.body.content, req.body.image,req.body.sender_id);
      res.status(201).json({message_id});
    } catch (err) {
      res.status(503).json({ error: `BE: Error inserting new message ${err}` });
    }
  });
  

//DONATION API 
app.post('/api/donation/insert', async (req, res) => {
  try {
      const { product_name, product_description, product_category, product_picture, donor_id, status } = req.body;
      const product_id = await donationDao.insertDonation(
          req.body.product_name, 
          req.body.product_description, 
          req.body.product_category, 
          req.body.product_picture, 
          req.body.donor_id, 
          req.body.status
      );
      res.status(201).json({ product_id });
  } catch (err) {
      res.status(503).json({ error: `BE: Error inserting new donation ${err}` });
  }
});

/*
app.delete('/api/donation/delete', 
  async (req, res) => {
    try {
      const {product_id } = req.body;
      const del = await donationDao.deleteDonation(req.body.product_id);
      res.status(200).json({ del });
    } catch (err) {
      res.status(503).json({ error: `BE: Error deleting donation: ${err}` });
    }
  });
*/

app.post('/api/donation/inactive', /* [], */
  async (req, res) => {
    try {
      const {product_id} = req.body;
      const ina = await donationDao.inactiveDonation(req.body.product_id);
      res.status(201).json({ina});
    } catch (err) {
      res.status(503).json({ error: `BE: Error inactiving donation ${err}` });
    }
  });

app.get('/api/donations/all/active',
  async (req, res) => {
    try {
      const activeDonations = await donationDao.listActiveDonations();
      res.status(200).json(activeDonations);
    } catch (err) {
      res.status(500).json({ error: `BE: Error listing all active donations ${err}` });
    }
  });

  app.get('/api/donations/:user_id/active', async (req, res) => {
    try {
      const user_id = req.params.user_id; 
      const myActiveDonations = await donationDao.listMyActiveDonations(user_id);
      res.status(200).json(myActiveDonations);
    } catch (err) {
      res.status(500).json({ error: `BE: Error listing all my active donations ${err}` });
    }
  });  

app.get('/api/donations/:user_id',
  async (req, res) => {
    try {
      const user_id = req.params.user_id;
      const myDonations = await donationDao.listAllMyDonations(user_id);
      res.status(200).json(myDonations);
    } catch (err) {
      res.status(500).json({ error: `BE: Error listing all my donations ${err}` });
    }
  });

app.get('/api/donations/:min/:max',
  async (req, res) => {
    try {
      const min = parseInt(req.params.min, 10);
      const max = parseInt(req.params.max, 10);
      const filtDonations = await donationDao.filterDonationByCoin(min, max);
      res.status(200).json(filtDonations);
    } catch (err) {
      res.status(500).json({ error: `BE: Error filtering donations by coin value ${err}` });
    }
  });

  app.get('/api/donations', async (req, res) => {
    try {
        const categories = req.query.categories;
        if (!categories || categories.length === 0) {
            return res.status(400).json({ error: 'Categories parameter is required and must contain at least one category.' });
        }
        const categoriesArray = Array.isArray(categories) ? categories : [categories];
        const filtDonations = await donationDao.filterDonationsByCategories(categoriesArray);
        res.status(200).json(filtDonations);
    } catch (err) {
        res.status(500).json({ error: `BE: Error filtering donations by categories ${err.message}` });
    }
});

  
//SHARE API
app.post('/api/sharing/insert', /* [], */
  async (req, res) => {
    try {
      const {sproduct_name, sproduct_category, sproduct_description, sproduct_start_time, sproduct_end_time, borrower_id, status} = req.body;
      const sproduct_id = await shareDao.insertSharingQuest(req.body.sproduct_name, req.body.sproduct_category, req.body.sproduct_description, req.body.sproduct_start_time, req.body.sproduct_end_time,req.body.borrower_id, req.body.status);
      res.status(201).json({sproduct_id});
    } catch (err) {
      res.status(503).json({ error: `BE: Error inserting new sharing quest ${err}` });
    }
  });

/*
app.delete('/api/sharing/delete', 
  async (req, res) => {
    try {
      const {sproduct_id} = req.body;
      const del = await shareDao.deleteSharingQuest(req.body.sproduct_id);
      res.status(200).json({ del });
    } catch (err) {
      res.status(503).json({ error: `BE: Error deleting sharing quest: ${err}` });
    }
  });*/

app.post('/api/sharing/inactive', /* [], */
  async (req, res) => {
    try {
      const {sproduct_id} = req.body;
      const ina = await shareDao.inactiveSharingQuest(req.body.sproduct_id);
      res.status(201).json({ina});
    } catch (err) {
      res.status(503).json({ error: `BE: Error inactiving sharing quest ${err}` });
    }
  });

app.get('/api/sharing/all/active',
  async (req, res) => {
    try {
      const activeSharing = await shareDao.listActiveSharingQuest();
      res.status(200).json(activeSharing);
    } catch (err) {
      res.status(500).json({ error: `BE: Error listing all active sharing quests ${err}` });
    }
  });

app.get('/api/sharing/:user_id/active',
  async (req, res) => {
    try {
      const user_id = req.params.user_id;
      const myActiveSharing = await shareDao.listMyActiveSharingQuests(user_id);
      res.status(200).json(myActiveSharing);
    } catch (err) {
      res.status(500).json({ error: `BE: Error listing all my active sharing quests ${err}` });
    }
  });

app.get('/api/sharing/:user_id',
  async (req, res) => {
    try {
      const user_id = req.params.user_id;
      const mySharing = await shareDao.listAllMySharingQuests(user_id);
      res.status(200).json(mySharing);
    } catch (err) {
      res.status(500).json({ error: `BE: Error listing all my sharing quests ${err}` });
    }
  });

app.get('/api/sharing/:min/:max',
  async (req, res) => {
    try {
      const min = parseInt(req.params.min, 10);
      const max = parseInt(req.params.max, 10);
      const filtSharing = await shareDao.filterSharingByCoin(min, max);
      res.status(200).json(filtSharing);
    } catch (err) {
      res.status(500).json({ error: `BE: Error filtering sharing quests by coin value ${err}` });
    }
  });

app.get('/api/sharing/:categories',
  async (req, res) => {
    try {
      const filtSharing = await shareDao.filterSharingByCategories(categories);
      res.status(200).json(filtSharing);
    } catch (err) {
      res.status(500).json({ error: `BE: Error filtering sharing quests by categories ${err}` });
    }
  });

  app.get('/api/sharing', async (req, res) => {
    try {
        const categories = req.query.categories
        if (!categories || categories.length === 0) {
            return res.status(400).json({ error: 'Categories parameter is required and must contain at least one category.' });
        }
        const categoriesArray = Array.isArray(categories) ? categories : [categories];
        const filtSharing = await shareDao.filterSharingByCategories(categoriesArray);
        res.status(200).json(filtSharing);
    } catch (err) {
        res.status(500).json({ error: `BE: Error filtering sharing quests by categories ${err.message}` });
    }
});

  


// start the server
app.listen(port, () => { console.log(`API server started at http://localhost:${port}`); });
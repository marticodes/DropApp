import express from 'express';
import morgan from 'morgan';
import cors from 'cors';
import { check, validationResult } from 'express-validator';

/** Authentication-related imports **/
import passport from 'passport';
import LocalStrategy from 'passport-local';

/** Creating the session */
import session from 'express-session';

import CategoriesDAO from "./Dao/CategoriesDAO.mjs"
import ChatDAO from "./Dao/ChatDAO.mjs"
import DonationDAO from "./Dao/DonationDAO.mjs"
import MessageDAO from "./Dao/MemeDAO.mjs"
import ShareDAO from "./Dao/ShareDAO.mjs"
import UserCategoriesDAO from "./Dao/UserCategoriesDao.mjs"
import UserDAO from "./Dao/UserDAO.mjs"

const categoriesDao = CategoriesDAO;
const chatDao = ChatDAO;
const donationDao = DonationDAO;
const messageDao = MessageDAO;
const shareDao = ShareDAO;
const userCategoriesDao = UserCategoriesDAO;
const userDao = new UserDAO();

const SERVER_URL = 'http://localhost:3001/api';

//init express and set up the middlewares
const app = express();
const port = 3001;
app.use(morgan('dev'));
app.use(express.json());
app.use(express.static('Img')); //path for image folder

//cors
const corsOptions = {
  origin: 'http://localhost:5173',
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

//CATEORIES API 
app.get('/api/categories/list',
  async (req, res) => {
    try {
      const categoriesList = await categoriesDao.listCategories();
      res.status(200).json(categoriesList);
    } catch (err) {
      res.status(500).json({ error: `Error retrieving categories list ${err}` });
    }
  });


//USERCATEGORIES API
app.get('/api/user_categories/all/:user_id',
  async (req, res) => {
    try {
      const allUserCategories = await userCategoriesDao.getAllCategoriesByUserId(req.params.user_id);
      res.status(200).json(allUserCategories);
    } catch (err) {
      res.status(500).json({ error: `Error retrieving all the categories of a user ${err}` });
    }
  });

app.get('/api/user_categories/one/:user_id/:category_name',
  async (req, res) => {
    try {
      const oneUsercategory = await userCategoriesDao.getSingleCategoryByUserId(req.params.user_id, req.params.category_name);
      res.status(200).json(oneUsercategory);
    } catch (err) {
      res.status(500).json({ error: `Error retrieving one category of a user ${err}` });
    }
  });

app.post('/api/user_categories/insert', /* [], */
  async (req, res) => {
    try {
      const {user_id, category_name} = req.body;
      const ins = await userCategoriesDao.insertCategory(req.body.user_id, req.body.category_name); //check what should be returned here
      res.status(201).json({ins});
    } catch (err) {
      res.status(503).json({ error: `Error inserting user category ${err}` });
    }
 });

app.delete('/api/user_categories/delete', 
  async (req, res) => {
    try {
      const { user_id, category_name } = req.body;
      const del = await userCategoriesDao.deleteCategory(user_id, category_name); //check what should be returned here
      res.status(200).json({ del });
    } catch (err) {
      res.status(503).json({ error: `Error deleting user category: ${err}` });
    }
  });

//CHAT API 
app.get('/api/chat/:chat_id/users',
  async (req, res) => {
    try {
      const chatUsers = await userCategoriesDao.getUsersIdByChatId(req.params.chat_id);
      res.status(200).json(chatUsers);
    } catch (err) {
      res.status(500).json({ error: `Error retrieving user ids of the chat ${err}` });
    }
  });

app.get('/api/chat/:chat_id/product',
  async (req, res) => {
    try {
      const chatProduct = await userCategoriesDao.getProductIdByChatId(req.params.chat_id);
      res.status(200).json(chatProduct);
    } catch (err) {
      res.status(500).json({ error: `Error retrieving product of the chat ${err}` });
    }
  });

app.get('/api/chat/:chat_id/type',
  async (req, res) => {
    try {
      const chatType = await userCategoriesDao.getChatTypeByChatId(req.params.chat_id);
      res.status(200).json(chatType);
    } catch (err) {
      res.status(500).json({ error: `Error retrieving type of the chat ${err}` });
    }
  });

app.post('/api/chats/insert', /* [], */
  async (req, res) => {
    try {
      const {userID1, userID2, product_id, type, sproduct_id} = req.body;
      const chat_id = await userCategoriesDao.insertChat(req.body.userID1, req.body.userID2, req.body.product_id, req.body.type,req.body.sproduct_id); //shoul return chat id!!
      res.status(201).json({chat_id});
    } catch (err) {
      res.status(503).json({ error: `Error inserting new chat ${err}` });
    }
  });

//MESSAGE API
//DONATION API 
//SHARE API


// start the server
app.listen(port, () => { console.log(`API server started at http://localhost:${port}`); });
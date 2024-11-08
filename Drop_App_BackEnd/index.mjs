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
//USERCATEGORIES API
//CHAT API 
//MESSAGE API
//DONATION API 
//SHARE API


// start the server
app.listen(port, () => { console.log(`API server started at http://localhost:${port}`); });
## Backend folder explanation:

### *Database*
We decided for a local SQLite database during development to avoid the restrictions of an online solution like Firebase, like daily interaction limits. This implies that the changes are only visible locally, so for the final version of the app, we plan to transition to an online database to support scalability and real-world usage.
### Models
Models are used to define the data structures within the application, representing each table in the database. These models act as the blueprint for organizing and validating the data.
### *DAO Functions*
DAO functions allow communication between the application and the database. They include MySQL queries for interacting with the database and JavaScript code to handle promises and manage asynchronous operations. Additional functions have been implemented assigne the initial coins to new users and calculating coin values for products.
### *APIs*
APIs are responsible for enabling data exchange between the frontend and backend. These functions are organized into distinct categories, corresponding to the tables in the database.
The login system is currently a simplified version, but both the database and backend code are prepared for an upgrade to a more secure structure using libraries like Passport and LocalStrategy.

## FrontEnd folder explenation:

In the frontend folder, there is the lib folder. The lib folder contains api, components, models, pages, tabs and top_bar. The api file provides the frontend api for connecting with the backend which includes many functions among which are fetching and inserting api functions. The models which provide a class for the fetched data from the  database can be found in the models folder. In order to ensure reusability of code and easy use of widgets, we have created the files in the components folder. The main tabs can be found in the tabs folder whereas pages that are obtained by navigating through a tab are present in the pages folder.  The top_bar file contains the code for the top bar which will contain the filter sandwich button, the search bar and the number of coins a user has.

**Instructions**

Once the prototype has started, the first page shown will be the login. Please, enter with the following credentials.
student_id: 20246475
password: try12345

Github

1. Open the Github page of the project and copy the link. 
    
2. Create a new folder into your computer. Open the folder, press the right button of your mouse and press “Open Git Bash”.
    
3. In the terminal write the following:

```jsx
git clone repository_url
```

If git is not installed in your computer, you can download the zipped folder directly from the Github page.

## Node

1. Install Node [1] following the instructions on the website.
2. To check if Node has been correctly installed, type this command into the terminal of your pc:

```jsx
node -v
```

## Npm

1. npm is installed automatically when you download Node, but in case of errors you can type:

```jsx
Set-ExecutionPolicy Unrestricted
```

### VSCode

1. Open a project and open the “Extensions” section of VScode
    
2. Type “Flutter”, open the first result and install it.
    

1. VSCode will give an allert about the SDK missing. Press download. ALLERT: pay attention to the folder you are downloading flutter in.
    
2. Open the System Variable and add the path of the flutter/bin folder to the Path section.
    
3. Open the VSCode terminal and execute the following commands:

```jsx
cd backend
npm install
npm rebuild sqlite3
node index.mjs
```

1. Open a second terminal in VSCode and execute the following commands:

```jsx
cd frontend
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

## References

[1]: [https://nodejs.org/en/download/package-manager](https://nodejs.org/en/download/package-manager)

## Libraries and Frameworks

Libraries used for similarity search within products file:

```jsx
import { readFileSync } from 'fs';
import pkg from 'natural';
const { PorterStemmer } = pkg; 
import { compareTwoStrings } from 'string-similarity'; 
```

Libraries used respectively for APIs management, Cross Origin interaction, Session and Login:

```jsx
import express from 'express';
import morgan from 'morgan';
import { check, validationResult } from 'express-validator';
import cors from 'cors';

/** Authentication-related imports **/
import passport from 'passport';
import LocalStrategy from 'passport-local';
import crypto from "crypto";

/** Creating the session */
import session from 'express-session';
```

The login and sign-up form in the front end are also created following layouts available on the internet and the adapted to our application.

Libraries used respectively for APIs dart conversion, page structure and dates handling:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';




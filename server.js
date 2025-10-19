import express from 'express';
import session from 'express-session';
import checkAuth  from './middlewares/auth.middleware.js';
import createPool from './config/db.js'
import authRouter from './routes/auth.routes.js'
import dbActionsRouter from './routes/db-actions.routes.js'

const app = express();
const port = 4000;

//view teempalte
app.set('view engine', 'ejs');

app.use(express.urlencoded({ extended: true }));

app.use(session({
    secret: 'sweterwytyryrtrertete', 
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false } 
}));



// auth routes
app.use('/', authRouter);


// home
app.get('/', checkAuth, async (req, res) => {
    try {
        const pool = createPool(req.session.dbConfig);

        const [dbs] = await pool.query('SHOW DATABASES;');
        const [users] = await pool.query("SELECT User, Host FROM mysql.user;");

        res.render('home', {
            databases: dbs, 
            users: users
        });
        
    } catch (err) {
        res.status(500).send('Error');
    }
});

// auth routes
app.use('/',checkAuth ,dbActionsRouter);



// run server
app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
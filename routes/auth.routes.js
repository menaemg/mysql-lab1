import { Router } from 'express';
import createPool from '../config/db.js';

const router = Router();


// login page
router.get('/login', (req, res) => {
    res.render('login', { error: null });
});

// Login check 
router.post('/login', async (req, res) => {
    const { host, username, password } = req.body;
    
    const dbConfig = { host, user: username, password };

    try {
        const pool = createPool(dbConfig);
        const connection = await pool.getConnection();
        connection.release();

        req.session.dbConfig = dbConfig;
        
        res.redirect('/');

    } catch (err) {
        console.error('login error:', err.message);
        res.render('login', { error: 'invalid data' });
    }
});

router.get('/logout', (req, res) => {
    req.session.destroy(err => {
        res.redirect('/login');
    });
});

export default router; 
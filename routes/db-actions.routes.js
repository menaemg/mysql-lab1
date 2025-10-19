import { Router } from 'express';
import createPool from '../config/db.js';

const router = Router();

// add db
router.post('/add-db', async (req, res) => {
    const { dbName } = req.body;
    try {
        const pool = createPool(req.session.dbConfig);
        await pool.query('CREATE DATABASE ??;', [dbName]);
        res.redirect('/');
    } catch (err) {
        console.error('Add DB error:', err.message);
        res.status(500).send('Failed to create database.');
    }
});

// add user
router.post('/add-user', async (req, res) => {
    const { newUser, newPass, dbPrivileges } = req.body;
    try {
        const pool = createPool(req.session.dbConfig);
    
        await pool.query("CREATE USER ??@'localhost' IDENTIFIED BY ?;", [newUser, newPass]);

        // add user to database 
        await pool.query(`GRANT ALL PRIVILEGES ON \`${dbPrivileges}\`.* TO ??@'localhost';`, [newUser]);

        await pool.query('FLUSH PRIVILEGES;');
        
        res.redirect('/');
    } catch (err)
        {
        console.error('Add User error:', err.message);
        res.status(500).send('Failed to create user.');
    }
});

// add table
router.post('/add-table', async (req, res) => {
    const { selectedDb, tableName } = req.body;
    try {
        const pool = createPool(req.session.dbConfig);

        const safeQuery = `CREATE TABLE ??.?? (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255));`;
        
        await pool.query(safeQuery, [selectedDb, tableName]);
        
        res.redirect('/');
    } catch (err) {
        console.error('Add Table error:', err.message);
        res.status(500).send('Failed to create table.');
    }
});

export default router; 
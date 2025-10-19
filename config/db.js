import mysql from 'mysql2/promise';

export default function createPool(config) {
    return mysql.createPool({
        ...config,
        connectionLimit: 10,
        waitForConnections: true,
        queueLimit: 0
    });
}
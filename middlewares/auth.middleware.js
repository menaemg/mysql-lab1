export default function checkAuth(req, res, next) {
    if (req.session.dbConfig) {
        next();
    } else {
        res.redirect('/login'); 
    }
}

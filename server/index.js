require('dotenv').config(); // this will get hte configs from the production or current environment
const {server} = require('./src/app');






server.listen(process.env.PORT||5000 ,'0.0.0.0',
()=>console.log(`server is currently running on port ${process.env.PORT}`));



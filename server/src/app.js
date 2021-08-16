const express = require('express');
const app = express();
const server = require('http').createServer(app);
const helmet = require('helmet');
const morgan = require('morgan');
//working withe file upload feature
const fileUpload = require('express-fileupload');

const path = require('path');



app.use(fileUpload({
    limits: { fileSize: 3 * 1000 * 1000 }, // 1mb to 1*10^6 bytes
    abortOnLimit : true,
}));

//application functionality
app.use(express.json());

app.use(helmet());

app.use(morgan('tiny'));

//application main routes 

app.use("/uploads",require("express").static('./uploads/'));

/*
app.get("/image.png", (req, res) => {
    res.sendFile(path.join('./4ac8c96e-dfa5-46e4-96c3-810746e7f770/ProfileImages/',"egy-bugs-logo.PNG"),{root:'./uploads'});
});
*/
app.use('/teacher_care',require('../routes/userUtils/user')); // this is where all the common user utils will obtained 

app.use('/teacher_care',require('../routes/users/admin_teacher_auth'));

app.use('/teacher_care',require('../routes/userUtils/globalStudentReportToAll'));

app.use('/teacher_care',require('../routes/userUtils/student'));

app.use('/teacher_care',require('../routes/users/parent_auth'));

app.use('/teacher_care',require('../routes/systemUserData/teacher'));

app.use('/teacher_care',require('../routes/room/room'));

app.use('/teacher_care',require('../routes/users/teacher_student_auth'));

app.use('/teacher_care' , require('../routes/userUtils/teacher'));

app.use('/teacher_care',require('../routes/users/moderator_teacher_auth'));

app.use('/teacher_care',require('../routes/users/moderator_auth'));

app.use('/teacher_care',require('../routes/userUtils/moderator'));

app.use('/teacher_care',require('../routes/users/user_auth'));''

app.use('/teacher_care' ,require('../routes/address/address'));

app.use('/teacher_care' ,require('../routes/users/account_state'));

app.use('/teacher_care', require('../routes/level/level'));

app.use('/teacher_care', require('../routes/subject/subject'));


// app.use('/',(req,res)=>{
//     return res.send('message from the server means that ur end points working fine');
// });



module.exports = {
    app : app,
    server : server,
}